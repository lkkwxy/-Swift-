//
//  LKKTopItem.swift
//  美团
//
//  Created by 李坤坤 on 15/8/17.
//  Copyright © 2015年 李坤坤. All rights reserved.
//

import UIKit
typealias TopClick = () -> (Void)
class LKKTopItem: UIView {
    @IBOutlet weak private var btn: UIButton!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var subTitleLabel: UILabel!
    /**点击事件Block*/
    var itemClick:TopClick?
    var title:String?{
        didSet{
          titleLabel.text = title
        }
    }
    var subTitle:String?{
        didSet{
            subTitleLabel.text = subTitle
        }
    }
    var icon:String?{
        didSet{
            btn.setImage(UIImage(named: icon!), forState: UIControlState.Normal)
        }
    }
    var highlightedIcon:String?{
        didSet{
            btn.setImage(UIImage(named: highlightedIcon!), forState: UIControlState.Highlighted)
        }
    }
    class func item() -> LKKTopItem{
        return self.itemWithImageName(nil, selectedImageName: nil)
    }
    class func itemWithImageName(imageName:String?,selectedImageName:String?) -> LKKTopItem{
        let topItem = NSBundle.mainBundle().loadNibNamed("LKKTopItem", owner: nil, options: nil).last as! LKKTopItem
        if let image = imageName{
          topItem.btn.setImage(UIImage(named: image), forState: UIControlState.Normal)
        }
        if let selectImage = selectedImageName{
          topItem.btn.setImage(UIImage(named: selectImage), forState: UIControlState.Selected)
        }
        topItem.autoresizingMask = UIViewAutoresizing.None;

        return topItem
    }
    
    @IBAction func btnClick(sender: AnyObject) {
        if let _ = itemClick{
            itemClick!()
        }
    }
    deinit{
        print(self.title)
    }
}
