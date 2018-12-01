//
//  Item.swift
//  Todoey
//
//  Created by Nate Graham on 2/9/18.
//  Copyright © 2018 Nate Graham. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    
    @objc dynamic var title = ""
    @objc dynamic var done = false
    @objc dynamic var dateCreated : Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
