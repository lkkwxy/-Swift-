//
//  LKKSortViewController.swift
//  美团
//
//  Created by 李坤坤 on 15/8/21.
//  Copyright © 2015年 李坤坤. All rights reserved.
//

import UIKit

class LKKSortViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let categories = LKKSort.sorts()
        let cate = LKKDropView.drop()
        cate.frame.size.width = 170
        cate.isShowSubTableView = false
        cate.selectedTableView = {(mainIndex,subIndex) in
            let sort:LKKSort? = categories[mainIndex] as? LKKSort
            LKKNotifationCenter.postNotificationName(LKKSortNotifation, object: sort!.value, userInfo: [LKKUserInfoSubTitle:sort!.label!
                ])
        }
        self.preferredContentSize = cate.frame.size;
        cate.dataSource = categories;
        cate.backgroundColor = UIColor.redColor();
        self.view = cate
    }
}
