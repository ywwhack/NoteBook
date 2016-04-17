//
//  FriendsViewController.swift
//  notebook
//
//  Created by iYww on 16/4/14.
//  Copyright © 2016年 zank. All rights reserved.
//

import UIKit
import Alamofire

class GroupsViewController: UITableViewController {
  
  var dataModel: DataModel!
  var groups = [String]()
  var userIsLogin = false
  
  @IBOutlet weak var loginView: UIView!
  @IBOutlet weak var usernameTextFiled: UITextField!
  @IBOutlet weak var passwordTextFiled: UITextField!
  @IBOutlet weak var logoutView: UIView!
  
  override func viewDidLoad() {
    super.viewDidLoad()

    // congfigure UI
    loginView.backgroundColor = UIColor.clearColor()
    logoutView.backgroundColor = UIColor.clearColor()
    
    if dataModel.username != nil {
      userIsLogin = true
      loginView.hidden = true
    }else {
      logoutView.hidden = true
    }
    
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    RemoteResource.getAllGroups { requestResult in
      switch requestResult {
      case .Success(let result):
        guard let groups = result["groups"] as? [String] else {
          return
        }
        self.groups = groups
        self.tableView.reloadData()
      case .Failed(let reason):
        print(reason)
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
  
  @IBAction func signUp(sender: UIButton) {
    if let username = usernameTextFiled.text, password = passwordTextFiled.text {
      RemoteResource.signupWithUsername(username, password: password) { userInfoResult in
        switch userInfoResult {
        case .Success:
          self.dataModel.username = username
          self.updateUI()
        case .Failed(let reason):
          print(reason)
        }
      }
    }
  }
  
  @IBAction func Login(sender: UIButton) {
    if let username = usernameTextFiled.text, password = passwordTextFiled.text {
      RemoteResource.loginWithUsername(username, password: password) { userInfoResult in
        switch userInfoResult {
        case .Success:
          self.dataModel.username = username
          self.updateUI()
        case .Failed(let reason):
          print(reason)
        }
      }
    }
  }
  
  @IBAction func logout(sender: UIButton) {
    dataModel.username = nil
    updateUI()
  }
  
  func updateUI() {
    if dataModel.username != nil {
      loginView.hidden = true
      logoutView.hidden = false
    }else {
      loginView.hidden = false
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
    
    cell.textLabel?.text = groups[indexPath.row]
    
    return cell
  }
  
  // MARK: - UITableView Delegate
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  }
  
  @IBAction func close(segue: UIStoryboardSegue) {
    // Empty for unwind segue
  }
  
}
