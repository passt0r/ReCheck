//
//  CheckList.swift
//  ReCheck
//
//  Created by Dmytro Pasinchuk on 07.06.17.
//  Copyright © 2017 Dmytro Pasinchuk. All rights reserved.
//

import UIKit

class CheckList: NSObject, NSCoding {
    var name = ""
    var iconName: String
    var items = [CheckListItem]()
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "Name")
        aCoder.encode(items, forKey: "Items")
        aCoder.encode(iconName, forKey: "IconName")
    }
    func countUncheckedItems() -> Int {
        var count = 0
        for item in items where !item.isChecked {
            count += 1
        }
        return count
    }
    func sortChecklistItems() {
        items.sort(by: {item1, item2 in
            return item1.dueDate.compare(item2.dueDate) == .orderedAscending
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "Name") as! String
        items = aDecoder.decodeObject(forKey: "Items") as! [CheckListItem]
        iconName = aDecoder.decodeObject(forKey: "IconName") as! String
        super.init()
    }
    
    init(name: String, iconName: String) {
        self.name = name
        self.iconName = iconName
        super.init()
    }
    
    convenience init(name: String) {
        self.init(name: name, iconName: "No Icon")
    }
    
}
