//
//  LKKDealAnnotation.swift
//  美团
//
//  Created by 李坤坤 on 15/8/27.
//  Copyright © 2015年 李坤坤. All rights reserved.
///Users/likunkun/Documents/美团副本/美团/地图/LKKDealAnnotation.swift:12:49: Redundant conformance of 'LKKDealAnnotation' to protocol 'Equatable'

import UIKit
import MapKit

 class LKKDealAnnotation:NSObject, MKAnnotation {
    @objc var coordinate: CLLocationCoordinate2D
    @objc var title: String?
    @objc var subtitle: String?
    var deal:LKKDeal!
    init(coordinate:CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
    override var hashValue : Int {
        get {
            return "\(coordinate.latitude),\(coordinate.longitude)".hashValue
        }
    }
    override func isEqual(object: AnyObject?) -> Bool {
        return self.hashValue == object!.hashValue
    }
//    public func == (lhs: LKKDealAnnotation, rhs: LKKDealAnnotation) -> Bool{
//        if lhs.coordinate.longitude == rhs.coordinate.longitude && lhs.coordinate.latitude == rhs.coordinate.latitude{
//        return true
//        }
//        return false
//    }
}
 func == (lhs: LKKDealAnnotation, rhs: LKKDealAnnotation) -> Bool{
    if lhs.hashValue == rhs.hashValue{
        return true
    }
    return false
}