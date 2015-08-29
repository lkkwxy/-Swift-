//
//  UIImageView+Extension.swift
//  美团
//
//  Created by 李坤坤 on 15/8/23.
//  Copyright © 2015年 李坤坤. All rights reserved.
//  


import UIKit
private let cacheImage = NSMutableDictionary()
private let cacheURL = NSMutableArray()
private let maxCount = 100
extension UIImageView{
    
    func setImage(url:String,placeHoldeImage:UIImage){
        if let cache = cacheImage[url] as? UIImage{
            self.image = cache
            return
        }
        let documentName = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).last
        let imageData = NSData(contentsOfFile: documentName! + "/LKKImage" + url)
        if let _ = imageData {
            let image = UIImage(data: imageData!)
            if let _ = image{
                self.image = image
                cacheImage[url] = image
                if !cacheURL.containsObject(url) {
                    cacheURL.addObject(url)
                }
                if cacheImage.count > maxCount{
                    cacheImage.removeObjectForKey(cacheURL.firstObject!)
                    cacheURL.removeObjectAtIndex(0)
                }
                return
            }
        }
        self.image = placeHoldeImage
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        dispatch_async(queue) { () -> Void in
            let data = NSData(contentsOfURL: NSURL(string: url)!)
            if let _ = data{
                let image = UIImage(data: data!)
                let path = documentName! + "/LKKImage" + url
                data?.writeToFile(path, atomically: true)
                if let _ = image{
                    dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                        self.image = image
                        cacheImage[url] = image
                        if !cacheURL.containsObject(url) {
                            cacheURL.addObject(url)
                        }
                        if cacheImage.count > maxCount{
                        cacheImage.removeObjectForKey(cacheURL.firstObject!)
                            cacheURL.removeObjectAtIndex(0)
                        }
                        
                    })
                }
            }
 
        }
        
    }
}