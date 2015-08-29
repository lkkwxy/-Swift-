//
//  LKKNavigationController.swift
//  美团
//
//  Created by 李坤坤 on 15/8/17.
//  Copyright © 2015年 李坤坤. All rights reserved.
//

import UIKit

class LKKNavigationController: UINavigationController {
    override class func initialize(){
        let appearance = UINavigationBar.appearance()
        appearance.setBackgroundImage(UIImage(named: "bg_navigationBar_normal"), forBarMetrics:UIBarMetrics.Default )
        let item = UIBarButtonItem.appearance()
        item.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor(red: 80 / 255.0, green: 210 / 255.0, blue: 167 / 255.0, alpha: 1)], forState: UIControlState.Normal)
        item.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.grayColor()], forState: UIControlState.Disabled)
    }
}
