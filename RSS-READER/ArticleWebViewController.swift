//
//  ArticleWebViewController.swift
//  RSS-READER
//
//  Created by Toshihiko Kubo on 2016/04/10.
//  Copyright © 2016年 Toshihiko Kubo. All rights reserved.
//

import UIKit
import WebKit
import Social

class ArticleWebViewController: UIViewController, WKNavigationDelegate {
    
    let black = UIColor(red: 50.0 / 255, green: 56.0 / 255, blue: 60.0 / 255, alpha: 1.0)
    let wkWebView = WKWebView()
    
    let backgroundView = UIView()
    let shareView = UIView()
    
    var article: Article!
    var articleStocks = ArticleStocks.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: "showActionMenu")
        self.navigationController!.setNavigationBarHidden(false, animated: true)
        self.navigationController!.navigationBar.barTintColor = black
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController!.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "HirakakuProN-W6", size: 15)!, NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        let URL = NSURL(string: self.article.link)
        let URLReq = NSURLRequest(URL: URL!)
        
        self.wkWebView.navigationDelegate = self
        self.wkWebView.frame = self.view.frame
        self.wkWebView.loadRequest(URLReq)
        self.view.addSubview(wkWebView)

        // Do any additional setup after loading the view.
    }
    
    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.navigationItem.title = "読み込み中..."
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        self.navigationItem.title = wkWebView.title
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showActionMenu() {
        setBackgroundView()
        setShareView()
        setShareBtn(self.view.frame.width/8, tag: 1, imageName: "facebook_icon")
        setShareBtn(self.view.frame.width/8 * 3, tag: 2, imageName: "twitter_icon")
        setShareBtn(self.view.frame.width/8 * 5, tag: 3, imageName: "safari_icon")
        setShareBtn(self.view.frame.width/8 * 7, tag: 4, imageName: "bookmark_icon")
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.shareView.frame.origin = CGPointMake(0, self.view.frame.height - 100)
        })
    }
    
    func setBackgroundView() {
        backgroundView.frame.size = self.view.frame.size
        backgroundView.frame.origin = CGPointMake(0, 0)
        backgroundView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        self.view.addSubview(backgroundView)
        
        let gesture = UITapGestureRecognizer(target: self, action: "tapBackgroundView")
        backgroundView.addGestureRecognizer(gesture)
    }
    
    func setShareView(){
        shareView.frame = CGRectMake(0, self.view.frame.height, self.view.frame.width, 100)
        shareView.backgroundColor = UIColor.whiteColor()
        shareView.layer.cornerRadius = 3
        backgroundView.addSubview(shareView)
    }
    
    func setShareBtn(x: CGFloat, tag: Int, imageName: String){
        let shareBtn = UIButton()
        shareBtn.frame.size = CGSizeMake(60, 60)
        shareBtn.center = CGPointMake(x, 50)
        shareBtn.setBackgroundImage(UIImage(named: imageName), forState: UIControlState.Normal)
        shareBtn.layer.cornerRadius = 3
        shareBtn.tag = tag
        shareBtn.addTarget(self, action: "tapSharebtn:", forControlEvents: UIControlEvents.TouchUpInside)
        shareView.addSubview(shareBtn)
    }
    
    func tapSharebtn(sender: UIButton){
        if sender.tag == 1 {
            let facebookVC = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            facebookVC.setInitialText(wkWebView.title)
            facebookVC.addURL(wkWebView.URL)
            presentViewController(facebookVC, animated: true, completion: nil)
        } else if sender.tag == 2 {
            let twitterVC = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            twitterVC.setInitialText(wkWebView.title)
            twitterVC.addURL(wkWebView.URL)
            presentViewController(twitterVC, animated: true, completion: nil)
        } else if sender.tag == 3 {
            UIApplication.sharedApplication().openURL(wkWebView.URL!)
        } else if sender.tag == 4 {
            if isStockedArticle() {
                showAlert("既に登録してあります。")
            } else {
                self.articleStocks.addArticleStocks(self.article)
                showAlert("ブックマークに保存しました。")
            }
        }
    }
    
    func showAlert(text: String){
        let alertController = UIAlertController(title: text, message: nil , preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (action) -> Void in
            self.backgroundView.removeFromSuperview()
        }
        alertController.addAction(action)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func isStockedArticle() -> Bool {
        for myArticle in self.articleStocks.myArticles {
            if myArticle.link == self.article.link {
                return true
            }
        }
        return false

    }
    
    func tapBackgroundView(){
        backgroundView.removeFromSuperview()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
