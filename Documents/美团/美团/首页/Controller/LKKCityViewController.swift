//
//  LKKCityViewController.swift
//  美团
//
//  Created by 李坤坤 on 15/8/19.
//  Copyright © 2015年 李坤坤. All rights reserved.
//

import UIKit
class LKKCityViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dimView: UIView!
    @IBOutlet weak var resultTableView: UITableView!
    let groups = LKKCityGroups.cityGroups()
    
    var resultCities = NSMutableArray()
    override func viewDidLoad() {
        self.edgesForExtendedLayout = UIRectEdge.None
        self.navigationItem.title = "切换城市"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.barButtonItemWithImageName("btn_navigation_close", HighlightedImageName: "btn_navigation_close_hl", target: self, action: "cancle")
        tableView.sectionIndexColor = UIColor.blackColor()
    }
    
    func cancle(){
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func dimVlick(){
        searchBar.resignFirstResponder()
    }
    
}
/**
 * UISearchBarDelegate
 */
extension LKKCityViewController{
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        UIView.animateWithDuration(0.3) { () -> Void in
           self.dimView.alpha = 0.5
        }
        searchBar.setShowsCancelButton(true, animated: true)
        searchBar.backgroundImage = UIImage(named: "bg_login_textfield_hl")
        searchBar.tintColor = UIColor(red: 32 / 255.0, green: 191 / 255.0, blue: 179 / 255.0, alpha: 1)
        return true
    }
    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        UIView.animateWithDuration(0.3) { () -> Void in
            self.dimView.alpha = 0
        }
        searchBar.text = ""
        self.resultTableView.hidden = true
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.backgroundImage = UIImage(named: "bg_login_textfield")
        return true
    }
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        let text = searchText.lowercaseString
        let cities = LKKCity.cities()
        self.resultCities = NSMutableArray()
        for city in cities {
            if city.name?.rangeOfString(text).length > 0 || city.pinYin?.rangeOfString(text).length > 0 || city.pinYinHead?.rangeOfString(text).length > 0{
                self.resultCities.addObject(city)
            }
        }
        if self.resultCities.count > 0{
            self.dimView.userInteractionEnabled = false;
            self.resultTableView.hidden = false
        }else{
            self.resultTableView.hidden = true
            self.dimView.userInteractionEnabled = true;
        }
        self.resultTableView.reloadData()
//            }
//        }
    }
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
         searchBar.resignFirstResponder()
    }
}
/**
 * tableviewDatasource和tableViewDelegate
 */
extension LKKCityViewController{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == self.tableView){
            let citys = groups[section]
            if let count = citys.cities?.count{
                return count
            }
        }else if (tableView == resultTableView){
            return resultCities.count
        }
        return 0
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if tableView == self.tableView{
            return groups.count
        }else{
        
           return 1
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if tableView == self.tableView{
            var cell = tableView.dequeueReusableCellWithIdentifier("cellID")
            if cell == nil {
                cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cellID");
            }
            let citys = groups[indexPath.section]
            let cityName = citys.cities![indexPath.row] as! String
            cell?.textLabel?.text = cityName
            return cell!

        }else{
            var cell = tableView.dequeueReusableCellWithIdentifier("resultCellID")
            if cell == nil {
                cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "resultCellID");
            }
            let citys = resultCities[indexPath.row] as! LKKCity
            let cityName = citys.name!
            cell?.textLabel?.text = cityName as String
            return cell!
  
        }
    }
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView == self.tableView{
            let citys = groups[section]
            return citys.title
        }
        let count = resultCities.count
        return "共搜索到\(count)个城市"
    }
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        if tableView == self.tableView{
            var titles = [String]()
            for group in groups{
                titles.append(group.title!)
            }
            return titles
        }
        return nil
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        let text = cell?.textLabel?.text
        if let _ = text{
            LKKRegionsViewController.cityName = text!
        }
        cancle()
    }
}