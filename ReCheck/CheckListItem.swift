//
//  CheckListItem.swift
//  ReCheck
//
//  Created by Dmytro Pasinchuk on 18.05.17.
//  Copyright © 2017 Dmytro Pasinchuk. All rights reserved.
//

import Foundation
import UserNotifications

class CheckListItem: NSObject, NSCoding {
    var text = ""
    var isChecked = false
    var dueDate = Date()
    var shouldRemind = false
    var itemID: Int
    
    
    required init?(coder aDecoder: NSCoder) {
        text = aDecoder.decodeObject(forKey: "Text") as! String
        isChecked = aDecoder.decodeBool(forKey: "Checked")
        dueDate = aDecoder.decodeObject(forKey: "DueDate") as! Date
        shouldRemind = aDecoder.decodeBool(forKey: "ShouldRemind")
        itemID = aDecoder.decodeInteger(forKey: "ItemID")
    }
    convenience override init() {
        self.init(text: "", isChecked: false)
    }
    convenience init(text: String) {
        self.init(text: text, isChecked: false)
    }
    init(text: String, isChecked: Bool) {
        self.text = text
        self.isChecked = isChecked
        self.itemID = DataModel.nextChecklistItemID()
        super.init()
    }
    deinit {
        remoteNotification()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(text, forKey: "Text")
        aCoder.encode(isChecked, forKey: "Checked")
        aCoder.encode(dueDate, forKey: "DueDate")
        aCoder.encode(shouldRemind, forKey: "ShouldRemind")
        aCoder.encode(itemID, forKey: "ItemID")
        
    }
    
    func toggleChecked() {
        isChecked = !isChecked
    }
    func remoteNotification() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["\(itemID)"])
    }
    
    func scheduleNotifications() {
        remoteNotification()
        if shouldRemind && dueDate > Date() {
            let content = UNMutableNotificationContent()
            content.title = "Reminder:"
            content.body = text
            content.sound = UNNotificationSound.default()
            
            let calendar = Calendar(identifier: .gregorian)
            let components = calendar.dateComponents([.month, .day, .hour, .minute], from: dueDate)
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            let request = UNNotificationRequest(identifier: "\(itemID)", content: content, trigger: trigger)
            let center = UNUserNotificationCenter.current()
            center.add(request)
        }
    }
}
