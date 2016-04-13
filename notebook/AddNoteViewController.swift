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
  
  var dataModel: DataModel!
  var images = [String]()
  
  @IBOutlet weak var messageTextView: UITextView!
  @IBOutlet weak var collectionView: UICollectionView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    
    // collectionView.reloadData()
  }
  
  @IBAction func cancel(sender: UIBarButtonItem) {
    navigationController?.popViewControllerAnimated(true)
  }
  
  @IBAction func done(sender: UIBarButtonItem) {
    navigationController?.popViewControllerAnimated(true)
    let newNote = NSEntityDescription.insertNewObjectForEntityForName("Note", inManagedObjectContext: dataModel.managedObjectContext) as! Note
    newNote.message = messageTextView.text
    newNote.createAt = NSDate().timeIntervalSince1970
    do {
      try dataModel.managedObjectContext.save()
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
  
  // MARK: - Utils
  func parseQuery(query: String) -> [String: String] {
    let queryComponents = query.componentsSeparatedByString("&")
    return queryComponents.reduce([String:String]()) { dict, component -> [String: String] in
      var newDict = dict
      let dictComponent = component.componentsSeparatedByString("=")
      newDict[dictComponent[0]] = dictComponent[1]
      return newDict
    }
  }
  
}

// MARK: - UIImagePickerController Delegate
extension AddNoteViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
    let query = (info[UIImagePickerControllerReferenceURL] as! NSURL).query
    let queryObject = parseQuery(query!)
    print(queryObject)
    let image = info[UIImagePickerControllerOriginalImage] as! UIImage
    let data = UIImageJPEGRepresentation(image, 0.9)
    do {
      let url = dataModel.applicationDocumentsDirectory.URLByAppendingPathComponent(queryObject["id"]!)
      try data?.writeToURL(url, options: .AtomicWrite)
      images.append(url.path!)
      collectionView.reloadData()
      print(images)
    }catch {
      print("Save image file error \(error)")
      fatalError()
    }
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  func imagePickerControllerDidCancel(picker: UIImagePickerController) {
    dismissViewControllerAnimated(true, completion: nil)
  }
}

// MARK: - UICollectionView Datasource
extension AddNoteViewController: UICollectionViewDataSource {
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    // The addition imageView is `Add Image`
    return images.count + 1
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ImageCell", forIndexPath: indexPath)
    
    let imageView = cell.viewWithTag(1000) as! UIImageView
    if indexPath.row == images.count { // `Add Image` with tap gesture
      imageView.image = UIImage(named: "add")
      imageView.userInteractionEnabled = true
      let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageViewDidTap))
      imageView.addGestureRecognizer(tapGestureRecognizer)
    }else {
      imageView.image = UIImage(data: NSData(contentsOfFile: images[indexPath.row])!)
    }
  
    return cell
  }
}
