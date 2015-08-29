//
//  SwiftNotice.swift
//  SwiftNotice
//
//  Created by JohnLui on 15/4/15.
//  Copyright (c) 2015年 com.lvwenhan. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    // api changed from v3.3
    func noticeTop(text: String, autoClear: Bool = false, autoClearTime: Int = 1) {
        SwiftNotice.noticeOnSatusBar(text, autoClear: autoClear, autoClearTime: autoClearTime)
    }
    
    // new apis from v3.3
    func noticeSuccess(text: String, autoClear: Bool = false, autoClearTime: Int = 3) {
        SwiftNotice.showNoticeWithText(NoticeType.success, text: text, autoClear: autoClear, autoClearTime: autoClearTime,toView:self.view)
    }
    func noticeError(text: String, autoClear: Bool = false, autoClearTime: Int = 3) {
        SwiftNotice.showNoticeWithText(NoticeType.error, text: text, autoClear: autoClear, autoClearTime: autoClearTime,toView:self.view)
    }
    func noticeInfo(text: String, autoClear: Bool = false, autoClearTime: Int = 3) {
        SwiftNotice.showNoticeWithText(NoticeType.info, text: text, autoClear: autoClear, autoClearTime: autoClearTime,toView:self.view)
    }
    
    // old apis
    func successNotice(text: String, autoClear: Bool = true) {
        SwiftNotice.showNoticeWithText(NoticeType.success, text: text, autoClear: autoClear, autoClearTime: 3,toView:self.view)
    }
    func errorNotice(text: String, autoClear: Bool = true) {
        SwiftNotice.showNoticeWithText(NoticeType.error, text: text, autoClear: autoClear, autoClearTime: 3,toView:self.view)
    }
    func infoNotice(text: String, autoClear: Bool = true) {
        SwiftNotice.showNoticeWithText(NoticeType.info, text: text, autoClear: autoClear, autoClearTime: 3,toView:self.view)
    }
    func notice(text: String, type: NoticeType, autoClear: Bool, autoClearTime: Int = 3) {
        SwiftNotice.showNoticeWithText(type, text: text, autoClear: autoClear, autoClearTime: autoClearTime,toView:self.view)
    }
    func pleaseWait(text:String?) {
        SwiftNotice.wait(text,toView:self.view)
    }
    func noticeOnlyText(text: String) {
        SwiftNotice.showText(text)
    }
    func clearAllNotice() {
        for view in self.view.subviews{
            if view.tag == 99999999 {
                view.removeFromSuperview()
            }
        }
        SwiftNotice.clear()
    }
}

enum NoticeType{
    case success
    case error
    case info
}

class SwiftNotice: NSObject {
    
    static var windows = Array<UIWindow!>()
    static let rv = UIApplication.sharedApplication().keyWindow?.subviews.first as UIView!
    
    // fix https://github.com/johnlui/SwiftNotice/issues/2
    // thanks broccolii(https://github.com/broccolii) and his PR https://github.com/johnlui/SwiftNotice/pull/5
    static func clear() {
        self.cancelPreviousPerformRequestsWithTarget(self)
        windows.removeAll(keepCapacity: false)
    }
    
    static func noticeOnSatusBar(text: String, autoClear: Bool, autoClearTime: Int) {
        let frame = UIApplication.sharedApplication().statusBarFrame
        let window = UIWindow()
        window.backgroundColor = UIColor.clearColor()
        let view = UIView()
        view.backgroundColor = UIColor(red: 0x6a/0x100, green: 0xb4/0x100, blue: 0x9f/0x100, alpha: 1)
        
        let label = UILabel(frame: frame)
        label.textAlignment = NSTextAlignment.Center
        label.font = UIFont.systemFontOfSize(12)
        label.textColor = UIColor.whiteColor()
        label.text = text
        view.addSubview(label)
        
        window.frame = frame
        view.frame = frame
        
        window.windowLevel = UIWindowLevelStatusBar
        window.hidden = false
        window.addSubview(view)
        windows.append(window)
        
        if autoClear {
            let selector = Selector("hideNotice:")
            self.performSelector(selector, withObject: window, afterDelay: NSTimeInterval(autoClearTime))
        }
    }
    static func wait(text:String?,toView view:UIView) {
        let frame = CGRectMake(0, 0, 90, 90)
        let mainView = UIView()
        mainView.layer.cornerRadius = 12
        mainView.backgroundColor = UIColor(red:0, green:0, blue:0, alpha: 0.8)
        let ai = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        ai.frame = CGRectMake(21, 10, 48, 48)
        ai.startAnimating()
        mainView.addSubview(ai)
        if let _ = text{
            let label = UILabel()
            label.frame = CGRectMake(5, 65, 80, 20);
            label.text = text!
            label.numberOfLines = 0
            label.font = UIFont.systemFontOfSize(13)
            label.textAlignment = NSTextAlignment.Center
            label.textColor = UIColor.whiteColor()
            mainView.addSubview(label)
        }
        mainView.frame = frame
        
        mainView.center = view.center
        view.addSubview(mainView)
        mainView.tag = 99999999
    }
    static func showText(text: String) {
        let window = UIWindow()
        window.backgroundColor = UIColor.clearColor()
        let mainView = UIView()
        mainView.layer.cornerRadius = 12
        mainView.backgroundColor = UIColor(red:0, green:0, blue:0, alpha: 0.8)
        
        let label = UILabel()
        label.text = text
        label.numberOfLines = 0
        label.font = UIFont.systemFontOfSize(13)
        label.textAlignment = NSTextAlignment.Center
        label.textColor = UIColor.whiteColor()
        label.sizeToFit()
        mainView.addSubview(label)
        
        let superFrame = CGRectMake(0, 0, label.frame.width + 50 , label.frame.height + 30)
        window.frame = superFrame
        mainView.frame = superFrame
        
        label.center = mainView.center
        
        window.windowLevel = UIWindowLevelAlert
        window.center = rv.center
        window.hidden = false
        window.addSubview(mainView)
        windows.append(window)
    }
    
