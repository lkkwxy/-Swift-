//
//  LKKRecentCollectionViewController.swift
//  美团
//
//  Created by 李坤坤 on 15/8/25.
//  Copyright © 2015年 李坤坤. All rights reserved.
//

import UIKit


class LKKRecentCollectionViewController: LKKLocalCollectionViewController {

    override func viewDidLoad() {
        self.title = "浏览记录"
        self.deals = LKKDealTool.recentDeals(self.currentPage)
        super.viewDidLoad()
        
    }
    override func delete(){
        for deal in deals{
            if deal.isChecking{
                LKKDealTool.removeRecent(deal)
            }
        }
        self.currentPage = 1
        deals = LKKDealTool.recentDeals(1)
        self.edit()
        self.collectionView?.reloadData()
    }
    override func loadMore() {
        self.currentPage++
        self.deals += LKKDealTool.recentDeals(self.currentPage)
        self.collectionView?.reloadData()
        self.collectionView?.footerEndRefreshing()
        if LKKDealTool.recentDealsCount() <= deals.count{
            self.collectionView?.setFooterHidden(true)
        }
    }
}
