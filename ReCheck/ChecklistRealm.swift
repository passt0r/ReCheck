//
//  ChecklistRealm.swift
//  ReCheck
//
//  Created by Dmytro Pasinchuk on 11.06.17.
//  Copyright © 2017 Dmytro Pasinchuk. All rights reserved.
//

import Foundation
import RealmSwift

class ChecklistRealm: Object {
    dynamic var name = ""
    dynamic var iconName = ""
    let items = List<CheckListItemRealm>()
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
}
