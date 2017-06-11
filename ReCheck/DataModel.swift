//
//  DataModel.swift
//  ReCheck
//
//  Created by Dmytro Pasinchuk on 08.06.17.
//  Copyright © 2017 Dmytro Pasinchuk. All rights reserved.
//

import Foundation
import RealmSwift

class DataModel {
    //let dataBase = try! Realm()
    
    var lists = [CheckList]()
    var indexOfSelectedChecklist: Int {
        get {
            return UserDefaults.standard.integer(forKey: "ChecklistIndex")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "ChecklistIndex")
        }
    }
    
    init() {
        loadCheckList()
        registerDefaults()
        handleFirstLaunch()
    }
    
    func sortChecklists() {
        lists.sort(by: { checklist1, checklist2 in
            return checklist1.name.localizedStandardCompare(checklist2.name) == .orderedAscending
        })
    }
    static func nextChecklistItemID() -> Int {
        let userDefaults = UserDefaults.standard
        let itemID = userDefaults.integer(forKey: "ChecklistItemID")
        userDefaults.set(itemID + 1, forKey: "ChecklistItemID")
        checkValid(id: itemID + 1)
        userDefaults.synchronize()
        return itemID
    }
    static func checkValid(id: Int) {
        let maxInt = Int.max
        if id == maxInt {
            UserDefaults.standard.set(0, forKey: "ChecklistItemID")
        }
    }
    
    func handleFirstLaunch() {
        let firstTime = UserDefaults.standard.bool(forKey: "FirstTime")
        if firstTime {
            let checklist = CheckList(name: "List")
            lists.append(checklist)
            indexOfSelectedChecklist = 0
            UserDefaults.standard.set(false, forKey: "FirstTime")
            UserDefaults.standard.synchronize()
        }
    }
    
    func registerDefaults() {
        let dictionary: [String:Any] = ["ChecklistIndex":-1,
                                        "FirstTime":true,
                                        "ChecklistItemID": 0]
        UserDefaults.standard.register(defaults: dictionary)
    }
    
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("Checklists.plist")
    }
    //This was used for save to "Checklists.plist" file in User document directory, uncoment to back to this method
    
    func saveCheckList() {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        archiver.encode(lists, forKey: "Checklists")
        archiver.finishEncoding()
        data.write(to: dataFilePath(), atomically: true)
    }
    
    func loadCheckList() {
        let path = dataFilePath()
        
        if let data = try? Data(contentsOf: path) {
            let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
            lists = unarchiver.decodeObject(forKey: "Checklists") as! [CheckList]
            unarchiver.finishDecoding()
            sortChecklists()
            for checklist in lists {
                checklist.sortChecklistItems()
            }
        }
    }
    
    //This was used for save to "default.realm" file in User document directory, uncoment to back to this method
    /*
    func saveCheckList() {
        for list in lists {
            let checkList = ChecklistRealm()
            checkList.name = list.name
            checkList.iconName = list.iconName
            
            for checklistItem in list.items {
                let checkListItem = CheckListItemRealm()
                checkListItem.text = checklistItem.text
                checkListItem.dueDate = checklistItem.dueDate as NSDate
                checkListItem.isChecked = checklistItem.isChecked
                checkListItem.itemID = checklistItem.itemID
                
                checkList.items.append(checkListItem)
            }
            try! dataBase.write {
                dataBase.add(checkList)
            }
            
        }
    }
    
    func loadCheckList() {
        let checklistResult = dataBase.objects(ChecklistRealm.self)
        for list in checklistResult {
            let checklist = CheckList(name: list.name)
            checklist.iconName = list.iconName
            for checklistItem in list.items {
                let item = CheckListItem()
                item.text = checklistItem.text
                item.dueDate = checklistItem.dueDate as! Date
                item.isChecked = checklistItem.isChecked
                item.itemID = checklistItem.itemID
                
                checklist.items.append(item)
            }
        }
        
    }
    */
}
