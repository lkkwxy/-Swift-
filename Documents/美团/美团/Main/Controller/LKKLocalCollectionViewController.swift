//
//  LKKLocalCollectionViewController.swift
//  美团
//
//  Created by 李坤坤 on 15/8/25.
//  Copyright © 2015年 李坤坤. All rights reserved.
//

import UIKit

private let LKKEditText = "编辑"
private let LKKDoneText = "完成"
class LKKLocalCollectionViewController: LKKDealCollectionViewController {
    lazy var backItem:UIBarButtonItem = {
        var item = UIBarButtonItem.barButtonItemWithImageName("icon_back", HighlightedImageName: "icon_back_highlighted", target: self, action: "back")
        return item
        }()
    lazy var allSelectedItem:UIBarButtonItem = {
        var item = UIBarButtonItem(title: "  全选 ", style: UIBarButtonItemStyle.Done, target: self, action: "allSelected")
        return item
    }()
    lazy var allNoSelectedItem:UIBarButtonItem = {
        var item = UIBarButtonItem(title: " 全不选  ", style: UIBarButtonItemStyle.Done, target: self, action: "allNoSelected")
        return item
        }()
    lazy var deleteItem:UIBarButtonItem = {
        var item = UIBarButtonItem(title: " 删除 ", style: UIBarButtonItemStyle.Done, target: self, action: "delete")
        return item
        }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: LKKEditText, style: UIBarButtonItemStyle.Done, target: self, action: "edit")
        self.navigationItem.leftBarButtonItems = [backItem]
        deleteItem.enabled = false
        self.collectionView?.setHeaderHidden(true)
        self.collectionView?.reloadData()
        LKKNotifationCenter.addObserver(self, selector: "deleteItemChange", name: LKKDealChooseChangeNotifation, object: nil)
        LKKNotifationCenter.addObserver(self, selector: "dealIndexChange:", name: LKKDealIndexChangeNotifation, object: nil)
        if LKKDealTool.collectDealsCount() <= deals.count{
            self.collectionView?.setFooterHidden(true)
        }
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView?.reloadData()
    }
    func dealIndexChange(notifation:NSNotification){
        let deal = notifation.object as? LKKDeal
        if let _ = deal{
            let index = deals.indexOf(deal!)
            if let _ = index{
                deals.removeAtIndex(index!)
            }
            deals.insert(deal!, atIndex: 0)
        }
    }
    func deleteItemChange(){
        var count = 0
        for deal in deals{
            if deal.isChecking{
                count++
            }
        }
        if count == 0{
            deleteItem.enabled = false
            deleteItem.title = "删除"
        }else{
            deleteItem.enabled = true
            deleteItem.title = "删除(\(count))"
        }
    }
    // MARK:导航栏Item的Action
    func back(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    func allSelected(){
        for deal in deals{
            deal.isChecking = true
        }
        deleteItemChange()
        self.collectionView?.reloadData()
    }
    func allNoSelected(){
        for deal in deals{
            deal.isChecking = false
        }
        deleteItemChange()
        self.collectionView?.reloadData()
    }
    func delete(){
        for deal in deals{
            if deal.isChecking{
                LKKDealTool.removeCollect(deal)
            }
        }
        deleteItemChange()
        deals = LKKDealTool.collectDeals(1)
        self.edit()
        self.collectionView?.reloadData()
    }
    func edit(){
        if self.navigationItem.rightBarButtonItem!.title == LKKEditText{
            self.navigationItem.rightBarButtonItem!.title = LKKDoneText
            self.navigationItem.leftBarButtonItems = [backItem,allSelectedItem,allNoSelectedItem,deleteItem]
            for deal in deals{
                deal.isEdit = true
            }
        }else{
            self.navigationItem.rightBarButtonItem!.title = LKKEditText
            self.navigationItem.leftBarButtonItems = [backItem]
            for deal in deals{
                deal.isEdit = false
            }
        }
        self.collectionView?.reloadData()
    }
    // MARK:重写父类的方法
    override func loadMore() {
        self.currentPage++
        self.deals += LKKDealTool.collectDeals(self.currentPage)
        self.collectionView?.reloadData()
        self.collectionView?.footerEndRefreshing()
        if LKKDealTool.collectDealsCount() <= deals.count{
            self.collectionView?.setFooterHidden(true)
        }

    }
    deinit{
        LKKNotifationCenter.removeObserver(self)
    }
    
}
