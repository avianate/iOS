//
//  AbstractManager.swift
//  TodoCoreData
//
//  Created by Nate Graham on 9/4/18.
//  Copyright © 2018 Nate Graham. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class AbstractManager: NSObject {
    // The managedObjectContext for core data
    
    lazy var dataContext: NSManagedObjectContext = {
        let app = UIApplication.shared.delegate as! AppDelegate
        
        return app.persistentContainer.viewContext
    }()
}
