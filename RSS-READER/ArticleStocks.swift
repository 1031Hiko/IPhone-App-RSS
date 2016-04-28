//
//  ArticleStocks.swift
//  RSS-READER
//
//  Created by Toshihiko Kubo on 2016/04/11.
//  Copyright © 2016年 Toshihiko Kubo. All rights reserved.
//

import UIKit

class ArticleStocks: NSObject {
    
    static let sharedInstance = ArticleStocks()
    var myArticles: Array<Article> = []
    
    func addArticleStocks(article: Article) {
        self.myArticles.insert(article, atIndex: 0)
        saveArticle()
    }
    
    func saveArticle(){
        var tmpArticles: Array<Dictionary<String, AnyObject>> = []
        for myArticle in self.myArticles {
            let articleDic = ArticleStocks.convertDictionary(myArticle)
            tmpArticles.append(articleDic)
        }
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(tmpArticles, forKey: "myArticles")
        defaults.synchronize()
    }
    
    func getMyArticles(){
        let defaults = NSUserDefaults.standardUserDefaults()
        if let articles = defaults.objectForKey("myArticles") as? Array<Dictionary<String, String>> {
            for dic in articles {
                let article = ArticleStocks.convertArticleModel(dic)
                self.myArticles.append(article)
            }
        }
    }
    
    class func convertArticleModel(dic: Dictionary<String, String>) -> Article {
        let article = Article()
        article.title = dic["title"]!
        article.descript = dic["descript"]!
        article.date = dic["date"]!
        article.link = dic["link"]!
        return article
    }

    
    class func convertDictionary(article: Article) -> Dictionary<String, AnyObject>{
        var dic = Dictionary<String, AnyObject>()
        dic["title"] = article.title
        dic["descript"] = article.descript
        dic["date"] = article.date
        dic["link"] = article.link
        return dic
    }
    
    func removeMyArticle(index: Int){
        self.myArticles.removeAtIndex(index)
        saveArticle()
    }
}
