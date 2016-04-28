//
//  ViewController.swift
//  RSS-READER
//
//  Created by Toshihiko Kubo on 2016/04/08.
//  Copyright © 2016年 Toshihiko Kubo. All rights reserved.
//

import UIKit



class ArticleViewController: UIViewController, UIScrollViewDelegate, ArticleTableViewDelegate {
    @IBOutlet weak var sitesScrollView: UIScrollView!
    @IBOutlet weak var headerView: UIView!
    
    //ボタンを管理するための配列を定義
    var tabButtons:Array<UIButton> = []

    
    let wired = "WIRED"
    let shiki = "100SHIKI"
    let cinra = "CINRA.NET"
    
    let wiredImageName = "wired_top_image.png"
    let shikiImageName = "100shiki_top_image.png"
    let cinraImageName = "cinra_top_image.png"
    
    let blue = UIColor(red: 92.0 / 255, green: 192.0 / 255, blue: 210.0 / 255, alpha: 1.0)
    let yellow = UIColor(red: 105.0 / 255, green: 207.0 / 255, blue: 153.0 / 255, alpha: 1.0)
    let red = UIColor(red: 195.0 / 255, green: 123.0 / 255, blue: 175.0 / 255, alpha: 1.0)
    let black = UIColor(red: 50.0 / 255, green: 56.0 / 255, blue: 60.0 / 255, alpha: 1.0)
    
    let wiredURL = "http://wired.jp/rssfeeder/"
    let shikiURL =  "http://www.100shiki.com/feed"
    let cinraURL =   "http://www.cinra.net/feed"
    
    var currentSelectedArticle: Article?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.performSegueWithIdentifier("ShowToArticleWebViewController", sender: nil)
        
        sitesScrollView.delegate = self
        
        self.sitesScrollView.contentSize = CGSizeMake(self.view.frame.width * 3, self.sitesScrollView.frame.height)
        self.sitesScrollView.pagingEnabled = true
        
        
        //ArticleTableViewのインスタンスを生成
        setArticleTableView(0, siteName: wired, siteImageName: wiredImageName, color: blue, siteURL: wiredURL)
        setArticleTableView(self.view.frame.width, siteName: shiki, siteImageName: shikiImageName, color: red, siteURL: shikiURL)
        setArticleTableView(self.view.frame.width * 2, siteName: cinra, siteImageName: cinraImageName, color: yellow, siteURL: cinraURL)
        
        
        // buttonの設置
        setTabButton(self.view.center.x/2, text: "W", color: blue, tag: 1)
        setTabButton(self.view.center.x, text: "100", color: red, tag: 2)
        setTabButton(self.view.center.x*3/2, text: "C", color: yellow, tag: 3)
        
        setSelectedButton(tabButtons[0], selected: true)
        
        ArticleStocks.sharedInstance.getMyArticles()
        
    }
    
    func didSelectTableViewCell(article: Article) {
        print("セルがタップされました。")
        self.currentSelectedArticle = article
        self.performSegueWithIdentifier("ShowToArticleWebViewController", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let articleWebViewController = segue.destinationViewController as! ArticleWebViewController
        articleWebViewController.article = self.currentSelectedArticle
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController!.setNavigationBarHidden(true, animated: true)
    }
    
    func tapTabButton(sender: UIButton){
        let pointX = self.view.frame.width * CGFloat(sender.tag - 1)
        sitesScrollView.setContentOffset(CGPointMake(pointX, 0), animated: true)
    }
    
    //ArticleTableViewを生成するためのメソッド
    func setArticleTableView(x: CGFloat, siteName: String, siteImageName: String, color: UIColor, siteURL: String){
        let frame = CGRectMake(x, 0, self.view.frame.width, sitesScrollView.frame.height)
        let articleTableView = ArticleTableView(frame: frame, style: UITableViewStyle.Plain)
        articleTableView.customDelegate = self
        articleTableView.loadRSS(siteURL)
        articleTableView.siteName = siteName
        articleTableView.siteImageName = siteImageName
        articleTableView.color = color
        sitesScrollView.addSubview(articleTableView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    buttonメソッドの定義
    func setTabButton(x: CGFloat, text: String, color: UIColor, tag: Int){
        let tabButton = UIButton()
        tabButton.frame.size = CGSizeMake(36, 36)
        tabButton.center = CGPointMake(x, 44)
        tabButton.setTitle(text, forState: UIControlState.Normal)
        tabButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        tabButton.setTitleColor(color, forState: UIControlState.Selected)
        tabButton.titleLabel?.font = UIFont(name: "HirakakuProN-W6", size: 13)
        tabButton.backgroundColor = black
        tabButton.tag = tag
        tabButton.addTarget(self, action: "tapTabButton:", forControlEvents: UIControlEvents.TouchUpInside)
        tabButton.layer.cornerRadius = 18
        tabButton.layer.borderColor = UIColor.whiteColor().CGColor
        tabButton.layer.borderWidth = 1
        tabButton.layer.masksToBounds = true
        self.headerView.addSubview(tabButton)
        tabButtons.append(tabButton)
    }
    
    //スクロールが停止したタイミングで呼び出されるメソッド(自動スクロールが終了時に呼ばれる)
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x / scrollView.frame.width //ページは0,2,3になる
        for i in 0..<3 {
            if page == CGFloat(i) {
                setSelectedButton(tabButtons[i], selected: true)
            } else {
                setSelectedButton(tabButtons[i], selected: false)
            }
        }
    }
    
//スクロールが停止したタイミングで呼び出されるメソッド(ドラッグでのスクロールが終了時に呼ばれる)
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        let page = scrollView.contentOffset.x / scrollView.frame.width
        
        for i in 0..<3 {
            if page == CGFloat(i) {
                setSelectedButton(tabButtons[i], selected: true)
            } else {
                setSelectedButton(tabButtons[i], selected: false)
            }
        }
    }
    
    func setSelectedButton(button: UIButton, selected: Bool) {
        button.selected = selected
        button.layer.borderColor = button.titleLabel?.textColor.CGColor
    }


}

