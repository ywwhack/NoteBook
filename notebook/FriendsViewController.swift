//
//  FriendsViewController.swift
//  notebook
//
//  Created by iYww on 16/4/14.
//  Copyright © 2016年 zank. All rights reserved.
//

import UIKit

class FriendsViewController: UITableViewController {
  
  var dataModel: DataModel!
  var friends: [String]!
  var groups: [Group]!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let userInfo = dataModel.fetchUserInfo()
    friends = userInfo.friends
    groups = userInfo.groups
  }

  // MARK: - Table view data source
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1 + groups.count
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return section == 0 ? friends.count : groups[section - 1].friends.count + 1
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell: UITableViewCell
    
    if indexPath.section == 0 {
      cell = tableView.dequeueReusableCellWithIdentifier("FriendCell", forIndexPath: indexPath)
      cell.textLabel?.text = friends[indexPath.row]
    }else {
      let groupFriends = groups[indexPath.section - 1].friends
      if indexPath.row == groupFriends.count {
        cell = tableView.dequeueReusableCellWithIdentifier("AddFriendCell", forIndexPath: indexPath)
      }else {
        cell = tableView.dequeueReusableCellWithIdentifier("FriendCell", forIndexPath: indexPath)
        cell.textLabel?.text = groupFriends[indexPath.row]
      }
    }
    
    return cell
  }
  
  override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return section == 0 ? "Friends" : groups[section - 1].title
  }
  
  // MARK: - UITableView Delegate
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  }
  
}
