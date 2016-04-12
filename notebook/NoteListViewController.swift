//
//  ViewController.swift
//  notebook
//
//  Created by iYww on 16/4/12.
//  Copyright © 2016年 zank. All rights reserved.
//

import UIKit
import CoreData

class NoteListViewController: UITableViewController {

  var managedObjectContext: NSManagedObjectContext!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let fetchRequest = NSFetchRequest(entityName: "Note")
    do {
      let results = try managedObjectContext.executeFetchRequest(fetchRequest) as! [Note]
      results.forEach{ note in
        print(note.message)
      }
    }catch {
      print("Can't fetch result, error \(error)")
      fatalError()
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: - Segue
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "AddNote" {
      let addNoteVC = segue.destinationViewController as! AddNoteViewController
      addNoteVC.managedObjectContext = managedObjectContext
    }
  }
  
}