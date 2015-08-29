//
//  LKKDealDetailViewController.swift
//  美团
//
//  Created by 李坤坤 on 15/8/24.
//  Copyright © 2015年 李坤坤. All rights reserved.
//

import UIKit

class LKKDealDetailViewController: UIViewController,UIWebViewDelegate {

    var deal:LKKDeal!
    @IBOutlet weak var activityView:UIActivityIndicatorView!
    @IBOutlet weak var webView:UIWebView!
    @IBOutlet weak var refundableAnyTimeButton: UIButton!
    @IBOutlet weak var refundableExpireButton: UIButton!
    @IBOutlet weak var currentPriceLabel: UILabel!
    @IBOutlet weak var originalPriceLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var collectBtn: UIButton!
    @IBOutlet weak var timeBtn: UIButton!
    @IBOutlet weak var soldBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = LKKBackgroundColor
        self.setupView()
        webView.hidden = true
        print(deal.deal_h5_url!)
        let request = NSURLRequest(URL: NSURL(string: deal.deal_h5_url!)!)
        webView.loadRequest(request)
        if LKKDealTool.isCollected(deal){
            self.collectBtn.selected = true
        }else{
            self.collectBtn.selected = false
        }
        
    }
    private func setupView(){
        self.imageView.setImage(deal.image_url!, placeHoldeImage: UIImage(named: "placeholder_deal")!)
        self.currentPriceLabel.text = "￥ " + "\(deal.current_price!)"
        let originalPrice = "门店价\(deal.list_price!)"
        let attr = NSMutableAttributedString(string: originalPrice)
         attr.addAttributes([NSStrikethroughStyleAttributeName:NSNumber(integer: NSUnderlineStyle.StyleSingle.rawValue)], range: NSMakeRange(0, attr.length))
        self.originalPriceLabel.attributedText = attr
        self.descLabel.text = "\(deal.desc!)"
        self.titleLabel.text = "\(deal.title!)"
        self.soldBtn.setTitle("已售\(deal.purchase_count!)", forState: UIControlState.Normal)
        self.timeBtn.setTitle(deal.purchase_deadline!.byNowDateString(), forState: UIControlState.Normal)
        LKKNetWorkTool.request("v1/deal/get_single_deal", params: ["deal_id":deal.deal_id!]) { (data, error, request) -> Void in
            if let _ = error{
                self.noticeError(errorMessage, autoClear: true, autoClearTime: autoClearTime)
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
                let deal = deals.first
                let isSelected = deal?.restrictions?.is_refundable?.integerValue == 1
                self.refundableAnyTimeButton.selected = isSelected
                self.refundableExpireButton.selected = isSelected
            }catch{
                self.noticeError(errorMessage, autoClear: true, autoClearTime: autoClearTime)
            }
        }
    }
    @IBAction func back(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func collectAction(sender: UIButton) {
        sender.selected = !sender.selected
        if sender.selected {
            LKKDealTool.addCollect(deal)
            self.noticeSuccess(collectSuccess, autoClear: true, autoClearTime: autoClearTime)
        }else{
            LKKDealTool.removeCollect(deal)
            self.noticeSuccess(cancleCollectSuccess, autoClear: true, autoClearTime: autoClearTime)
        }
        
        
    }

    
    
    
    
    
    
    
    
    @IBAction func shareAction(sender: AnyObject) {
    }

    @IBAction func buyNow(sender: AnyObject) {
    }
    // MARK: UIWebViewDelegate
    func webViewDidFinishLoad(webView: UIWebView) {
        let ID = self.deal.deal_id!.componentsSeparatedByString("-").last
        if webView.request!.URL!.absoluteString == "http://m.dianping.com/tuan/deal/\(ID!)"{
            let urlStr = String(format: "http://m.dianping.com/tuan/deal/moreinfo/%@",ID!)
            webView.loadRequest(NSURLRequest(URL: NSURL(string: urlStr)!))
        }else{
            var js = ""
            js += "var LKKheader = document.getElementsByTagName('header')[0];"
            js += "LKKheader.parentNode.removeChild(LKKheader);"
            js += "var LKKbox = document.getElementsByClassName('cost-box')[0];"
            js += "LKKbox.parentNode.removeChild(LKKbox);"
            js += "var LKKbuyNow = document.getElementsByClassName('buy-now')[0];"
            js += "LKKbuyNow.parentNode.removeChild(LKKbuyNow);"
            js += "var LKKfooter = document.getElementsByTagName('footer')[0];"
            js += "LKKfooter.parentNode.removeChild(LKKfooter);"
            webView.stringByEvaluatingJavaScriptFromString(js)
            let time = dispatch_time(DISPATCH_TIME_NOW, (Int64)(2 * NSEC_PER_SEC))
            dispatch_after(time, dispatch_get_main_queue(), { () -> Void in
                webView.hidden = false
                self.activityView.stopAnimating()
            })
            
        }
    }
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Landscape
    }
}
