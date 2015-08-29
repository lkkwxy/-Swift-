//
//  LKKSearchCollectionViewController.swift
//  美团
//
//  Created by 李坤坤 on 15/8/23.
//  Copyright © 2015年 李坤坤. All rights reserved.
//

import UIKit


class LKKSearchCollectionViewController: LKKDealCollectionViewController,UISearchBarDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.barButtonItemWithImageName("icon_back", HighlightedImageName: "icon_back_highlighted", target: self, action: "cancle")
        let searchBar = UISearchBar();
        searchBar.placeholder = "请输入关键词";
        searchBar.delegate = self;
        self.navigationItem.titleView = searchBar;
    }
    func cancle(){
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        self.currentPage = 1;
        let params:NSMutableDictionary = ["city":LKKRegionsViewController.cityName,"keyword":searchBar.text!]
        loadDeals(params)
    }
}
