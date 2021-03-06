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
  var sharedNotes = [[String: AnyObject]]()
  var members = [String]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = groupInfo.name
    RemoteResource.getGroupDetailWithId(groupInfo.id) { requestResult in
      switch requestResult {
      case .Success(let result):
        guard let data = result["data"] as? [String: AnyObject], notes = data["notes"] as? [[String: AnyObject]], members = data["members"] as? [String] else {
          return
        }
        self.sharedNotes = notes
        self.members = members
        self.tableView.reloadData()
      case .Failed(let reason):
        print(reason)
      }
    }
  }
  
  // MARK: - Table view data source
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 2
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return section == 0 ? members.count + 1 : sharedNotes.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell: UITableViewCell
    if indexPath.section == 0 {
      if indexPath.row == members.count {
        cell = tableView.dequeueReusableCellWithIdentifier("AddMemberCell", forIndexPath: indexPath)
      }else {
        cell = tableView.dequeueReusableCellWithIdentifier("MemberCell", forIndexPath: indexPath)
        cell.textLabel?.text = members[indexPath.row]
      }
    }else {
      cell = tableView.dequeueReusableCellWithIdentifier("NoteCell", forIndexPath: indexPath)
      
      cell.textLabel?.text = sharedNotes[indexPath.row]["content"] as? String
      cell.detailTextLabel?.text = sharedNotes[indexPath.row]["ownername"] as? String
    }
    
    return cell
  }
  
  override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return section == 0 ? "Members" : "Shared Notes"
  }
  
  // MARK: - Table view delegate
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  }
  
  // MARK: - Navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "AddGroupMember" {
      let addGroupMemberVC = segue.destinationViewController as! AddGroupMemberViewController
      addGroupMemberVC.groupId = groupInfo.id
    }
  }
  
}
