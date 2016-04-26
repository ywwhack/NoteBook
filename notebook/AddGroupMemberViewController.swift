//
//  AddFriendViewController.swift
//  notebook
//
//  Created by iYww on 16/4/15.
//  Copyright © 2016年 zank. All rights reserved.
//

import UIKit
import Alamofire

class AddGroupMemberViewController: UITableViewController {
  
  enum SearchResult {
    case NotSearched
    case Loading
    case NotFound
    case matchedUsers([String])
  }
  
  var dataModel = DataModel.sharedDataModel()
  var searchResult: SearchResult = .NotSearched
  var groupId: String!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  @IBAction func addGroupMember(sender: UIButton) {
    let memeberLabel = sender.superview?.viewWithTag(1000) as! UILabel
    RemoteResource.addMember(memeberLabel.text!, ToGroup: groupId) { requestResult in
      switch requestResult {
      case .Success:
        print("success")
      case .Failed(let reason):
        print(reason)
      }
    }
  }
  
  // MARK: - Table view data source
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch searchResult {
    case .NotSearched: return 0
    case .NotFound, .Loading: return 1
    case .matchedUsers(let users): return users.count
    }
  }
  
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell: UITableViewCell
    
    switch searchResult {
    case .NotSearched:
      fatalError("There is something logic wrong")
    case .Loading:
      cell = tableView.dequeueReusableCellWithIdentifier("LoadingCell", forIndexPath: indexPath)
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

extension AddGroupMemberViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    guard let username = searchBar.text else {
      return
    }
    
    searchResult = .Loading
    tableView.reloadData()
    
    RemoteResource.searchUserWithUsername(username) { requestResult in
      switch requestResult {
      case .Success(let result):
        if let code = result["code"] as? Int, userInfo = result["userInfo"] as? [String: AnyObject] where code == 1 {
          self.searchResult = .matchedUsers([userInfo["name"] as! String])
        }else {
          self.searchResult = .NotFound
        }
      case .Failed:
        self.searchResult = .NotFound
      }
      
      self.tableView.reloadData()
    }
    
  }
  
}
