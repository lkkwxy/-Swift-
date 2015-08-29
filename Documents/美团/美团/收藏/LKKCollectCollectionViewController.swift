//
//  LKKCollectCollectionViewController.swift
//  美团
//
//  Created by 李坤坤 on 15/8/25.
//  Copyright © 2015年 李坤坤. All rights reserved.
//

import UIKit


class LKKCollectCollectionViewController: LKKLocalCollectionViewController {
    override func viewDidLoad() {
        self.title = "我的收藏"
        self.deals = LKKDealTool.collectDeals(self.currentPage)
        
        super.viewDidLoad()

    }
    override func delete(){
        for deal in deals{
            if deal.isChecking{
                LKKDealTool.removeCollect(deal)
            }
        }
        deals = LKKDealTool.collectDeals(1)
        self.edit()
        self.collectionView?.reloadData()
    }
    override func loadMore() {
        self.currentPage++
        self.deals += LKKDealTool.collectDeals(self.currentPage)
        self.collectionView?.reloadData()
        self.collectionView?.footerEndRefreshing()
        if LKKDealTool.collectDealsCount() <= deals.count{
            self.collectionView?.setFooterHidden(true)
        }
    }

}
