//
//  dataModel.swift
//  notebook
//
//  Created by iYww on 16/4/12.
//  Copyright © 2016年 zank. All rights reserved.
//

import Foundation
import CoreData
import Alamofire

class DataModel {
  
  // MARK: - Core Data Stack
  lazy var coreDataStack = CoreDataStack()
  lazy var applicationDocumentsDirectory: NSURL = {
    return self.coreDataStack.applicationDocumentsDirectory
  }()
  var hasChanges: Bool {
    return coreDataStack.managedObjectContext.hasChanges
  }
  
  // MARK: - init
  init() {
    registerDefaults()
  }
  
  // MARK: - sharedDataModel
  private static var dataModel: DataModel = {
    return DataModel()
  }()
  
  static func sharedDataModel() -> DataModel {
    return dataModel
  }
  
  // MARK: - Note related Methods
  func fetchNotes() -> [Note]? {
    guard let user = user else {
      print("User is not login")
      return nil
    }
    return user.getSortedNotes()
  }
  
  func addNote(content content: String, images: [String]) {
    let newNote = NSEntityDescription.insertNewObjectForEntityForName("Note", inManagedObjectContext: coreDataStack.managedObjectContext) as! Note
    newNote.content = content
    newNote.createAt = NSDate().timeIntervalSince1970
    newNote.images = images
    newNote.owner = user!
    coreDataStack.saveContext()
  }
  
  // MAKR: - User related methods
  private func createNewUser(username: String) -> User {
    let newUser = NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: coreDataStack.managedObjectContext) as! User
    newUser.name = username
    coreDataStack.saveContext()
    
    return newUser
  }
  
  var user: User? {
    if let username = username {
      let fetchRequest = NSFetchRequest(entityName: "User")
      fetchRequest.predicate = NSPredicate(format: "name=%@", username)
      do {
        let users = try coreDataStack.managedObjectContext.executeFetchRequest(fetchRequest) as! [User]
        if users.isEmpty {
          return createNewUser(username)
        }else {
          return users[0]
        }
      }catch {
        fatalError("user may be not exist \(error)")
      }
    }else {
      return nil
    }
  }
  
  var username: String? {
    get {
      // mock username: zank
      return "zank"
      // return userDefaults.valueForKey("Username") as? String
    }
    
    set {
      userDefaults.setObject(newValue, forKey: "Username")
    }
  }
  
  var photoId: Int {
    let nextPhotoId = (userDefaults.valueForKey("PhotoId") as! Int) + 1
    userDefaults.setObject(nextPhotoId, forKey: "PhotoId")
    return nextPhotoId
  }
  
  func registerDefaults() {
    let defaults = [
      "PhotoId": 0
    ]
    userDefaults.registerDefaults(defaults)
  }
  
  private var userDefaults: NSUserDefaults = {
    return NSUserDefaults.standardUserDefaults()
  }()
  
}