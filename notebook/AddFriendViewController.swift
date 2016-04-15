//
//  AddFriendViewController.swift
//  notebook
//
//  Created by iYww on 16/4/15.
//  Copyright © 2016年 zank. All rights reserved.
//

import UIKit

class AddFriendViewController: UITableViewController {
  
  var dataModel: DataModel!
  var matchedUsers: [String]?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  // MARK: - Table view data source
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let matchedUsers = matchedUsers {
      return matchedUsers.count
    }else {
      return 1
    }
  }
  
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell: UITableViewCell
    
    if let matchedUsers = matchedUsers {
      cell = tableView.dequeueReusableCellWithIdentifier("FriendResultCell", forIndexPath: indexPath)
      let label = cell.viewWithTag(1000) as! UILabel
      // let addButton = cell.viewWithTag(1001) as! UIButton
      label.text = matchedUsers[indexPath.row]
    }else {
      cell = tableView.dequeueReusableCellWithIdentifier("NotFoundCell", forIndexPath: indexPath)
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
    matchedUsers = dataModel.matchedUsersWithText(username)
    tableView.reloadData()
  }
  
}
