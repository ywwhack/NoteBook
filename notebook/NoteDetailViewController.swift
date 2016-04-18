//
//  NoteDetailViewController.swift
//  notebook
//
//  Created by iYww on 16/4/13.
//  Copyright © 2016年 zank. All rights reserved.
//

import UIKit

class NoteDetailViewController: UITableViewController {
  
  @IBOutlet weak var messageTextView: UITextView!
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var detailLabel: UILabel!
  
  var imageNames: [String]!
  var content: String!
  var dataModel = DataModel.sharedDataModel()
  var note: Note!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // configure UI
    messageTextView.text = content
    messageTextView.font = UIFont.systemFontOfSize(16)
    messageTextView.constraints.forEach { constraint in
      if constraint.firstAttribute == .Height {
        constraint.constant = heightForMessage(content)
      }
    }
    
    imageNames = note.images as! [String]
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    if let groupname = note.groupname {
      detailLabel.text = groupname
    }else {
      detailLabel.text = nil
    }
  }
  
  func heightForMessage(message: String) -> CGFloat {
    return (message as NSString).boundingRectWithSize(CGSizeMake(UIScreen.mainScreen().bounds.width - 20, 1000) , options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont.systemFontOfSize(16)], context: nil).height
  }
  
  // MARK: - UITableView Datasource
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  // MARK: - Table view delegate
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  }
  
  // MARK: - Navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "ShowImage" {
      let indexPath = collectionView.indexPathForCell(sender as! UICollectionViewCell)!
      let imagePresentationVC = segue.destinationViewController as! ImagePresentationViewController
      imagePresentationVC.imageName = imageNames[indexPath.row]
    }
  }
  
  override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
    if identifier == "ShareToGroup" && note.groupname != nil {
      return false
    }else {
      return true
    }
  }
  
  @IBAction func close(segue: UIStoryboardSegue) {
    // for unwind segue
  }
  
}

// MARK: - UIColloctionView Datasource
extension NoteDetailViewController: UICollectionViewDataSource {
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return imageNames.count
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("NoteDetailImageCell", forIndexPath: indexPath)
    let imageView = cell.viewWithTag(1000) as! UIImageView
    imageView.image = UIImage.nameInDocuments(imageNames[indexPath.row])
    return cell
  }
}
