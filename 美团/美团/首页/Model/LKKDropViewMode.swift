//
//  LKKDropViewMode.swift
//  美团
//
//  Created by 李坤坤 on 15/8/18.
//  Copyright © 2015年 李坤坤. All rights reserved.
//

import UIKit
protocol LKKTopItemModel {
    func getTitle() -> String?
    func getIcon() -> String?
    func getHighlightedIcon() -> String?
    func getSubData() -> NSArray?
    func getMapIcon() -> String?
}
extension LKKTopItemModel{
    func getHighlightedIcon() -> String?{
        return nil
    }
    func getIcon() -> String?{
        return nil
    }
    func getSubData() -> NSArray?{
        return nil
    }
    func getMapIcon() -> String?{
        return nil
    }
}
class LKKCityGroups:NSObject {
    var title:String?
    var cities:NSArray?
    class func cityGroups() -> [LKKCityGroups]{
        return LKKModel.getCityGroups()
    }
}
class LKKCategory: NSObject,LKKTopItemModel{
    /**名字*/
    var name:String?
    /**子类*/
    var subcategories:NSArray?
    var map_icon:String?
    /**正常图*/
    var highlighted_icon:String?
    var icon:String?
    /**小图*/
    var small_highlighted_icon:String?
    var small_icon:String?
    
    class func category(name:String) -> LKKCategory?{
        let cates = LKKCategory.categories()
        for cate in cates{
            if cate.getTitle()! == name{
                return cate as? LKKCategory
            }else{
                if let _ = cate.getSubData(){
                    for subName in cate.getSubData()!{
                        if (subName as! NSString).containsString(name){
                            
                            return cate as? LKKCategory
                        }
                    }
  
                }
            }
        }
        return nil
        
    }
    class func categories() -> [LKKTopItemModel]{
        return LKKModel.getCategories()
    }
  
    

}
extension LKKCategory {
    func getTitle() -> String? {
        return name
    }
    func getSubData() -> NSArray? {
        return subcategories
    }
    func getIcon() -> String? {
        return small_icon
    }
    func getHighlightedIcon() -> String? {
        return small_highlighted_icon
    }
    func getMapIcon() -> String? {
        return map_icon
    }
}
class LKKCity: NSObject {
    /**名字*/
    var name:NSString?
    /**区域*/
    var regions:Array<LKKRegions>?
    /**拼音*/
    var pinYin:NSString?
    /**拼音首字母*/
    var pinYinHead:NSString?
    class func cities() -> [LKKCity] {
        return LKKModel.getCities()
    }
    override func objectClassInArray() -> NSDictionary {
            return ["regions" : "LKKRegions"]
    }
}
class LKKRegions: NSObject,LKKTopItemModel {
    /**名字*/
    var name:String?
    /**子区域*/
    var subregions:NSArray?
    class func regionsWithCityNmae(cityNmae:String) -> [LKKTopItemModel]{
        return LKKModel.regionsWithCityNmae(cityNmae)
    }
}
extension LKKRegions{
    func getTitle() -> String? {
        return name
    }
    func getSubData() -> NSArray? {
        return subregions
    }
}
class LKKSort:NSObject,LKKTopItemModel{
    var label:String?
    var value:NSNumber?
    class func sorts() -> [LKKTopItemModel]{
        return LKKModel.getSorts()
    }
    func getTitle() -> String? {
        return label
    }
}
 private class LKKModel{
    static var cityGroups :[LKKCityGroups]?
    static var cities:[LKKCity]?
    static var categories:[LKKTopItemModel]?
    static var sotrs:[LKKTopItemModel]?
    class func getSorts() -> [LKKTopItemModel]{
        if sotrs == nil{
            sotrs = Array<LKKTopItemModel>()
            let temp = LKKSort.objectArrayWithKeyValuesArray(NSArray(contentsOfFile: NSBundle.mainBundle().pathForResource("sorts", ofType: "plist")!)!) as? [LKKSort]
            for sort in temp! {
                sotrs!.append(sort)
            }
        }
        return sotrs!
    }
    class func regionsWithCityNmae(cityNmae:String) -> [LKKTopItemModel]{
        var regions = Array<LKKTopItemModel>()
        for city in getCities() {
            if city.name!.isEqualToString(cityNmae) {
                for region in city.regions! {
                   regions.append(region)
                }
                break
            }
        }
        return regions
    }
    class func getCategories() -> [LKKTopItemModel] {
        if categories == nil{
            categories = Array<LKKTopItemModel>()
            let categorys = NSArray(contentsOfFile: NSBundle.mainBundle().pathForResource("categories", ofType: "plist")!)
            let temp = LKKCategory.objectArrayWithKeyValuesArray(categorys!) as? [LKKCategory]
            for category in temp! {
                categories?.append(category)
            }
        }
        return categories!
    }
    class func getCityGroups() -> [LKKCityGroups]{
        if cityGroups == nil{
            let citys = NSArray(contentsOfFile: NSBundle.mainBundle().pathForResource("cityGroups", ofType: "plist")!)
            cityGroups = LKKCityGroups.objectArrayWithKeyValuesArray(citys!) as? [LKKCityGroups]
        }
        
        return cityGroups!
    }
    class func getCities() -> [LKKCity] {
        if cities == nil {
            let citys = NSArray(contentsOfFile: NSBundle.mainBundle().pathForResource("cities", ofType: "plist")!)
            cities = LKKCity.objectArrayWithKeyValuesArray(citys!) as? [LKKCity]

        }
        return cities!
    }
}