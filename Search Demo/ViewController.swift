//
//  ViewController.swift
//  Search Demo
//
//  Created by Aynur Galiev on 25.ноября.2016.
//  Copyright © 2016 Aynur Galiev. All rights reserved.
//

import UIKit

final class ViewController: UIViewController, UIScrollViewDelegate, UISearchResultsUpdating, UISearchControllerDelegate {

    fileprivate var tableView: UITableView!
    private var resfreshControl: UIRefreshControl!
    fileprivate var defaultColor: UIColor = UIColor(red: 201.0/255.0, green: 201.0/255.0, blue: 206.0/255.0, alpha: 1.0)
    
    fileprivate func initRefreshControl() {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(self.refresh(sender:)), for: .valueChanged)
        self.tableView.addSubview(control)
        self.resfreshControl = control
    }
    
    fileprivate func deinitRefreshControl() {
        self.resfreshControl?.removeFromSuperview()
        self.resfreshControl?.endRefreshing()
    }
    
    fileprivate func initTableView() {
        let tableView = UITableView()
        tableView.allowsSelection = false
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(tableView)
        self.tableView = tableView
    }
    
    fileprivate func initSearchController() {
        self.searchController = FSSearchController(searchResultsController: nil)
        self.searchController.dimsBackgroundDuringPresentation = true
        self.searchController.delegate = self
        self.searchController.searchResultsUpdater = self
        self.searchController.edgesForExtendedLayout = []
        self.searchBar.tintColor = UIColor.white
        self.searchController.searchBar.sizeToFit()
        self.view.addSubview(self.searchController.searchBar)
    }
    
    fileprivate var searchController: FSSearchController!
    fileprivate let names: [String] = ["Aynur", "Vlad", "Aleksey", "Timur", "Marat", "Sergey", "Nikita", "Anton", "Valeriy", "Vladimir"]
    fileprivate var filteredNames: [String] = []
    
    private var searchBar: UISearchBar {
        return self.searchController.searchBar
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initTableView()
        self.initRefreshControl()
        self.initSearchController()
        self.navigationItem.title = "Search demo"
        self.edgesForExtendedLayout = []
    }
    
    func refresh(sender: AnyObject) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {
            self.resfreshControl.endRefreshing()
        })
    }
    
    override func viewWillLayoutSubviews() {
        if self.resfreshControl != nil { self.tableView.sendSubview(toBack: self.resfreshControl) }
        self.tableView.frame = CGRect(x: 0,
                                      y: self.searchBar.height,
                                  width: self.view.frame.size.width,
                                 height: self.view.frame.size.height - self.searchBar.height)

        if self.searchController.isActive {
            self.tableView.contentInset = UIEdgeInsets(top: StatusBarHeight, left: 0, bottom: 0, right: 0)
        } else {
            self.tableView.contentInset = UIEdgeInsets.zero
        }
    }

    func updateSearchResults(for searchController: UISearchController) {
        
        guard let text = self.searchController.searchBar.text else { return }
        self.filteredNames = self.names.filter { (str) -> Bool in
            return str.contains(text)
        }
        self.tableView.reloadData()
    }
    
    func willPresentSearchController(_ searchController: UISearchController) {
        self.deinitRefreshControl()
        UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: { 
            self.searchBar.fs_backgroundColor = UIColor.darkGray
        }, completion: nil)
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            self.searchBar.fs_backgroundColor = self.defaultColor
        }, completion: nil)
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        self.initRefreshControl()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
}

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.searchController.isActive {
            return self.filteredNames.count
        } else {
            return self.names.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        if self.searchController.isActive {
            cell?.textLabel?.text = self.filteredNames[indexPath.row]
        } else {
            cell?.textLabel?.text = self.names[indexPath.row]
        }
        return cell!
    }
}

