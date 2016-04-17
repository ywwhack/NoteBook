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
  var groups = [Group]()
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
    
    if let userInfo = dataModel.fetchUserInfo() {
      groups = userInfo.groups
    }
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
    return userIsLogin ? groups.count : 0
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return groups[section].users.count + 1
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell: UITableViewCell
    
    let groupUsers = groups[indexPath.section].users
    if indexPath.row == groupUsers.count {
      cell = tableView.dequeueReusableCellWithIdentifier("AddFriendCell", forIndexPath: indexPath)
    }else if indexPath.row > groupUsers.count {
      cell = tableView.dequeueReusableCellWithIdentifier("ComfirmFriendCell", forIndexPath: indexPath)
    }else {
      cell = tableView.dequeueReusableCellWithIdentifier("FriendCell", forIndexPath: indexPath)
      cell.textLabel?.text = groupUsers[indexPath.row]
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
  
  // MARK: - Segue
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "AddFriendToGroup" {
//      let addGroupFriendVC = segue.destinationViewController as! AddGroupFriendViewController
//      let indexPath = tableView.indexPathForCell(sender?.superview?!.superview as! UITableViewCell)!
//      let groupIndex = indexPath.section - 1
//      let groupFriends = groups[groupIndex].friends
//      let notContainsFriends = friends.filter { friend in
//        return !groupFriends.contains(friend)
//      }.map { (friendName) -> Friend in
//        return Friend(name: friendName, selected: false)
//      }
//      
//      addGroupFriendVC.friends = notContainsFriends
//      addGroupFriendVC.groupIndex = groupIndex
    }else if segue.identifier == "AddFriend" {
      let addFriendVC = segue.destinationViewController as! AddFriendViewController
      addFriendVC.dataModel = dataModel
    }
  }
  
  @IBAction func close(segue: UIStoryboardSegue) {
    // Empty for unwind segue
  }
  
}
