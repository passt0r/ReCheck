//
//  CheckListItemRealm.swift
//  ReCheck
//
//  Created by Dmytro Pasinchuk on 11.06.17.
//  Copyright © 2017 Dmytro Pasinchuk. All rights reserved.
//

import Foundation
import RealmSwift

class CheckListItemRealm: Object {
    dynamic var text = ""
    dynamic var isChecked = false
    dynamic var dueDate = NSDate()
    dynamic var shouldRemind = false
    dynamic var itemID = 0
    
    let list = LinkingObjects(fromType: ChecklistRealm.self, property: "items")
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
}
