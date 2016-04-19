//
//  LoginViewController.swift
//  notebook
//
//  Created by iYww on 16/4/19.
//  Copyright © 2016年 zank. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
  
  @IBOutlet weak var usernameTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var signupBtn: UIButton!
  @IBOutlet weak var loginBtn: UIButton!
  
  var window: UIWindow?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // configure UI
    signupBtn.layer.cornerRadius = 5.0
    loginBtn.layer.cornerRadius = 5.0
    
    window = (UIApplication.sharedApplication().delegate as! AppDelegate).window
  }
  
  @IBAction func signup(sender: UIButton) {
    guard let username = usernameTextField.text, password = passwordTextField.text else {
      return
    }
    RemoteResource.signupWithUsername(username, password: password) { requestResult in
      self.processRequestResult(requestResult, withUsername: username)
    }
  }
  
  @IBAction func login(sender: UIButton) {
    guard let username = usernameTextField.text, password = passwordTextField.text else {
      return
    }
    RemoteResource.loginWithUsername(username, password: password) { requestResult in
      self.processRequestResult(requestResult, withUsername: username)
    }
  }
  
  private func processRequestResult(requestResult: RequestResult, withUsername username: String) {
    switch requestResult {
    case .Success:
      print("success")
      DataModel.sharedDataModel().username = username
      switchToMainContainerViewController()
    case .Failed(let reason):
      print(reason)
    }
  }
  
  private func switchToMainContainerViewController() {
    let loginView = self.view
    let mainContainerVC = self.storyboard!.instantiateInitialViewController()!
    self.window?.rootViewController = mainContainerVC
    mainContainerVC.view.addSubview(loginView)
    mainContainerVC.view.bringSubviewToFront(loginView)
    
    UIView.animateWithDuration(0.5, animations: {
      loginView.center.y -= UIScreen.mainScreen().bounds.height
      }) { _ in
      loginView.removeFromSuperview()
    }
  }
  
}
