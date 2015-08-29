//
//  LKKDealCollectionViewCell.swift
//  美团
//
//  Created by 李坤坤 on 15/8/23.
//  Copyright © 2015年 李坤坤. All rights reserved.
//

import UIKit
class LKKDealCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak private var dealNewView: UIImageView!

    @IBOutlet weak var dimBtn: UIButton!
    @IBOutlet weak private var chooseImage: UIImageView!
    @IBOutlet weak private var listPriceLabel: UILabel!
    @IBOutlet weak private var purchaseCountLabel: UILabel!
    @IBOutlet weak private var currentPriceLabel: UILabel!
    @IBOutlet weak private var deatilLabel: UILabel!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var imageView: UIImageView!
    var deal:LKKDeal?{
        didSet{
            listPriceLabel.text = "￥" + "\(deal!.list_price!)"
            if listPriceLabel.text?.characters.count > 6{
                let startIndex = listPriceLabel.text?.startIndex
                let index = advance(startIndex!, 6)
                listPriceLabel.text = listPriceLabel.text!.substringToIndex(index)
            }
            currentPriceLabel.text = "￥" + "\(deal!.current_price!)"
            if currentPriceLabel.text?.characters.count > 6{
            let startIndex = currentPriceLabel.text?.startIndex
            let index = advance(startIndex!, 6)
            currentPriceLabel.text = currentPriceLabel.text!.substringToIndex(index)
            }
            let attr = NSMutableAttributedString(string: listPriceLabel!.text!)
            attr.addAttributes([NSStrikethroughStyleAttributeName:NSNumber(integer: NSUnderlineStyle.StyleSingle.rawValue)], range: NSMakeRange(0, attr.length))
            listPriceLabel.attributedText = attr
            //设置售出分数
            purchaseCountLabel.text = "已售出" + "\(deal!.purchase_count!)"
            //设置标题
            titleLabel.text = deal!.title!
            //设置详细描述
            deatilLabel.text = deal!.desc!
            //设置图片
            imageView.setImage(deal!.image_url!, placeHoldeImage: UIImage(named: "placeholder_deal")!)
            let date = NSDate()
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateStr = dateFormatter.stringFromDate(date)
            if deal!.publish_date!.compare(dateStr) != NSComparisonResult.OrderedDescending{
                dealNewView.hidden = true
            }else{
                dealNewView.hidden = false
            }
            self.dimBtn.hidden = !deal!.isEdit
            self.chooseImage.hidden = !deal!.isEdit || !deal!.isChecking
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundView = UIImageView(image: UIImage(named: "bg_dealcell"))
    }

    @IBAction func dimAction(sender: AnyObject) {
        chooseImage.hidden = !chooseImage.hidden
        deal?.isChecking = !chooseImage.hidden
        LKKNotifationCenter.postNotificationName(LKKDealChooseChangeNotifation, object: nil)
    }
}
