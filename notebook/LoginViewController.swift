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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // configure UI
    signupBtn.layer.cornerRadius = 5.0
    loginBtn.layer.cornerRadius = 5.0
  }
  
  @IBAction func signup(sender: UIButton) {
  }
  
  @IBAction func login(sender: UIButton) {
    
  }
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
  
}
