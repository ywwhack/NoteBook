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
  
  var dataModel = DataModel.sharedDataModel()
  var imageNames = [String]()
  
  @IBOutlet weak var messageTextView: UITextView!
  @IBOutlet weak var collectionView: UICollectionView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
  }
  
  @IBAction func cancel(sender: UIBarButtonItem) {
    navigationController?.popViewControllerAnimated(true)
  }
  
  @IBAction func done(sender: UIBarButtonItem) {
    navigationController?.popViewControllerAnimated(true)
    dataModel.addNote(content: messageTextView.text!, images: imageNames)
  }
  
  func imageViewDidTap() {
    let imagePicker = UIImagePickerController()
    imagePicker.delegate = self
    
    let alertController = UIAlertController(title: "Source Type", message: nil, preferredStyle: .ActionSheet)
    let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .Default) { _ in
      imagePicker.sourceType = .PhotoLibrary
      self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    let cameraAction = UIAlertAction(title: "Camera", style: .Default) { _ in
      imagePicker.sourceType = .Camera
      self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { _ in
      self.dismissViewControllerAnimated(true, completion: nil)
    }
    alertController.addAction(photoLibraryAction)
    alertController.addAction(cancelAction)
    if UIImagePickerController.isSourceTypeAvailable(.Camera) {
      alertController.addAction(cameraAction)
    }
    
    presentViewController(alertController, animated: true, completion: nil)
  }
  
  // MARK: - UITableView Delegate
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  }
  
  override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    if indexPath.section == 1 && indexPath.row == 0 {
      return heightOfImageView()
    }else {
      return 163
    }
  }
  
  // MARK: - Utils
  private func parseQuery(query: String) -> [String: String] {
    let queryComponents = query.componentsSeparatedByString("&")
    return queryComponents.reduce([String:String]()) { dict, component -> [String: String] in
      var newDict = dict
      let dictComponent = component.componentsSeparatedByString("=")
      newDict[dictComponent[0]] = dictComponent[1]
      return newDict
    }
  }
  
  private func heightOfImageView() -> CGFloat {
    return (UIScreen.mainScreen().bounds.width - 3 * 10) / 4
  }
  
}

// MARK: - UIImagePickerController Delegate
extension AddNoteViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
    var imageFileName = ""
    if let url = info[UIImagePickerControllerReferenceURL] as? NSURL {
      let query = url.query
      let queryObject = parseQuery(query!)
      imageFileName = "\(queryObject["id"]!).jpg"
    }else {
      imageFileName = "\(dataModel.photoId).jpg"
    }
    
    let image = info[UIImagePickerControllerOriginalImage] as! UIImage
    let data = UIImageJPEGRepresentation(image, 0.9)
    
    do {
      let url = dataModel.applicationDocumentsDirectory.URLByAppendingPathComponent(imageFileName)
      try data?.writeToURL(url, options: .AtomicWrite)
      imageNames.append(imageFileName)
      collectionView.reloadData()
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
    return imageNames.count + 1
  }

  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ImageCell", forIndexPath: indexPath)
    
    let imageView = cell.viewWithTag(1000) as! UIImageView
    if indexPath.row == imageNames.count { // `Add Image` with tap gesture
      imageView.image = UIImage(named: "add")
      imageView.userInteractionEnabled = true
      let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageViewDidTap))
      imageView.addGestureRecognizer(tapGestureRecognizer)
    }else {
      imageView.image = UIImage.nameInDocuments(imageNames[indexPath.row])
    }
  
    return cell
  }
}

// MAKR: - Collection view delegate flow layout
extension AddNoteViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    return CGSizeMake(heightOfImageView(), heightOfImageView())
  }
}
