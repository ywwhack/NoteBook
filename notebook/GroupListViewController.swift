//
//  FriendsViewController.swift
//  notebook
//
//  Created by iYww on 16/4/14.
//  Copyright © 2016年 zank. All rights reserved.
//

import UIKit
import Alamofire

class GroupListViewController: UITableViewController {
  
  enum SectionInfo {
    case OnlyLogoutSection
    case BothLogoutAndGroupsSection
  }
  
  var dataModel = DataModel.sharedDataModel()
  var groups = [Group]()
  var sectionInfo = SectionInfo.OnlyLogoutSection
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    if dataModel.username != nil {
      RemoteResource.getAllGroups { requestResult in
        switch requestResult {
        case .Success(let result):
          guard let groups = result["groups"] as? [[String: AnyObject]] else {
            return
          }
          self.groups = groups.map { group in Group(name: group["name"] as! String, id: group["id"] as! String)
          }
          if !groups.isEmpty {
            self.sectionInfo = .BothLogoutAndGroupsSection
          }
          self.tableView.reloadData()
        case .Failed(let reason):
          print(reason)
        }
      }
    }
  }
  
  @IBAction func addGroup(sender: UIBarButtonItem) {
    let alertController = UIAlertController(title: "Add Group", message: nil, preferredStyle: .Alert)
    let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
    let doneAction = UIAlertAction(title: "Done", style: .Default) { _ in
      guard let textFields = alertController.textFields else {
        return
      }
      let groupTextField = textFields[0]
      RemoteResource.createGroup(groupTextField.text!) { requestResult in
        switch requestResult {
        case .Success:
          print("success")
        case .Failed(let reason):
          print(reason)
        }
      }
    }
    alertController.addAction(cancelAction)
    alertController.addAction(doneAction)
    alertController.addTextFieldWithConfigurationHandler(nil)
    
    presentViewController(alertController, animated: true, completion: nil)
  }
  
  @IBAction func logout() {
    dataModel.username = nil
    
    switchToLoginViewController()
    updateUI()
  }
  
  func switchToLoginViewController() {
    let keyWindow = UIApplication.sharedApplication().keyWindow!
    let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Login")
    let containerVC = keyWindow.rootViewController!
    let loginView = loginVC.view
    let containerView = containerVC.view
    let screenHeight = UIScreen.mainScreen().bounds.height
    loginView.center.y -= screenHeight
    containerView.addSubview(loginView)
    containerView.bringSubviewToFront(loginView)
  
    UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: [], animations: {
      loginView.center.y += screenHeight
      }) { _ in
      loginView.removeFromSuperview()
      keyWindow.rootViewController = loginVC
    }
  }
  
  func updateUI() {
    tableView.reloadData()
  }
  
  // MARK: - Table view data source
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    switch sectionInfo {
    case .OnlyLogoutSection: return 1
    case .BothLogoutAndGroupsSection: return 2
    }
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch sectionInfo {
    case .OnlyLogoutSection:
      return 1
    case .BothLogoutAndGroupsSection:
      return section == 0 ? groups.count : 1
    }
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell: UITableViewCell
    
    switch sectionInfo {
    case .OnlyLogoutSection:
      cell = cellForLogoutAtIndexPath(indexPath)
    case .BothLogoutAndGroupsSection:
      if indexPath.section == 0 {
        cell = tableView.dequeueReusableCellWithIdentifier("GroupCell", forIndexPath: indexPath)
        
        cell.textLabel?.text = groups[indexPath.row].name
      }else {
        cell = cellForLogoutAtIndexPath(indexPath)
      }
    }
    
    return cell
  }
  
  private func cellForLogoutAtIndexPath(indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("LogoutCell", forIndexPath: indexPath)
    let logoutBtn = cell.viewWithTag(1000) as! UIButton
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(GroupListViewController.logout))
    logoutBtn.addGestureRecognizer(tapGestureRecognizer)
    
    return cell
  }
  
  // MARK: - UITableView Delegate
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  }
  
  // MARK: - Navigation
  @IBAction func close(segue: UIStoryboardSegue) {
    // Empty for unwind segue
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "ShowGroupDetail" {
      guard let indexPath = tableView.indexPathForCell(sender as! UITableViewCell) else {
        return
      }
      let groupDetailVC = segue.destinationViewController as! GroupDetailViewController
      let group = groups[indexPath.row]
      groupDetailVC.groupInfo = group
    }
  }
  
}
