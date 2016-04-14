//
//  ImagePresentionViewController.swift
//  notebook
//
//  Created by iYww on 16/4/14.
//  Copyright © 2016年 zank. All rights reserved.
//

import UIKit

class ImagePresentationViewController: UIViewController {
  
  @IBOutlet weak var imageView: UIImageView!
  
  var imageName: String!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    imageView.image = UIImage.nameInDocuments(imageName)
  }
  
  @IBAction func back(sender: UITapGestureRecognizer) {
    print("tap")
    dismissViewControllerAnimated(true, completion: nil)
  }
  
}
