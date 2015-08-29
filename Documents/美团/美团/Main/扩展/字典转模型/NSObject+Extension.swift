//
//  NSObject+Extension.swift
//  美团
//
//  Created by 李坤坤 on 15/8/18.
//  Copyright © 2015年 李坤坤. All rights reserved.
//

import Foundation

let Prefix = "T@"
let Prefix1 = ","

extension NSObject{
    func setValuesForProperies(properies:NSArray,values:NSDictionary){
        for var i = 0;i < properies.count;i++ {
            let property = properies[i] as! LKKPropery
            let key = property.key
            var value:AnyObject? = values[key!]
            if let _ = value {
                if (value as? NSArray != nil){
                    if self.respondsToSelector("objectClassInArray"){
                        let classDic = self.objectClassInArray()
                        let customInArray = classDic[property.properyNmae] as? String
                        if let _ = customInArray{
                            
                            let customClass = getClassWitnClassNmae(customInArray!)
                            if let _ = customClass {
                                value = customClass?.objectArrayWithKeyValuesArray(value as! NSArray)
                            }
                        }
                        
                    }
                }
                    let isFromFoundtion = property.properyType.isFromFoundtion as Bool
                    if isFromFoundtion {
                        self.setValue(value, forKey: property.properyNmae as String)
                    }else{
                        let subModel = property.properyType.typeClass?.objectWithKeyValues(value as! NSDictionary)
                        self.setValue(subModel, forKey: property.properyNmae as String)
                    }
            }
        }
    }
    class func objectWithKeyValues(keyValues:NSDictionary) -> AnyObject{
        let model = self.init()
        let properies = self.getProperies()
        model.setValuesForProperies(properies, values: keyValues)
        return model
    }
    class func objectArrayWithKeyValuesArray(array:NSArray) -> [AnyObject]{
        var temp = Array<AnyObject>()
        let properies = self.getProperies()
        for(var i = 0;i < array.count;i++){
            let keyValues = array[i] as? NSDictionary
            if (keyValues != nil){
               let model = self.init()
            model.setValuesForProperies(properies, values: keyValues!)
            temp.append(model)
            }
        }
        return temp
    }
    func replacedKeyFromPropertyName() -> NSDictionary{
        return ["":""]
    }
    func objectClassInArray() -> NSDictionary{
        return ["":""]
    }
    class func getProperies() -> NSArray{
        let model = self.init()
        var properies = NSArray()
        if model.respondsToSelector("replacedKeyFromPropertyName"){
            properies = self.properies(model.replacedKeyFromPropertyName())
        }else{
            properies = self.properies(nil)
        }
        return properies
    }
   class func properies(replaceDic:NSDictionary?) -> NSArray{
        let className = NSString(CString: class_getName(self), encoding: NSUTF8StringEncoding)
        if let _ = className{
            if className!.isEqualToString("NSObject"){
                return NSArray()
            }
        }else{
            return NSArray()
        }
        var outCount:UInt32 = 0
        let tempM = NSMutableArray()
        let properties = class_copyPropertyList(self.classForCoder(),&outCount)
        
        let superM = self.superclass()?.properies(replaceDic) as? [AnyObject]
        if let _ = superM{
           tempM.addObjectsFromArray(superM!)
        }
        for var i = 0;i < Int(outCount);i++ {
            let property:objc_property_t = properties[i]
            let propery = LKKPropery(propery: property)
            var key:NSString = propery.properyNmae
            if let _ = replaceDic{
                let temp = replaceDic![propery.properyNmae] as? NSString
                if let _ = temp{
                    key = temp!
                }
            }
            propery.key = key
            tempM.addObject(propery)
        }
        return tempM
    }
}
 private class LKKPropery {
    var properyNmae:NSString!
    var key:NSString!
    var propery:objc_property_t
    var properyType:LKKType!
    init(propery:objc_property_t){
        self.propery = propery
        self.setup()
    }
    func setup(){
        self.properyNmae = NSString(CString: property_getName(propery), encoding: NSUTF8StringEncoding)
        var types: NSString = NSString(CString: property_getAttributes(propery), encoding: NSUTF8StringEncoding)!
        types = types.substringFromIndex(Prefix.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
        types = types.componentsSeparatedByString(Prefix1).first!
        self.properyType = LKKType(code: types)
    }
}
private class LKKType {
    var code:NSString
    var typeClass:AnyClass?
    var isFromFoundtion:Bool!
    init(code:NSString){
        self.code = code
        if self.code.hasPrefix("\""){
            self.code = self.code.substringFromIndex(1)
        }
        if self.code.hasSuffix("\""){
            self.code = self.code.substringToIndex(self.code.length - 1)
        }
      setup()
    }
    func setup(){
        let bundlePath = getBundleName()
        let range = self.code.rangeOfString(bundlePath)
        if range.length > 0{
            self.code = self.code.substringFromIndex(range.length + range.location)
        }
        let code = self.code as String
        var number:String = ""
            for char in code.characters{
                if char <= "9" && char >= "0"{
                    number += String(char)
                }else{
                    break
                }
            }
        let numberRange = self.code.rangeOfString(number)
        if numberRange.length > 0{
            self.code = self.code.substringFromIndex(numberRange.length + numberRange.location)
        }
        if self.code.hasPrefix("NS"){
            self.typeClass = NSClassFromString(self.code as String)
            self.isFromFoundtion = true
        }else{
            let type = bundlePath + "." + (self.code as String)
            self.typeClass = NSClassFromString(type)
            self.isFromFoundtion = false
        }
    }
}
//获取工程的名字
func getBundleName() -> String{
    var bundlePath = NSBundle.mainBundle().bundlePath
    bundlePath = bundlePath.componentsSeparatedByString("/").last!
    bundlePath = bundlePath.componentsSeparatedByString(".").first!
    return bundlePath
}
//通过类名返回一个AnyClass
func getClassWitnClassNmae(name:String) ->AnyClass?{
    let type = getBundleName() + "." + name
    return NSClassFromString(type)
}
  