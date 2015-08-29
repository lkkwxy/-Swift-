//
//  LKKDeal.swift
//  美团
//
//  Created by 李坤坤 on 15/8/23.
//  Copyright © 2015年 李坤坤. All rights reserved.
//

import UIKit

class LKKDeal: NSObject,NSCoding {
    /** 是否选中*/
    var isChecking:Bool = false
    /** 是否编辑*/
    var isEdit:Bool = false
    /** 团购单ID */
    var deal_id:String?
    /** 团购标题 */
    var title:String?
    /** 团购描述 */
    var desc:String?
    /** 如果想完整地保留服务器返回数字的小数位数(没有小数\1位小数\2位小数等),那么就应该用NSNumber */
    /** 团购包含商品原价值 */
    var list_price:NSNumber?
    /** 团购价格 */
    var current_price:NSNumber?
    /** 团购当前已购买数 */
    var purchase_count:NSNumber?
    /** 团购图片链接，最大图片尺寸450×280 */
    var image_url:String?
    /** 小尺寸团购图片链接，最大图片尺寸160×100 */
    var s_image_url:String?
    /** 团购发布上线日期 */
    var publish_date:String?
    /** 团购单的截止购买日期 */
    var purchase_deadline:String?
    /**团购HTML5页面链接*/
    var deal_h5_url:String?
    /** 团购限制条件 */
    var restrictions:LKKRestrictions?
    /**  团购所属分类 NSString */
    var categories:NSArray?
    var businesses:NSArray?
    override func objectClassInArray() -> NSDictionary {
        return ["businesses" : "LKKBusiness"]
    }
    func encodeWithCoder(aCoder: NSCoder){
        aCoder.encodeObject(deal_id, forKey: "deal_id")
        aCoder.encodeObject(title, forKey: "title")
        aCoder.encodeObject(desc, forKey: "desc")
        aCoder.encodeObject(list_price, forKey: "list_price")
        aCoder.encodeObject(current_price, forKey: "current_price")
        aCoder.encodeObject(image_url, forKey: "image_url")
        aCoder.encodeObject(purchase_count, forKey: "purchase_count")
        aCoder.encodeObject(s_image_url, forKey: "s_image_url")
        aCoder.encodeObject(publish_date, forKey: "publish_date")
        aCoder.encodeObject(deal_h5_url, forKey: "deal_h5_url")
        aCoder.encodeObject(restrictions, forKey: "restrictions")
    }
    override init() {
        super.init()
    }
    required init?(coder aDecoder: NSCoder){
        super.init()
        deal_id = aDecoder.decodeObjectForKey("deal_id") as? String
        title = aDecoder.decodeObjectForKey("title") as? String
        desc = aDecoder.decodeObjectForKey("desc") as? String
        list_price = aDecoder.decodeObjectForKey("list_price") as? NSNumber
        current_price = aDecoder.decodeObjectForKey("current_price") as? NSNumber
        purchase_count = aDecoder.decodeObjectForKey("purchase_count") as? NSNumber
        image_url = aDecoder.decodeObjectForKey("image_url") as? String
        s_image_url = aDecoder.decodeObjectForKey("s_image_url") as? String
        publish_date = aDecoder.decodeObjectForKey("publish_date") as? String
        deal_h5_url = aDecoder.decodeObjectForKey("deal_h5_url") as? String
        restrictions = aDecoder.decodeObjectForKey("restrictions") as? LKKRestrictions
    }
    override func replacedKeyFromPropertyName() -> NSDictionary {
        return ["desc":"description"]
    }
}
func ==(lhs:LKKDeal,rhs:LKKDeal) -> Bool{
    return lhs.deal_id! == rhs.deal_id!
}
class LKKRestrictions: NSObject,NSCoding {
    /** 是否需要预约，0：不是，1：是 */
    var is_reservation_required:NSNumber?
    /** 是否支持随时退款，0：不是，1：是*/
    var is_refundable:NSNumber?
    /** 附加信息(一般为团购信息的特别提示)*/
    var special_tips:String?
    override init() {
        super.init()
    }
    func encodeWithCoder(aCoder: NSCoder){
        aCoder.encodeObject(is_reservation_required, forKey: "is_reservation_required")
        aCoder.encodeObject(is_refundable, forKey: "is_refundable")
        aCoder.encodeObject(special_tips, forKey: "special_tips")
    }
    required init?(coder aDecoder: NSCoder){
        super.init()
        is_reservation_required = aDecoder.decodeObjectForKey("is_reservation_required") as? NSNumber
        is_refundable = aDecoder.decodeObjectForKey("is_refundable") as? NSNumber
        special_tips = aDecoder.decodeObjectForKey("special_tips") as? String
    }
    
}
class LKKBusiness : NSObject{
    /** 商户名 */
    var name:String?
    /** 商户ID */
    var ID:String?
    /** 商户城市 */
    var city:String?
    /** 纬度 */
    var latitude:NSNumber?
    /** 经度 */
    var longitude:NSNumber?
    /** 商户页面链接，适用于网页应用 */
    var url:String?
    /** 商户HTML5页面链接，适用于移动应用和联网车载应用 */
    var h5_url:String?
    /** 商户地址 */
    var address:String?
}


