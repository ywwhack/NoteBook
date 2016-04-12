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
  @IBOutlet weak var imageView: UIImageView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    imageView.userInteractionEnabled = true
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageViewDidTap))
    imageView.addGestureRecognizer(tapGestureRecognizer)
  }
  
  @IBAction func cancel(sender: UIBarButtonItem) {
    navigationController?.popViewControllerAnimated(true)
  }
  
  @IBAction func done(sender: UIBarButtonItem) {
    navigationController?.popViewControllerAnimated(true)
    let newNote = NSEntityDescription.insertNewObjectForEntityForName("Note", inManagedObjectContext: managedObjectContext) as! Note
    newNote.message = messageTextView.text
    newNote.createAt = NSDate().timeIntervalSince1970
    do {
      try managedObjectContext.save()
    }catch {
      print("Can't save new note, error \(error)")
      fatalError()
    }
  }
  
  func imageViewDidTap() {
    let imagePicker = UIImagePickerController()
    imagePicker.delegate = self
    presentViewController(imagePicker, animated: true, completion: nil)
  }
  
  // MARK: - UITableView Delegate
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  }
  
}

// MARK: - UIImagePickerController Delegate
extension AddNoteViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  func imagePickerControllerDidCancel(picker: UIImagePickerController) {
    dismissViewControllerAnimated(true, completion: nil)
  }
}
