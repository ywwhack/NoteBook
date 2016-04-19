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
  
  var dataModel = DataModel.sharedDataModel()
  var groups = [Group]()
  var userIsLogin = false
  
  @IBOutlet weak var logoutView: UIView!
  
  override func viewDidLoad() {
    super.viewDidLoad()

    // congfigure UI
    logoutView.backgroundColor = UIColor.clearColor()
    
    if dataModel.username != nil {
      userIsLogin = true
    }else {
      logoutView.hidden = true
    }
    
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    if userIsLogin {
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
  
  @IBAction func logout(sender: UIButton) {
    dataModel.username = nil
    userIsLogin = false
    
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
    if dataModel.username != nil {
      logoutView.hidden = false
    }else {
      logoutView.hidden = true
    }
    tableView.reloadData()
  }
  
  // MARK: - Table view data source
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return userIsLogin ? 1 : 0
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return groups.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("GroupCell", forIndexPath: indexPath)
    
    cell.textLabel?.text = groups[indexPath.row].name
    
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
