//
//  LKKMapViewController.swift
//  美团
//
//  Created by 李坤坤 on 15/8/26.
//  Copyright © 2015年 李坤坤. All rights reserved.
//

import UIKit
import MapKit
class LKKMapViewController: UIViewController,MKMapViewDelegate,LKKAnnotationViewDelegate{
    
    @IBOutlet weak var mapView: MKMapView!
    var annotions = NSMutableArray()
    var cityName:String?
    var categoryItemView:LKKTopItem!
    var categoryPopover:UIPopoverController!
    var isDealingDeals:Bool = false
    var selectedCategory:String?
    lazy var geocoder:CLGeocoder = {
        return CLGeocoder()
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryItemView = LKKTopItem.item()
        categoryItemView.title = "全部分类"
        categoryItemView.icon = "icon_category_-1"
        categoryItemView.highlightedIcon = "icon_category_highlighted_-1"
        let categoryItem = UIBarButtonItem(customView: categoryItemView)
        categoryItemView.itemClick = {[unowned self,category = categoryItem]() -> Void in
            self.categoryPopover = UIPopoverController(contentViewController: LKKCategoryViewController())
            self.categoryPopover.presentPopoverFromBarButtonItem(category, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
        }
        let backItem = UIBarButtonItem.barButtonItemWithImageName("icon_back", HighlightedImageName: "icon_back_highlighted", target: self, action: "cancle")
        self.navigationItem.leftBarButtonItems = [backItem,categoryItem]
        LKKNotifationCenter.addObserver(self, selector: "changeCategory:", name: LKKCategoryNotifation, object: nil)
        mapView.userTrackingMode = MKUserTrackingMode.Follow
        
    }
    deinit{
        LKKNotifationCenter.removeObserver(self)
        print("deinit")
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
        self.categoryPopover.dismissPopoverAnimated(true)
        self.mapView.removeAnnotations(self.mapView.annotations)
        self.mapView(mapView, regionDidChangeAnimated: true)
    }
    func cancle(){
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    // MARK:mapViewDelegate
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        // 创建区域
        let center = CLLocationCoordinate2DMake(userLocation.location!.coordinate.latitude + 0.0001, userLocation.location!.coordinate.longitude + 0.0001);
        let span = MKCoordinateSpanMake(0.1, 0.1);
        let region = MKCoordinateRegionMake(center, span);
        mapView.setRegion(region, animated: true)
        // 获得城市名称
        geocoder.reverseGeocodeLocation(userLocation.location!) { (placemarks, error) -> Void in
            if let _ = error{
                self.noticeError("定位失败", autoClear: true, autoClearTime: 2)
                return
            }
            if placemarks?.count < 1{
                self.noticeError("定位失败", autoClear: true, autoClearTime: 2)
            }
            if let placemark = placemarks!.first{
                var cityTmp = placemark.addressDictionary!["State"] as! NSString
                if cityTmp.rangeOfString("省").length > 0 || cityTmp.rangeOfString("自治区").length > 0 || cityTmp.rangeOfString("行政区").length > 0 {
                    cityTmp = placemark.addressDictionary!["City"] as! NSString
                }
                    self.cityName = cityTmp.substringToIndex(cityTmp.length - 1)
            }
        }
    }
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is LKKDealAnnotation) {
            return nil
        }
        let anno = annotation as! LKKDealAnnotation
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier("dealAnnotationView")
        if annotationView == nil{
            annotationView = LKKAnnotationView(annotation: annotation, reuseIdentifier: "dealAnnotationView")
            annotationView?.canShowCallout = true
            
        }
        (annotationView as? LKKAnnotationView)?.delegate = self
        annotationView?.annotation = annotation
        let cate = anno.deal.categories?.firstObject as? String
        var category:LKKCategory?
        if selectedCategory == nil || selectedCategory == "全部分类"{
             category = LKKCategory.category(cate!)
        }else{
             category = LKKCategory.category(selectedCategory!)
            
        }
        if let _ = category {
            annotationView?.image = UIImage(named: (category?.map_icon!)!)
        }else{
            annotationView?.image = UIImage(named:"ic_category_default")
        }

        
        return annotationView


    }
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        if cityName == nil || isDealingDeals{
            return
        }
        isDealingDeals = true
        let params = NSMutableDictionary()
        let center = mapView.region.center
        params["latitude"] = "\(center.latitude)"
        params["longitude"] = "\(center.longitude)"
        params["radius"] = "5000"
        params["city"] = self.cityName!
        let url = "v1/deal/find_deals"
        if let _ = selectedCategory{
           params["category"] = selectedCategory!
        }
        LKKNetWorkTool.request(url,params: params) {(data, error,request) -> Void in
            if error != nil || data == nil{
               self.noticeError(errorMessage, autoClear: true, autoClearTime: autoClearTime)
                self.isDealingDeals = false
                return
            }
            do{
                let info = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
                let tmp = (info as! NSDictionary)["deals"]
                if tmp == nil{
                    self.noticeError(errorMessage, autoClear: true, autoClearTime: autoClearTime)
                    return
                }
                let deals = LKKDeal.objectArrayWithKeyValuesArray(tmp as! NSArray) as! [LKKDeal]
                self.setupDeals(deals)
            }catch{
                self.noticeError(errorMessage, autoClear: true, autoClearTime: autoClearTime)
                self.isDealingDeals = false
            }
        }
    }
    func setupDeals(deals:[LKKDeal]){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            for deal in deals{
                for business in deal.businesses!{
                    if business is LKKBusiness{
                        let tmp = business as! LKKBusiness
                        let annotation = LKKDealAnnotation(coordinate: CLLocationCoordinate2DMake(tmp.latitude!.doubleValue, tmp.longitude!.doubleValue))
                        annotation.title = deal.title
                        annotation.subtitle = tmp.name
                        annotation.deal = deal
                        let annotations = self.mapView.annotations
                        
                        if annotations.contains({ (dealAnnotation) -> Bool in
                            if dealAnnotation is LKKDealAnnotation{
                                return dealAnnotation.isEqual(annotation)
                            }
                            return false
                        }){
                            continue
                        }
                        dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                            self.mapView.addAnnotation(annotation)
                        })
                    }
                }
            }
            
        }
        self.isDealingDeals = false
    }
    func clickAnnotationViewInfo(deal:LKKDeal){
        let detail = LKKDealDetailViewController(nibName: "LKKDealDetailViewController", bundle:nil)
        detail.deal = deal
        LKKDealTool.addRecent(deal)
        LKKNotifationCenter.postNotificationName(LKKDealIndexChangeNotifation, object: deal)
        self.presentViewController(detail, animated: true, completion: nil)
    }
}