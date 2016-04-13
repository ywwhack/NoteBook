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

  var dataModel: DataModel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    let notes = dataModel.fetchNotes()
    notes.forEach { note in
      print(note.message)
      print(NSDate(timeIntervalSince1970: note.createAt))
      print(note.images)
    }
  }
  
  // MARK: - Segue
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "AddNote" {
      let addNoteVC = segue.destinationViewController as! AddNoteViewController
      addNoteVC.dataModel = dataModel
    }
  }
  
}