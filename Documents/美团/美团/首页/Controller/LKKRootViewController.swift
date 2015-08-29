//
//  LKKRootViewController.swift
//  美团
//
//  Created by 李坤坤 on 15/8/17.
//  Copyright © 2015年 李坤坤. All rights reserved.
//

import UIKit
private let pathMenuAlpha:CGFloat = 0.3
class LKKRootViewController: LKKDealCollectionViewController {
    var categoryItemView:LKKTopItem!
    var cityItemView:LKKTopItem!
    var sortItemView:LKKTopItem!
    var categoryPopover:UIPopoverController?
    var cityPopover:UIPopoverController!
    var sortPopover:UIPopoverController!
    var selectedRegion:String?
    var selectedCategory:String?
    var selectedSort:NSNumber?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLeftNav()
        self.setupRightNav()
        self.addNotifation()
        self.setupPathMenu()
        setupParams()
    }

    // MARK:设置左边的NavigationItems
    private func setupLeftNav(){
        //设置logo
        let logoItem = UIBarButtonItem(image: UIImage(named: "icon_meituan_logo"), style: UIBarButtonItemStyle.Done, target: nil, action: nil)
        logoItem.enabled = false;
        //设置分类
        categoryItemView = LKKTopItem.item()
        categoryItemView.title = "全部分类"
        categoryItemView.icon = "icon_category_-1"
        categoryItemView.highlightedIcon = "icon_category_highlighted_-1"
        let categoryItem = UIBarButtonItem(customView: categoryItemView)
        categoryItemView.itemClick = {[unowned self,category = categoryItem]() -> Void in
            self.categoryPopover = UIPopoverController(contentViewController: LKKCategoryViewController())
            self.categoryPopover!.presentPopoverFromBarButtonItem(category, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
        }
        //设置城市区域
        cityItemView = LKKTopItem.item()
        cityItemView.title = "北京-全部"
        cityItemView.subTitle = ""
        cityItemView.icon = "icon_district"
        cityItemView.highlightedIcon = "icon_district_highlighted"
        let cityItem = UIBarButtonItem(customView: cityItemView)
        cityItemView.itemClick = {[unowned self,city = cityItem] in
            let regions = LKKRegionsViewController()
            self.cityPopover = UIPopoverController(contentViewController: regions)
            self.cityPopover.presentPopoverFromBarButtonItem(city, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
            regions.popover = self.cityPopover
        }
        
        //设置排序方式
        sortItemView = LKKTopItem.item()
        let sortItem = UIBarButtonItem(customView: sortItemView)
        sortItemView.icon = "icon_sort"
        sortItemView.highlightedIcon = "icon_sort_highlighted"
        sortItemView.title = "排序"
        sortItemView.subTitle = "默认排序"
        sortItemView.itemClick = {[unowned self,sort = sortItem]() -> Void in
            self.sortPopover = UIPopoverController(contentViewController: LKKSortViewController())
            self.sortPopover.presentPopoverFromBarButtonItem(sort, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
        }
        self.navigationItem.leftBarButtonItems = [logoItem,categoryItem,cityItem,sortItem]
        
    }
    // MARK:设置右的NavigationItems
    private func setupRightNav(){
        let mapItem = UIBarButtonItem.barButtonItemWithImageName("icon_map", HighlightedImageName: "icon_map_highlighted", target: self, action: "map")
        let searchItem = UIBarButtonItem.barButtonItemWithImageName("icon_search", HighlightedImageName: "icon_search_highlighted", target: self, action: "search")
        self.navigationItem.rightBarButtonItems = [mapItem,searchItem]
    }
    //点击搜索,注意此处不能用private修饰，否则会找不到方法
    func search(){
       self.performSegueWithIdentifier("search", sender: nil)
       print("search \n")
    }
    //点击地图
    func map(){
        let map = LKKMapViewController(nibName: "LKKMapViewController", bundle:nil)
        let nav = LKKNavigationController(rootViewController:map)
        self.presentViewController(nav, animated: true, completion: nil)
    }
    deinit{
        LKKNotifationCenter.removeObserver(self)
    }
}
// MARK:topItem通知
extension LKKRootViewController{
    private func addNotifation(){
        LKKNotifationCenter.addObserver(self, selector: "changeCategory:", name: LKKCategoryNotifation, object: nil)
        LKKNotifationCenter.addObserver(self, selector: "changeRegions:", name: LKKRegionsNotifation, object: nil)
        LKKNotifationCenter.addObserver(self, selector: "changeSort:", name: LKKSortNotifation, object: nil)
    }
    func changeCategory(notifation:NSNotification){
        let userInfo = notifation.userInfo
        if let title = userInfo?[LKKUserInfoTitle] as? String
        {
            categoryItemView.title = title
        }else{
            categoryItemView.title = ""
        }
        if let subTitle = userInfo?[LKKUserInfoSubTitle] as? String{
            categoryItemView.subTitle = subTitle
        }else{
            categoryItemView.subTitle = ""
        }
        if let icon = userInfo?[LKKUserInfoIcon] as? String{
            categoryItemView.icon = icon
        }
        if let highlightedIcon = userInfo?[LKKUserInfoHighlightedIcon] as? String{
            categoryItemView.highlightedIcon = highlightedIcon
        }
        if categoryItemView.subTitle!.isEmpty || (categoryItemView.subTitle! as NSString).isEqualToString("全部"){
            selectedCategory = categoryItemView.title
        }else{
            selectedCategory = categoryItemView.subTitle
        }
        if selectedCategory == "全部分类"{
            selectedCategory = nil
        }
        if let _ = self.categoryPopover {
            self.categoryPopover!.dismissPopoverAnimated(true)
        }
        setupParams()
        
    }
    
    func changeRegions(notifation:NSNotification){
        let userInfo = notifation.userInfo
        if let title = userInfo?[LKKUserInfoTitle] as? String
        {
            cityItemView.title = title
        }else{
            cityItemView.title = ""
        }
        if let subTitle = userInfo?[LKKUserInfoSubTitle] as? String{
            cityItemView.subTitle = subTitle
        }else{
            cityItemView.subTitle = ""
        }
        if cityItemView.subTitle!.isEmpty || (cityItemView.subTitle! as NSString).isEqualToString("全部"){
            selectedRegion = cityItemView.title?.componentsSeparatedByString("-").last
        }else{
            selectedRegion = cityItemView.subTitle
        }
        if (selectedRegion! as NSString).isEqualToString("全部"){
            selectedRegion = nil
        }
        self.cityPopover.dismissPopoverAnimated(true)
        setupParams()
    }
    
    func changeSort(notifation:NSNotification){
        let userInfo = notifation.userInfo
        if let subTitle = userInfo?[LKKUserInfoSubTitle] as? String
        {
            sortItemView.subTitle = subTitle
        }else{
            sortItemView.subTitle = ""
        }
        selectedSort = notifation.object as? NSNumber
        self.sortPopover.dismissPopoverAnimated(true)
        setupParams()
    }
    
    func setupParams(){
        let params:NSMutableDictionary = ["city":LKKRegionsViewController.cityName,"sort":"1"]
        self.currentPage = 1
        if let _ = selectedSort{
            params["sort"] = "\(selectedSort!)"
        }
        if let _ = selectedRegion{
            params["region"] = selectedRegion!
        }
        if let _ = selectedCategory{
            params["category"] = selectedCategory!
        }
        self.loadDeals(params)
    }
    
}
//MARK: PathMenuDelegate
extension LKKRootViewController:PathMenuDelegate{
    func setupPathMenu(){
        let view = UIView()
        view.backgroundColor = UIColor(white: 1, alpha: 0)
        self.view.addSubview(view)
        let backImage: UIImage = UIImage(named: "bg_pathMenu_black_normal")!
        
        let starMenuItem1: PathMenuItem = PathMenuItem(image: backImage, highlightedImage: nil, ContentImage: UIImage(named: "icon_pathMenu_mine_normal")!, highlightedContentImage:nil)
        
        let starMenuItem2: PathMenuItem = PathMenuItem(image: backImage, highlightedImage: nil, ContentImage: UIImage(named: "icon_pathMenu_scan_normal")!, highlightedContentImage:nil)
        
        let starMenuItem3: PathMenuItem = PathMenuItem(image: backImage, highlightedImage: nil, ContentImage: UIImage(named: "icon_pathMenu_collect_normal")!, highlightedContentImage:nil)
        
        let starMenuItem4: PathMenuItem = PathMenuItem(image: backImage, highlightedImage: nil, ContentImage: UIImage(named: "icon_pathMenu_more_normal")!, highlightedContentImage:nil)
        let menus: [PathMenuItem] = [starMenuItem1, starMenuItem2, starMenuItem3, starMenuItem4]
        
        let startItem: PathMenuItem = PathMenuItem(image: UIImage(named: "icon_pathMenu_background_normal"), highlightedImage: nil, ContentImage: UIImage(named: "icon_pathMenu_mainMine_normal"), highlightedContentImage: nil)
        let menu: PathMenu = PathMenu(frame: CGRectMake(10, 0, 100, 100), startItem: startItem, optionMenus: menus)
        menu.delegate = self
        menu.startPoint = CGPointMake(20, 280)
        menu.menuWholeAngle = CGFloat(M_PI_2)
        menu.rotateAngle = 0
        menu.timeOffset = 0.0
        menu.farRadius = 110.0
        menu.nearRadius = 90.0
        menu.endRadius = 100.0
        menu.animationDuration = 0.5
        menu.rotateAddButton = false
        menu.alpha = pathMenuAlpha
        self.view.addSubview(menu)
        menu.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(self.view).offset(30)
            make.bottom.equalTo(self.view).offset(-30)
            make.width.equalTo(300)
            make.height.equalTo(300)
        }

    }
    func pathMenu(menu: PathMenu, didSelectIndex idx: Int){
        if idx == 1{
            let layout = UICollectionViewFlowLayout()
            let local = LKKRecentCollectionViewController(collectionViewLayout: layout)
            self.navigationController?.pushViewController(local, animated: true)
        }else if idx == 2{
            let layout = UICollectionViewFlowLayout()
           let local = LKKCollectCollectionViewController(collectionViewLayout: layout)
            self.navigationController?.pushViewController(local, animated: true)
        }
    }
    func pathMenuWillAnimateOpen(menu: PathMenu){
        menu.alpha = 1.0
        menu.contentImage = UIImage(named: "icon_pathMenu_cross_normal")
    }
    func pathMenuWillAnimateClose(menu: PathMenu){
        menu.alpha = pathMenuAlpha
        menu.contentImage = UIImage(named: "icon_pathMenu_mainMine_normal")
    }
}