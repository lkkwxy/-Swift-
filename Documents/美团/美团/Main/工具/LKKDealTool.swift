//
//  LKKDealTool.swift
//  美团
//
//  Created by 李坤坤 on 15/8/24.
//  Copyright © 2015年 李坤坤. All rights reserved.
//

import UIKit

class LKKDealTool: NSObject {
    static var db:COpaquePointer = nil
    override class func initialize(){
        let documentName = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).last
        let filePath = documentName! + "/deal.sqlite"
        var result = sqlite3_open((filePath as NSString).UTF8String, &db)
        if result == SQLITE_OK {
            let collectSql = "CREATE TABLE IF NOT EXISTS t_collect_deal(id integer PRIMARY KEY, deal blob NOT NULL, deal_id text NOT NULL);"
            let recentSql = "CREATE TABLE IF NOT EXISTS t_recent_deal(id integer PRIMARY KEY, deal blob NOT NULL, deal_id text NOT NULL,date text);"
            result = sqlite3_exec(db, (collectSql as NSString).UTF8String, nil, nil, nil)
            result = sqlite3_exec(db, (recentSql as NSString).UTF8String, nil, nil, nil)
            if result == SQLITE_OK {
                print("创表成功")
            }
        }
    }
    class func collectDeals(page:Int) -> [LKKDeal]{
        let size = 20
        let position = (page - 1) * size
        let sql:NSString = NSString(format: "SELECT deal,deal_id FROM t_collect_deal ORDER BY id DESC LIMIT %d,%d;",position,size)
        var stmt:COpaquePointer = nil
        let result = sqlite3_prepare_v2(db, sql.UTF8String, -1, &stmt, nil)
        var deals = Array<LKKDeal>()
        if result == SQLITE_OK {
            while (sqlite3_step(stmt) == SQLITE_ROW){
                let dealBlob = sqlite3_column_blob(stmt, 0)
                let dealSize = sqlite3_column_bytes(stmt, 0)
                let dealData = NSData(bytes: dealBlob, length: Int(dealSize))
                let deal = NSKeyedUnarchiver.unarchiveObjectWithData(dealData) as! LKKDeal
                deals.append(deal)
            }
        }
        return deals
    }
    class func addCollect(deal:LKKDeal){
        let data = NSKeyedArchiver.archivedDataWithRootObject(deal)
        let sql:NSString = NSString(format: "INSERT INTO t_collect_deal(deal, deal_id) VALUES(?, %@);",deal.deal_id!)
        var stmt:COpaquePointer = nil
        var result = sqlite3_prepare_v2(db, sql.UTF8String, -1, &stmt, nil)
        result = sqlite3_bind_blob(stmt, 1, data.bytes, Int32(data.length), nil)
        result = sqlite3_step(stmt)
        if (result == SQLITE_DONE) {
            print("存入成功");
        }
    }
    class func removeCollect(deal:LKKDeal){
        let sql = NSString(format: "DELETE FROM t_collect_deal WHERE deal_id = %@;", deal.deal_id!)
        let result = sqlite3_exec(db, sql.UTF8String, nil, nil, nil)
        print(result)
    }
    class func isCollected(dela:LKKDeal) -> Bool{
        let sql:NSString = NSString(format: "SELECT deal,deal_id FROM t_collect_deal where deal_id = %@",dela.deal_id!)
        var stmt:COpaquePointer = nil
        let result = sqlite3_prepare_v2(db, sql.UTF8String, -1, &stmt, nil)
        if result == SQLITE_OK {
            if (sqlite3_step(stmt) == SQLITE_ROW){
                let dealBlob = sqlite3_column_blob(stmt, 0)
                let dealSize = sqlite3_column_bytes(stmt, 0)
                let dealData = NSData(bytes: dealBlob, length: Int(dealSize))
                let dealTmp = NSKeyedUnarchiver.unarchiveObjectWithData(dealData) as! LKKDeal
                let ID:NSString = dela.deal_id!
                if ID.isEqualToString(dealTmp.deal_id!){
                    return true
                }
            }
        }
        return false
    }
    class func collectDealsCount() -> Int{
        let sql:NSString = "SELECT count(*) AS deal_count FROM t_collect_deal;"
        var stmt:COpaquePointer = nil
        let result = sqlite3_prepare_v2(db, sql.UTF8String, -1, &stmt, nil)
        if result == SQLITE_OK {
            if (sqlite3_step(stmt) == SQLITE_ROW){
                let count = sqlite3_column_int(stmt, 0)
                return Int(count)
            }
        }
        return 0
    }
    class func recentDeals(page:Int) -> [LKKDeal]{
        let size = 20
        let position = (page - 1) * size
        let sql:NSString = NSString(format: "SELECT deal,deal_id FROM t_recent_deal ORDER BY date DESC LIMIT %d,%d;",position,size)
        var stmt:COpaquePointer = nil
        let result = sqlite3_prepare_v2(db, sql.UTF8String, -1, &stmt, nil)
        var deals = Array<LKKDeal>()
        if result == SQLITE_OK {
            while (sqlite3_step(stmt) == SQLITE_ROW){
                let dealBlob = sqlite3_column_blob(stmt, 0)
                let dealSize = sqlite3_column_bytes(stmt, 0)
                let dealData = NSData(bytes: dealBlob, length: Int(dealSize))
                let deal = NSKeyedUnarchiver.unarchiveObjectWithData(dealData) as! LKKDeal
                deals.append(deal)
            }
        }
        return deals
    }
    class func addRecent(deal:LKKDeal){
        let date = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmssSSS"
        if isRecent(deal){
            let sql = NSString(format: "UPDATE  t_recent_deal set date = %@;",dateFormatter.stringFromDate(date))
            let result = sqlite3_exec(db, sql.UTF8String, nil, nil, nil)
            print(result)
            return
        }
        let data = NSKeyedArchiver.archivedDataWithRootObject(deal)
        let sql:NSString = NSString(format: "INSERT INTO t_recent_deal(deal,deal_id,date) VALUES(?, %@,%@);",deal.deal_id!,dateFormatter.stringFromDate(date))
        var stmt:COpaquePointer = nil
        var result = sqlite3_prepare_v2(db, sql.UTF8String, -1, &stmt, nil)
        result = sqlite3_bind_blob(stmt, 1, data.bytes, Int32(data.length), nil)
        result = sqlite3_step(stmt)
        if (result == SQLITE_DONE) {
            print("存入成功");
        }
    }
    class func removeRecent(deal:LKKDeal){
        let sql = NSString(format: "DELETE FROM t_recent_deal WHERE deal_id = %@;", deal.deal_id!)
        let result = sqlite3_exec(db, sql.UTF8String, nil, nil, nil)
        print(result)
    }
    class func isRecent(dela:LKKDeal) -> Bool{
        let sql:NSString = NSString(format: "SELECT deal,deal_id FROM t_recent_deal where deal_id = %@",dela.deal_id!)
        var stmt:COpaquePointer = nil
        let result = sqlite3_prepare_v2(db, sql.UTF8String, -1, &stmt, nil)
        if result == SQLITE_OK {
            if (sqlite3_step(stmt) == SQLITE_ROW){
                let dealBlob = sqlite3_column_blob(stmt, 0)
                let dealSize = sqlite3_column_bytes(stmt, 0)
                let dealData = NSData(bytes: dealBlob, length: Int(dealSize))
                let dealTmp = NSKeyedUnarchiver.unarchiveObjectWithData(dealData) as! LKKDeal
                let ID:NSString = dela.deal_id!
                if ID.isEqualToString(dealTmp.deal_id!){
                    return true
                }
            }
        }
        return false
    }
    class func recentDealsCount() -> Int{
        let sql:NSString = "SELECT count(*) AS deal_count FROM t_recent_deal;"
        var stmt:COpaquePointer = nil
        let result = sqlite3_prepare_v2(db, sql.UTF8String, -1, &stmt, nil)
        if result == SQLITE_OK {
            if (sqlite3_step(stmt) == SQLITE_ROW){
                let count = sqlite3_column_int(stmt, 0)
                return Int(count)
            }
        }
        return 0
    }
}


