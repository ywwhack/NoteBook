//
//  UIImage+fileNameInDocuments.swift
//  notebook
//
//  Created by iYww on 16/4/13.
//  Copyright © 2016年 zank. All rights reserved.
//

import UIKit

extension UIImage {
  class func nameInDocuments(name: String) -> UIImage? {
    let documentsDirectory = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
    guard let filePath = documentsDirectory.URLByAppendingPathComponent(name).path else {
      return nil
    }
    return UIImage(contentsOfFile: filePath)
  }
}
