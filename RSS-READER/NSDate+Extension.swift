//
//  NSDate+Extension.swift
//  RSS-READER
//
//  Created by Toshihiko Kubo on 2016/04/11.
//  Copyright © 2016年 Toshihiko Kubo. All rights reserved.
//

import Foundation

extension NSDate {
    
    //文字列をNSDateに変換
    class func convertDateFromString(dateString: String) -> NSDate {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss Z"
        formatter.locale = NSLocale(localeIdentifier: "en_US")
        let date: NSDate! = formatter.dateFromString(dateString)
        return date
    }
    
    //NSDateを文字列に変換
    func convertStringFromDate() -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyy/MM/dd HH:mm"
        let outputString = formatter.stringFromDate(self)
        return outputString
    }
    
}
