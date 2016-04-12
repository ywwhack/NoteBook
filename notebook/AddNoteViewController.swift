//
//  AddNoteViewController.swift
//  notebook
//
//  Created by iYww on 16/4/12.
//  Copyright © 2016年 zank. All rights reserved.
//

import UIKit
import CoreData

class AddNoteViewController: UITableViewController {
  
  var managedObjectContext: NSManagedObjectContext!
  
  @IBOutlet weak var messageTextView: UITextView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = false
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem()
  }
  
  @IBAction func cancel(sender: UIBarButtonItem) {
    navigationController?.popViewControllerAnimated(true)
  }
  
  @IBAction func done(sender: UIBarButtonItem) {
    navigationController?.popViewControllerAnimated(true)
    let newNote = NSEntityDescription.insertNewObjectForEntityForName("Note", inManagedObjectContext: managedObjectContext) as! Note
    newNote.message = messageTextView.text
    do {
      try managedObjectContext.save()
    }catch {
      print("Can't save new note, error \(error)")
      fatalError()
    }
  }
  
}
