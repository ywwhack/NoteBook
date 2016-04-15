//
//  AddFriendViewController.swift
//  notebook
//
//  Created by iYww on 16/4/15.
//  Copyright © 2016年 zank. All rights reserved.
//

import UIKit

class AddFriendViewController: UITableViewController {
  
  enum SearchResult {
    case NotSearched
    case NotFound
    case matchedUsers([String])
  }
  
  var dataModel: DataModel!
  var searchResult: SearchResult = .NotSearched
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  // MARK: - Table view data source
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch searchResult {
    case .NotSearched: return 0
    case .NotFound: return 1
    case .matchedUsers(let users): return users.count
    }
  }
  
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell: UITableViewCell
    
    switch searchResult {
    case .NotSearched:
      fatalError("There is something logic wrong")
    case .NotFound:
      cell = tableView.dequeueReusableCellWithIdentifier("NotFoundCell", forIndexPath: indexPath)
    case .matchedUsers(let users):
      cell = tableView.dequeueReusableCellWithIdentifier("FriendResultCell", forIndexPath: indexPath)
      let label = cell.viewWithTag(1000) as! UILabel
      // let addButton = cell.viewWithTag(1001) as! UIButton
      label.text = users[indexPath.row]
    }
    
    return cell
  }
  
}


extension AddFriendViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    guard let username = searchBar.text else {
      return
    }
    if let users = dataModel.matchedUsersWithText(username) {
      searchResult = .matchedUsers(users)
    }else {
      searchResult = .NotSearched
    }
    tableView.reloadData()
  }
  
}
