//
//  ShareToGroupViewController.swift
//  notebook
//
//  Created by iYww on 16/4/18.
//  Copyright © 2016年 zank. All rights reserved.
//

import UIKit

class ShareToGroupViewController: UITableViewController {
  
  var groups = [Group]()
  var selectedGroupIndex: Int?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    RemoteResource.getAllGroups { requestResult in
      switch requestResult {
      case .Success(let result):
        guard let groups = result["groups"] as? [[String: AnyObject]] else {
          return
        }
        self.groups = groups.map { group in Group(name: group["name"] as! String, id: group["id"] as! String)
        }
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
    return groups.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("GroupCell", forIndexPath: indexPath)
    
    cell.textLabel?.text = groups[indexPath.row].name
    if let selectedGroupIndex = selectedGroupIndex where selectedGroupIndex == indexPath.row {
      cell.accessoryType = .Checkmark
    }else {
      cell.accessoryType = .None
    }
    
    return cell
  }
  
  // MARK: - Table view delegate
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    
    if let groupIndex = selectedGroupIndex {
      if groupIndex != indexPath.row {
        let oldSelectedGroupIndex = groupIndex
        selectedGroupIndex = indexPath.row
        let indexPaths = [NSIndexPath(forRow: oldSelectedGroupIndex, inSection: 0), NSIndexPath(forRow: groupIndex, inSection: 0)]
        tableView.reloadRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
      }else {
        selectedGroupIndex = nil
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
      }
    }else {
      selectedGroupIndex = indexPath.row
      tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }
  }
  
   // MARK: - Navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let selectedGroupIndex = selectedGroupIndex where segue.identifier == "DoneToNoteDetail" {
      let noteDetailVC = segue.destinationViewController as! NoteDetailViewController
      let group = groups[selectedGroupIndex]
      RemoteResource.addNote(noteDetailVC.content, toGroup: group.id) { requestResult in
        switch requestResult {
        case .Success:
          noteDetailVC.note.groupname = group.name
          noteDetailVC.detailLabel.text = group.name
          noteDetailVC.tableView.reloadData()
          noteDetailVC.dataModel.coreDataStack.saveContext()
          print("success")
        case .Failed(let reason):
          print(reason)
        }
      }
    }
  }
  
}
