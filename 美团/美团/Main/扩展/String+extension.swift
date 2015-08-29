//
//  String+extension.swift
//  美团
//
//  Created by 李坤坤 on 15/8/26.
//  Copyright © 2015年 李坤坤. All rights reserved.
//

import Foundation
//Optional("2015-09-28")
extension String{
    func byNowDateString() -> String{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.dateFromString(self)
        if let _ = date{
            let nowDate = NSDate()
            var spceTime = date!.timeIntervalSinceDate(nowDate)
            spceTime += 24 * 3600
            let calendar = NSCalendar.currentCalendar()
            let unitValue = NSCalendarUnit.Day.rawValue | NSCalendarUnit.Hour.rawValue | NSCalendarUnit.Minute.rawValue
            
            let unit = NSCalendarUnit(rawValue: unitValue)
            let cmps = calendar.components(unit, fromDate: nowDate, toDate: date!, options: NSCalendarOptions.WrapComponents)
            if cmps.day > 365 {
                return "一年之内不过期"
            }else{
                return "\(cmps.day)天\(cmps.hour)小时\(cmps.minute)分钟"
            }
        }
        return "已过期"
    }
}