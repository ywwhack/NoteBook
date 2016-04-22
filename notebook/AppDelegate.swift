//
//  AppDelegate.swift
//  notebook
//
//  Created by iYww on 16/4/12.
//  Copyright © 2016年 zank. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  var dataModel = DataModel.sharedDataModel()
  
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    print(dataModel.applicationDocumentsDirectory)
    if dataModel.username == nil {
      let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Login") as! LoginViewController
      window?.rootViewController = loginVC
    }
    return true
  }

  func applicationWillTerminate(application: UIApplication) {
    dataModel.coreDataStack.saveContext()
  }  

}

