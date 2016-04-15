//
//  AddGroupFriendViewController.swift
//  notebook
//
//  Created by iYww on 16/4/15.
//  Copyright © 2016年 zank. All rights reserved.
//

import UIKit

class AddGroupFriendViewController: UITableViewController {
  
  var friends: [String]!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  // MARK: - Table view data source
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return friends.count
  }
  
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("AddFriendToGroupCell", forIndexPath: indexPath)
    
    cell.textLabel?.text = friends[indexPath.row]
    cell.accessoryType = .Checkmark
    
    return cell
  }
  
  
}
