//
//  LKKNetWorkTool.swift
//  美团
//
//  Created by 李坤坤 on 15/8/22.
//  Copyright © 2015年 李坤坤. All rights reserved.
//

import UIKit
typealias successBlock = (NSData?,NSError?,NSURLRequest) -> Void
class LKKNetWorkTool: NSObject {
    static let kDPAppKey = "975791789"
    static let kDPAppSecret = "5e4dcaf696394707b9a0139e40074ce9"
    static let kDPUrl = "http://api.dianping.com/"
    class func request(urlStr:String!,params:NSDictionary,success:successBlock) -> NSURLRequest{
        var signString:NSString = kDPAppKey;
        var paramsString:NSString = "appkey=" + kDPAppKey
        var sortedKeys = params.allKeys as NSArray
        sortedKeys = sortedKeys.sortedArrayUsingSelector("compare:")
        for key in sortedKeys {
            let value = String(format: "%@", arguments: [params[key as! String] as! CVarArgType])
            signString = signString.stringByAppendingString((key as! String) + value)
            paramsString = paramsString.stringByAppendingString("&" + (key as! String) + "=" + value)
        }
        signString = signString.stringByAppendingString(kDPAppSecret)
        let sign = (signString as String).sha1()
        paramsString = paramsString.stringByAppendingString("&sign=\(sign)")
        let tmp = kDPUrl + urlStr + "?" + (paramsString as String)
        
//        var url = NSURL(string: tmp.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)
//        print(url)
        let url = NSURL(string: tmp.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLFragmentAllowedCharacterSet())!)
        let session = NSURLSession.sharedSession()
        let request = NSURLRequest(URL: url!)
        let dataTask = session.dataTaskWithRequest(request) { (data, URLResponse, error) -> Void in
            dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                success(data,error,request)
            })
        }
        dataTask.resume()
        return request
    }
}
extension String {
    func sha1() -> String {
        let data = self.dataUsingEncoding(NSUTF8StringEncoding)!
        var digest = [UInt8](count:Int(CC_SHA1_DIGEST_LENGTH), repeatedValue: 0)
        CC_SHA1(data.bytes, CC_LONG(data.length), &digest)
        let sha1 = NSMutableString()
        for char in digest {
            sha1.appendFormat("%02X", char)
        }
        return sha1 as String
    }
}