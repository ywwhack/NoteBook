//
//  GroupDetailViewController.swift
//  notebook
//
//  Created by iYww on 16/4/18.
//  Copyright © 2016年 zank. All rights reserved.
//

import UIKit

class GroupDetailViewController: UITableViewController {
  
  var groupInfo: Group!
  var sharedNotes = [String]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = groupInfo.name
    RemoteResource.getGroupDetailWithId(groupInfo.id) { requestResult in
      switch requestResult {
      case .Success(let result):
        guard let data = result["data"] as? [String: AnyObject], notes = data["notes"] as? [[String: AnyObject]] else {
          return
        }
        self.sharedNotes = notes.map { note in note["content"] as! String }
        self.tableView.reloadData()
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
    return sharedNotes.count
  }
  
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("NoteCell", forIndexPath: indexPath)
    
    cell.textLabel?.text = sharedNotes[indexPath.row]
    
    return cell
  }
 
  
}
