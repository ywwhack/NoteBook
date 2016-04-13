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
  var notes: [Note]!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    notes = dataModel.fetchNotes()
    tableView.reloadData()
//    notes.forEach { note in
//      print(note.message)
//      print(NSDate(timeIntervalSince1970: note.createAt))
//      print(note.images)
//    }
  }
  
  // MARK: - Segue
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "AddNote" {
      let addNoteVC = segue.destinationViewController as! AddNoteViewController
      addNoteVC.dataModel = dataModel
    }else if segue.identifier == "ShowNote" {
      guard let indexPath = tableView.indexPathForCell(sender as! UITableViewCell) else {
        return
      }
      let note = notes[indexPath.row]
      let noteDetailVC = segue.destinationViewController as! NoteDetailViewController
      noteDetailVC.message = note.message
      noteDetailVC.images = note.images as! [String]
      noteDetailVC.dataModel = dataModel
    }
  }
  
  // MARK: - UITableView Datasource
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return notes.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("NoteListCell", forIndexPath: indexPath)
    cell.textLabel?.text = notes[indexPath.row].message
    return cell
  }
  
}