//
//  LKKDropView.swift
//  美团
//
//  Created by 李坤坤 on 15/8/18.
//  Copyright © 2015年 李坤坤. All rights reserved.
//

import UIKit
typealias SelectedTableView = (Int,Int?)-> Void
class LKKDropView: UIView,UITableViewDelegate,UITableViewDataSource{
    var dataSource:Array<LKKTopItemModel>!{
        didSet{
            mainTableView.reloadData()
            subTableView.reloadData()
        }
    }
    var subData = NSArray();
    var index = 0
    var isShowSubTableView = true
    var selectedTableView:SelectedTableView?
    @IBOutlet weak var mainTableView: UITableView!

    @IBOutlet weak var subTableView: UITableView!
    
    @IBOutlet weak var subWM: NSLayoutConstraint!
    @IBOutlet weak var mainWM: NSLayoutConstraint!
    class func drop() -> LKKDropView{
        let dropView = NSBundle.mainBundle().loadNibNamed("LKKDropView", owner: nil, options: nil).last as! LKKDropView
        return dropView
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        if !isShowSubTableView {
            mainWM.constant += self.frame.size.width / 2
            subWM.constant -= self.frame.size.width / 2
            subTableView.hidden = true
            print(self.frame.size.width)
        }
    }
    override func awakeFromNib() {
        mainTableView.backgroundColor = UIColor.redColor()
        self.autoresizingMask = UIViewAutoresizing.None
        mainTableView.autoresizingMask = UIViewAutoresizing.None
    }
  
}
extension LKKDropView{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == mainTableView{
            return dataSource.count
        }else{
            return subData.count
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if tableView == mainTableView{
            var cell = tableView.dequeueReusableCellWithIdentifier("MainCellID")
            if cell == nil {
                cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "MainCellID")
            }
            cell?.textLabel?.text = dataSource[indexPath.row].getTitle()
            if let icon = dataSource[indexPath.row].getIcon(){
                cell?.imageView?.image = UIImage(named: icon)
            }
            if let highlightedIcon = dataSource[indexPath.row].getHighlightedIcon(){
                cell?.imageView?.highlightedImage = UIImage(named: highlightedIcon)
            }
            
            cell?.backgroundView = UIImageView(image: UIImage(named: "bg_dropdown_leftpart"))
            cell?.selectedBackgroundView = UIImageView(image: UIImage(named: "bg_dropdown_left_selected"))
            if dataSource[indexPath.row].getSubData() != nil{
                cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            }else{
               cell?.accessoryType = UITableViewCellAccessoryType.None
            }
            return cell!
        }else{
            var cell = tableView.dequeueReusableCellWithIdentifier("cellID")
            if cell == nil {
                cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cellID")
            }
            cell?.backgroundView = UIImageView(image: UIImage(named: "bg_dropdown_leftpart"))
            cell?.selectedBackgroundView = UIImageView(image: UIImage(named: "bg_dropdown_left_selected"))
            cell?.textLabel?.text = subData[indexPath.row] as? String
            return cell!
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView == mainTableView{
            let temp = dataSource[indexPath.row].getSubData()
            if let _ = temp{
                subData = temp!
                index = indexPath.row
            }else{
                if let _ = self.selectedTableView{
                    selectedTableView!(indexPath.row,nil)
                }
                return
            }
            subTableView.reloadData()
        }else{
            if let _ = self.selectedTableView{
                selectedTableView!(index,indexPath.row)
            }
        }
    }
}