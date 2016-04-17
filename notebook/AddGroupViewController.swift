//
//  AddGroupFriendViewController.swift
//  notebook
//
//  Created by iYww on 16/4/15.
//  Copyright © 2016年 zank. All rights reserved.
//

import UIKit

class AddGroupViewController: UITableViewController {
  
  var groupIndex: Int!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  // MARK: - Table view data source
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 0
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 0
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("AddFriendToGroupCell", forIndexPath: indexPath)
    
    return cell
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
  }
  
  // MARK: - Segue
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
  }
  
}
