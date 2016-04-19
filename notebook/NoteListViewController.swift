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

  var dataModel = DataModel.sharedDataModel()
  var notes = [Note]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    if let notes = dataModel.fetchNotes() {
      self.notes = notes
      tableView.reloadData()
    }
  }
  
  // MARK: - Navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "ShowNote" {
      guard let indexPath = tableView.indexPathForCell(sender as! UITableViewCell) else {
        return
      }
      let note = notes[indexPath.row]
      let noteDetailVC = segue.destinationViewController as! NoteDetailViewController
      noteDetailVC.content = note.content
      noteDetailVC.imageNames = note.images as! [String]
      noteDetailVC.note = note
    }
  }
  
  // MARK: - UITableView Datasource
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return notes.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("NoteListCell", forIndexPath: indexPath)
    cell.textLabel?.text = notes[indexPath.row].content
    return cell
  }
  
}