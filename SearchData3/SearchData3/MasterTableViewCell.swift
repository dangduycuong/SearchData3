//
//  MasterTableViewCell.swift
//  SearchData3
//
//  Created by duycuong on 1/16/19.
//  Copyright © 2019 duycuong. All rights reserved.
//

import UIKit

struct Vegetable {
    let catogery: String
    let name: String
    let imageView: UIImage!
}

class MasterTableViewController: UITableViewController {
    
    //MARK: Properties
    
    var vegetables = [
        Vegetable(catogery: "RAU", name: "Rau Chan Vit", imageView: UIImage(named: "rauChanVit")),
        Vegetable(catogery: "RAU", name: "Rau Khoai Lang", imageView: UIImage(named: "rauKhoai")),
        Vegetable(catogery: "RAU", name: "Rau Muong", imageView: UIImage(named: "rauMuong")),
        Vegetable(catogery: "RAU", name: "Rau Sam", imageView: UIImage(named: "rauSam")),
        
        Vegetable(catogery: "CU", name: "Khoai Lang", imageView: UIImage(named: "khoailang")),
        Vegetable(catogery: "CU", name: "Khoai Tay", imageView: UIImage(named: "khoaitay")),
        Vegetable(catogery: "CU", name: "San", imageView: UIImage(named: "san")),
        
        Vegetable(catogery: "QUA", name: "Cam", imageView: UIImage(named: "cam")),
        Vegetable(catogery: "QUA", name: "Chanh", imageView: UIImage(named: "chanh")),
        Vegetable(catogery: "QUA", name: "Nho", imageView: UIImage(named: "nho")),
        Vegetable(catogery: "QUA", name: "Xoai", imageView: UIImage(named: "xoai"))
    ]
    
    var filterVegetable = [Vegetable]()
    var searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup for search
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Here"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        // Setup for Scope
        searchController.searchBar.delegate = self
        searchController.searchBar.scopeButtonTitles = ["ALL", "RAU", "CU", "QUA"]
    }
    
    //MARK: Action
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as? DetailViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            var vegetable: Vegetable
            vegetable = vegetables[indexPath.row]
            destination?.detailCatogeryText = vegetable.catogery
            destination?.detailNameText = vegetable.name
            destination?.detailImage = vegetable.imageView
        }
        
    }
    
    //MARK: Setup action for Search
    func isSearchBarEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool {
        let scopeFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (!isSearchBarEmpty() || scopeFiltering)
    }
    
    func filterContentForSearch(_ searchText: String, scope: String = "ALL") {
        filterVegetable = vegetables.filter({ (vegetable: Vegetable) -> Bool in
            let doesCatogeryMath = (scope == "ALL") || (vegetable.catogery == scope)
            if isSearchBarEmpty() {
                return doesCatogeryMath
            } else {
                
                return doesCatogeryMath && vegetable.name.lowercased().contains(searchText.lowercased())
            }
        })
        tableView.reloadData()
    }
    
    //MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            // return về những kết qủa tìm được
            return filterVegetable.count
        } else {
            return vegetables.count
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        
        
        let vegetable: Vegetable
        if isFiltering() {
            vegetable = filterVegetable[indexPath.row]
        } else {
            vegetable = vegetables[indexPath.row]
        }
        
        cell.catogeryLabel.text = vegetable.catogery
        cell.catogeryLabel.textColor = UIColor.red
        cell.vegetableLabel.text = vegetable.name
        cell.vegetableLabel.textColor = UIColor.darkGray
        cell.nameImageView.image = vegetable.imageView //UIImage(named: vegetable.name)
//        vegetable.name
        // Set color when user touch inside (or click choose)
        let backgroundView = UIView()
        backgroundView.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        cell.selectedBackgroundView = backgroundView
        indexPath.row % 2 == 0 ? (cell.backgroundColor = #colorLiteral(red: 0.8374283536, green: 0.8986742516, blue: 0.9008055376, alpha: 0.5139194542)) : (cell.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
        
        return cell
    }
    
    //MARK: Pravite Method
//    func filterData(name: Character) {
//        let vegetable: Vegetable
//
//    }
    
    
}

extension MasterTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearch(searchController.searchBar.text!, scope: scope)
    }
}

extension MasterTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearch(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
}
