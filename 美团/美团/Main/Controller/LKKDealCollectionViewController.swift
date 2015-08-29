//
//  LKKBaseCollectionViewController.swift
//  美团
//
//  Created by 李坤坤 on 15/8/23.
//  Copyright © 2015年 李坤坤. All rights reserved.
//

import UIKit

private let reuseIdentifier = "reuseIdentifier"

class LKKDealCollectionViewController: UICollectionViewController {
    var deals = Array<LKKDeal>()
    var params:NSMutableDictionary!
    var lastRequest:NSURLRequest!
    var totalCount = 0
    var currentPage = 1
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        setlayout(size.width != 1024)
    }
    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        if toInterfaceOrientation == UIInterfaceOrientation.Portrait || toInterfaceOrientation == UIInterfaceOrientation.PortraitUpsideDown{
            self.setlayout(true)
        }else{
            setlayout(false)
        }
    }
    private func setlayout(isPortrait:Bool){
        // 根据屏幕宽度决定列数
        let cols:CGFloat = isPortrait ? 2 : 3;
        let width:CGFloat = isPortrait ? 768 : 1024
        // 根据列数计算内边距
        let layout = self.collectionViewLayout as! UICollectionViewFlowLayout;
        let inset = (width - cols * layout.itemSize.width) / (cols + 1);
        layout.sectionInset = UIEdgeInsetsMake(inset, inset, inset, inset);
        
        // 设置每一行之间的间距
        layout.minimumLineSpacing = inset;
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = self.collectionView!.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSizeMake(305, 305)
        self.collectionView?.backgroundColor = LKKBackgroundColor
        self.collectionView!.registerNib(UINib(nibName: "LKKDealCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        
        self.collectionView?.addHeaderWithCallback({[unowned self]
            () -> Void in
            self.refresh()
        })
        self.collectionView?.addFooterWithCallback({[unowned self] () -> Void in
            self.loadMore()
        })
    }

    // MARK:refreshAndLoadMore
    func refresh(){
        self.currentPage = 1
        self.loadDeals(self.params)
    }
    func loadMore(){
        self.currentPage++
        self.loadDeals(self.params)
    }
    // MARK: loadDeals
    func loadDeals(params:NSMutableDictionary){
        self.clearAllNotice()
        self.pleaseWait("正在加载中。。。")
        self.params = params
        params["page"] = currentPage
        params["limit"] = "30"
        lastRequest = LKKNetWorkTool.request("v1/deal/find_deals",params: params) {[unowned self] (data, error,request) -> Void in
            if self.lastRequest !== request{
                return
            }
            self.clearAllNotice()
            if let _ = error{
                self.noticeError(errorMessage, autoClear: true, autoClearTime: autoClearTime)
                if self.currentPage != 1{
                    self.currentPage--
                }
                return
            }
            do{
                let info = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
                let tmp = (info as! NSDictionary)["deals"]
                if tmp == nil{
                    self.noticeError(errorMessage, autoClear: true, autoClearTime: autoClearTime)
                    return
                }
                let deals = LKKDeal.objectArrayWithKeyValuesArray(tmp as! NSArray)
                if self.currentPage != 1 {
                    self.deals += deals as! [LKKDeal]
                }else{
                    self.deals = deals as! [LKKDeal]
                }
                self.collectionView?.headerEndRefreshing()
                self.collectionView?.footerEndRefreshing()
                self.collectionView?.reloadData()
            }catch{
                self.noticeError(errorMessage, autoClear: true, autoClearTime: autoClearTime)
                if self.currentPage != 1{
                    self.currentPage--
                }
            }
            
        }
    }

    // MARK: UICollectionViewDataSource
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.view.frame.size.width > 1000{
            setlayout(false)
        }else{
            setlayout(true)
        }
        return deals.count
    }
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! LKKDealCollectionViewCell
        cell.deal = deals[indexPath.item] as LKKDeal
        return cell
    }

    // MARK: UICollectionViewDelegate
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let detail = LKKDealDetailViewController(nibName: "LKKDealDetailViewController", bundle:nil)
        detail.deal = deals[indexPath.item]
        self.navigationController?.presentViewController(detail, animated: true, completion: nil)
        LKKDealTool.addRecent(deals[indexPath.item])
        LKKNotifationCenter.postNotificationName(LKKDealIndexChangeNotifation, object: deals[indexPath.item])
    }
}
