//
//  LKKRegionsViewController.swift
//  美团
//
//  Created by 李坤坤 on 15/8/21.
//  Copyright © 2015年 李坤坤. All rights reserved.
//

import UIKit

class LKKRegionsViewController: UIViewController {
    static var cityName = "北京"{
        didSet{
            var userInfo = [NSObject:AnyObject]()
            userInfo[LKKUserInfoTitle] = cityName + "-全部"
            LKKNotifationCenter.postNotificationName(LKKRegionsNotifation, object: nil, userInfo: userInfo)
        }
    }
    var popover:UIPopoverController!
    @IBOutlet var changeCityView:UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let regions = LKKRegions.regionsWithCityNmae(LKKRegionsViewController.cityName)
        let cate = LKKDropView.drop()
        cate.selectedTableView = {(mainIndex,subIndex) -> Void in
            var userInfo = [NSObject:AnyObject]()
            let region:LKKRegions? = regions[mainIndex] as? LKKRegions
            if let name = region?.name{
                userInfo[LKKUserInfoTitle] = LKKRegionsViewController.cityName + "-" + name
            }
            if let _ = subIndex{
                if let subcategory = region?.subregions?[subIndex!]{
                    userInfo[LKKUserInfoSubTitle] = subcategory
                }
            }
            LKKNotifationCenter.postNotificationName(LKKRegionsNotifation, object: nil, userInfo: userInfo)
        }
        cate.dataSource = regions;
        self.view.addSubview(cate)
        cate.backgroundColor = UIColor.yellowColor()
        cate.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(changeCityView.snp_bottom)
            make.width.equalTo(changeCityView.snp_width)
            make.height.equalTo(300)
            make.centerX.equalTo(changeCityView.snp_centerX)
        }
        self.preferredContentSize = CGSizeMake(320, 344)
    }

    @IBAction func changCity(sender: AnyObject) {
        self.popover!.dismissPopoverAnimated(true)
        self.popover = nil
        let cityVC = LKKCityViewController()
        let nav = LKKNavigationController(rootViewController:cityVC)
        nav.modalPresentationStyle = UIModalPresentationStyle.FormSheet
        UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(nav, animated: true, completion: nil)
    }
}
