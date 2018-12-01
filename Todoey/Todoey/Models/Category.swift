//
//  Category.swift
//  Todoey
//
//  Created by Nate Graham on 2/9/18.
//  Copyright © 2018 Nate Graham. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var name = ""
    @objc dynamic var color: String?
    
    let items = List<Item>()
}