    static func showNoticeWithText(type: NoticeType,text: String, autoClear: Bool, autoClearTime: Int, toView view:UIView) {
        let frame = CGRectMake(0, 0, 90, 90)
        let mainView = UIView()
        mainView.layer.cornerRadius = 10
        mainView.backgroundColor = UIColor(red:0, green:0, blue:0, alpha: 0.7)
        
        var image = UIImage()
        switch type {
        case .success:
            image = SwiftNoticeSDK.imageOfCheckmark
        case .error:
            image = SwiftNoticeSDK.imageOfCross
        case .info:
            image = SwiftNoticeSDK.imageOfInfo
        }
        let checkmarkView = UIImageView(image: image)
        checkmarkView.frame = CGRectMake(27, 15, 36, 36)
        mainView.addSubview(checkmarkView)
        
        let label = UILabel(frame: CGRectMake(0, 60, 90, 16))
        label.font = UIFont.systemFontOfSize(13)
        label.textColor = UIColor.whiteColor()
        label.text = text
        label.textAlignment = NSTextAlignment.Center
        mainView.addSubview(label)
        
        mainView.frame = frame
        
        mainView.center = view.center
        view.addSubview(mainView)

        if autoClear {
            let selector = Selector("hideNotice:")
            self.performSelector(selector, withObject: mainView, afterDelay: NSTimeInterval(autoClearTime))
        }
    }
    
    // fix https://github.com/johnlui/SwiftNotice/issues/2
    static func hideNotice(sender: AnyObject) {
        if let window = sender as? UIView {
            window.removeFromSuperview()
//            if let index = windows.indexOf({ (item) -> Bool in
//                return item == window
//            }) {
//                windows.removeAtIndex(index)
//            }
        }
    }
}

class SwiftNoticeSDK {
    struct Cache {
        static var imageOfCheckmark: UIImage?
        static var imageOfCross: UIImage?
        static var imageOfInfo: UIImage?
    }
    class func draw(type: NoticeType) {
        let checkmarkShapePath = UIBezierPath()
        
        // draw circle
        checkmarkShapePath.moveToPoint(CGPointMake(36, 18))
        checkmarkShapePath.addArcWithCenter(CGPointMake(18, 18), radius: 17.5, startAngle: 0, endAngle: CGFloat(M_PI*2), clockwise: true)
        checkmarkShapePath.closePath()
        
        switch type {
        case .success: // draw checkmark
            checkmarkShapePath.moveToPoint(CGPointMake(10, 18))
            checkmarkShapePath.addLineToPoint(CGPointMake(16, 24))
            checkmarkShapePath.addLineToPoint(CGPointMake(27, 13))
            checkmarkShapePath.moveToPoint(CGPointMake(10, 18))
            checkmarkShapePath.closePath()
        case .error: // draw X
            checkmarkShapePath.moveToPoint(CGPointMake(10, 10))
            checkmarkShapePath.addLineToPoint(CGPointMake(26, 26))
            checkmarkShapePath.moveToPoint(CGPointMake(10, 26))
            checkmarkShapePath.addLineToPoint(CGPointMake(26, 10))
            checkmarkShapePath.moveToPoint(CGPointMake(10, 10))
            checkmarkShapePath.closePath()
        case .info:
            checkmarkShapePath.moveToPoint(CGPointMake(18, 6))
            checkmarkShapePath.addLineToPoint(CGPointMake(18, 22))
            checkmarkShapePath.moveToPoint(CGPointMake(18, 6))
            checkmarkShapePath.closePath()
            
            UIColor.whiteColor().setStroke()
            checkmarkShapePath.stroke()
            
            let checkmarkShapePath = UIBezierPath()
            checkmarkShapePath.moveToPoint(CGPointMake(18, 27))
            checkmarkShapePath.addArcWithCenter(CGPointMake(18, 27), radius: 1, startAngle: 0, endAngle: CGFloat(M_PI*2), clockwise: true)
            checkmarkShapePath.closePath()
            
            UIColor.whiteColor().setFill()
            checkmarkShapePath.fill()
        }
        
        UIColor.whiteColor().setStroke()
        checkmarkShapePath.stroke()
    }
    class var imageOfCheckmark: UIImage {
        if (Cache.imageOfCheckmark != nil) {
            return Cache.imageOfCheckmark!
        }
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(36, 36), false, 0)
        
        SwiftNoticeSDK.draw(NoticeType.success)
        
        Cache.imageOfCheckmark = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return Cache.imageOfCheckmark!
    }
    class var imageOfCross: UIImage {
        if (Cache.imageOfCross != nil) {
            return Cache.imageOfCross!
        }
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(36, 36), false, 0)
        
        SwiftNoticeSDK.draw(NoticeType.error)
        
        Cache.imageOfCross = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return Cache.imageOfCross!
    }
    class var imageOfInfo: UIImage {
        if (Cache.imageOfInfo != nil) {
            return Cache.imageOfInfo!
        }
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(36, 36), false, 0)
        
        SwiftNoticeSDK.draw(NoticeType.info)
        
        Cache.imageOfInfo = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return Cache.imageOfInfo!
    }
}
