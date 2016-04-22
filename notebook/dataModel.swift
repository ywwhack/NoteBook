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
  
  // MARK: - sharedDataModel
  private static var dataModel: DataModel = {
    return DataModel()
  }()
  
  static func sharedDataModel() -> DataModel {
    return dataModel
  }
  
  // MARK: - Core Data stack
  lazy var applicationDocumentsDirectory: NSURL = {
    let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
    return urls[urls.count-1]
  }()
  
  private lazy var managedObjectModel: NSManagedObjectModel = {
    let modelURL = NSBundle.mainBundle().URLForResource("notebook", withExtension: "momd")!
    return NSManagedObjectModel(contentsOfURL: modelURL)!
  }()
  
  private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
    let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
    let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
    var failureReason = "There was an error creating or loading the application's saved data."
    do {
      try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
    } catch {
      var dict = [String: AnyObject]()
      dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
      dict[NSLocalizedFailureReasonErrorKey] = failureReason
      
      dict[NSUnderlyingErrorKey] = error as NSError
      let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
      NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
      abort()
    }
    
    return coordinator
  }()
  
  lazy var managedObjectContext: NSManagedObjectContext = {
    let coordinator = self.persistentStoreCoordinator
    var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
    managedObjectContext.persistentStoreCoordinator = coordinator
    return managedObjectContext
  }()
  
  // MARK: - Core Data Saving support
  
  func saveContext () {
    if managedObjectContext.hasChanges {
      do {
        try managedObjectContext.save()
      } catch {
        let nserror = error as NSError
        NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
        abort()
      }
    }
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
    let newNote = NSEntityDescription.insertNewObjectForEntityForName("Note", inManagedObjectContext: managedObjectContext) as! Note
    newNote.content = content
    newNote.createAt = NSDate().timeIntervalSince1970
    newNote.images = images
    newNote.owner = user!
    saveContext()
  }
  
  // MAKR: - User related methods
  private func createNewUser(username: String) -> User {
    let newUser = NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: managedObjectContext) as! User
    newUser.name = username
    saveContext()
    
    return newUser
  }
  
  var user: User? {
    if let username = username {
      let fetchRequest = NSFetchRequest(entityName: "User")
      fetchRequest.predicate = NSPredicate(format: "name=%@", username)
      do {
        let users = try managedObjectContext.executeFetchRequest(fetchRequest) as! [User]
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
      return userDefaults.valueForKey("Username") as? String
    }
    
    set {
      userDefaults.setObject(newValue, forKey: "Username")
    }
  }
  
  private var userDefaults: NSUserDefaults = {
    return NSUserDefaults.standardUserDefaults()
  }()
  
}