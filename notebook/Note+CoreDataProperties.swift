//
//  Note+CoreDataProperties.swift
//  notebook
//
//  Created by iYww on 16/4/18.
//  Copyright © 2016年 zank. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Note {

    @NSManaged var createAt: NSTimeInterval
    @NSManaged var images: NSObject?
    @NSManaged var content: String
    @NSManaged var groupname: String?

}
