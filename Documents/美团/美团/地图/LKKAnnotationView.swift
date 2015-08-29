//
//  LKKAnnotationView.swift
//  美团
//
//  Created by 李坤坤 on 15/8/29.
//  Copyright © 2015年 李坤坤. All rights reserved.
//

import UIKit
import MapKit
protocol LKKAnnotationViewDelegate:NSObjectProtocol{
    func clickAnnotationViewInfo(deal:LKKDeal)
}
class LKKAnnotationView: MKPinAnnotationView {

    weak var delegate:LKKAnnotationViewDelegate?
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
       super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        let btn = UIButton(type: UIButtonType.DetailDisclosure)
        btn.addTarget(self, action: "btnAction", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.rightCalloutAccessoryView = btn
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func btnAction(){
        if let _ = delegate {
            delegate?.clickAnnotationViewInfo((self.annotation as! LKKDealAnnotation).deal)
        }
        print(self.annotation?.title)
    }
}
