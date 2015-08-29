//
//  UIBarButtonItem+Extension.swift
//  美团
//
//  Created by 李坤坤 on 15/8/18.
//  Copyright © 2015年 李坤坤. All rights reserved.
//

import UIKit
extension UIBarButtonItem{
    //通过图片生成一个UIBarButtonItem
    class func barButtonItemWithImageName(imageNmae:String,HighlightedImageName:String,target:AnyObject?,action:Selector) ->UIBarButtonItem{
        let btn = UIButton(type: UIButtonType.Custom)
        btn.setImage(UIImage(named: imageNmae), forState: UIControlState.Normal)
        btn.setImage(UIImage(named: HighlightedImageName), forState: UIControlState.Highlighted)
        btn.addTarget(target, action: action, forControlEvents: UIControlEvents.TouchUpInside)
        if let size = btn.currentImage?.size{
           btn.frame.size = size
        }
        btn.frame.size.width = 60
        let barButtonItem = UIBarButtonItem(customView: btn)
        return barButtonItem
    }

}