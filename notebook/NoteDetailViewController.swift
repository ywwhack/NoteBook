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
  
  var images: [String]!
  var message: String!
  var dataModel: DataModel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    messageTextView.text = message
    messageTextView.translatesAutoresizingMaskIntoConstraints = false
    // FIXME: height constraint unsatisfied
    messageTextView.heightAnchor.constraintEqualToConstant(heightForMessage(message)).active = true
    messageTextView.setNeedsLayout()
  }
  
  func heightForMessage(message: String) -> CGFloat {
    return (message as NSString).boundingRectWithSize(CGSizeMake(UIScreen.mainScreen().bounds.width - 20, 1000) , options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont.systemFontOfSize(14)], context: nil).height
  }
  
  // MARK: - UITableView Datasource
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
}

extension NoteDetailViewController: UICollectionViewDataSource {
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return images.count
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("NoteDetailImageCell", forIndexPath: indexPath)
    let imageView = cell.viewWithTag(1000) as! UIImageView
    imageView.image = UIImage.nameInDocuments(images[indexPath.row])
    return cell
  }
}
