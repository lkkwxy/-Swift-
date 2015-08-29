//
//  LKKCategoryViewController.swift
//  美团
//
//  Created by 李坤坤 on 15/8/21.
//  Copyright © 2015年 李坤坤. All rights reserved.
//

import UIKit

class LKKCategoryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let categories = LKKCategory.categories() as [LKKTopItemModel]
        let cate = LKKDropView.drop()
        cate.selectedTableView = {(mainIndex,subIndex) -> Void in
            var userInfo = [NSObject:AnyObject]()
            let categoty:LKKCategory? = categories[mainIndex] as? LKKCategory
            if let name = categoty?.name{
               userInfo[LKKUserInfoTitle] = name
            }
            if let icon = categoty?.icon{
                userInfo[LKKUserInfoIcon] = icon
            }
            if let highlightedIcon = categoty?.highlighted_icon{
                userInfo[LKKUserInfoHighlightedIcon] = highlightedIcon
            }
            if let _ = subIndex{
                if let subcategory = categoty?.subcategories?[subIndex!]{
                    userInfo[LKKUserInfoSubTitle] = subcategory
                }
            }
            LKKNotifationCenter.postNotificationName(LKKCategoryNotifation, object: nil, userInfo: userInfo)
        }
        self.preferredContentSize = cate.frame.size;
        cate.dataSource = categories;
        cate.backgroundColor = UIColor.redColor();
        self.view = cate
    }
}
