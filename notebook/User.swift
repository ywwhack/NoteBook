//
//  User.swift
//  notebook
//
//  Created by iYww on 16/4/14.
//  Copyright © 2016年 zank. All rights reserved.
//

import Foundation
import CoreData

class User: NSManagedObject {
  func getSortedNotes() -> [Note]? {
    guard let notes = notes else {
      return nil
    }
    let sortDescriptor = NSSortDescriptor(key: "createAt", ascending: false)
    return notes.sortedArrayUsingDescriptors([sortDescriptor]) as? [Note]
  }
}
