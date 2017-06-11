//
//  ItemDetailViewController.swift
//  ReCheck
//
//  Created by Dmytro Pasinchuk on 04.06.17.
//  Copyright © 2017 Dmytro Pasinchuk. All rights reserved.
//

import UIKit
import UserNotifications

class ItemDetailViewController: UITableViewController, UITextFieldDelegate {
    
    //MARK: - Outlets
    @IBOutlet weak var taskAddField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var shouldRemingSwitch: UISwitch!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var datePickerCell: UITableViewCell!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    weak var delegate: ItemDetailViewControllerDelegate?
    var itemToEdit: CheckListItem?
    var datePickerIsVisible = false
    
    var dueDate = Date()
    
    //MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let item = itemToEdit {
            title = "Edit Item"
            taskAddField.text = item.text
            doneBarButton.isEnabled = true
            shouldRemingSwitch.isOn = item.shouldRemind
            dueDate = item.dueDate
        }
        updateDueDateLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        taskAddField.becomeFirstResponder()
    }
    
    func updateDueDateLabel() {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        dueDateLabel.text = formatter.string(from: dueDate)
    }
    func showDatePicker() {
        datePickerIsVisible = true
        
        let indexPathDateRow = IndexPath(row: 1, section: 1)
        let indexPathDatePicker = IndexPath(row: 2, section: 1)
        
        if let dateCell = tableView.cellForRow(at: indexPathDateRow) {
            dateCell.detailTextLabel?.textColor = dateCell.detailTextLabel?.tintColor
        }
        tableView.beginUpdates()
        tableView.insertRows(at: [indexPathDatePicker], with: .fade)
        tableView.reloadRows(at: [indexPathDateRow], with: .none)
        tableView.endUpdates()
        
        datePicker.setDate(dueDate, animated: false)
    }
    func hideDatePicker() {
        if datePickerIsVisible {
            datePickerIsVisible = false
            
            let indexPathDateRow = IndexPath(row: 1, section: 1)
            let indexPathDatePicker = IndexPath(row: 2, section: 1)
            
            if let dateCell = tableView.cellForRow(at: indexPathDateRow) {
                dateCell.detailTextLabel?.textColor = UIColor(white: 0, alpha: 0.5)
            }
            tableView.beginUpdates()
            tableView.reloadRows(at: [indexPathDateRow], with: .none)
            tableView.deleteRows(at: [indexPathDatePicker], with: .fade)
            tableView.endUpdates()
        }
    }
    
    //MARK: - Actions
    @IBAction func cancelButtontouched() {
        delegate?.itemDetailViewControllerDidCancel(self)
    }
    @IBAction func doneButtonTouched() {
        if let item = itemToEdit {
            item.text = taskAddField.text!
            item.shouldRemind = shouldRemingSwitch.isOn
            item.dueDate = dueDate
            item.scheduleNotifications()
            delegate?.itemDetailViewController(self, didFinishEditing: item)
            
        } else {
            let item = CheckListItem(text: taskAddField.text!)
            item.shouldRemind = shouldRemingSwitch.isOn
            item.dueDate = dueDate
            item.scheduleNotifications()
            delegate?.itemDetailViewController(self, didFinishAdding: item)
            
        }
    }
    
    @IBAction func dateChanged(_ sender: UIDatePicker) {
        dueDate = sender.date
        updateDueDateLabel()
    }
    
    @IBAction func shouldRemindToggled(_ sender: UISwitch) {
        taskAddField.resignFirstResponder()
        
        if sender.isOn {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert,.sound]) {granded, error in
                
            }
        }
    }

    
    //MARK: - TableView Delegate And Data Source
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 1 && indexPath.row == 1 {
            return indexPath
        } else {
            return nil
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        taskAddField.resignFirstResponder()
        
        if indexPath.section == 1 && indexPath.row == 1 {
            if !datePickerIsVisible {
                showDatePicker()
            } else {
                hideDatePicker()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 && datePickerIsVisible {
            return 3
        } else {
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 && indexPath.row == 2 {
            return datePickerCell
        } else {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
    }
    override func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        var newIndexPath = indexPath
        if indexPath.section == 1 && indexPath.row == 2 {
            newIndexPath = IndexPath(row: 0, section: indexPath.section)
        }
        return super.tableView(tableView, indentationLevelForRowAt: newIndexPath)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 && indexPath.row == 2 {
            return 217
        } else {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
    
    //MARK: - UITextFieldDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let oldText = textField.text! as NSString
        let newText = oldText.replacingCharacters(in: range, with: string) as NSString
        
        doneBarButton.isEnabled = (newText.length > 0)
        
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        hideDatePicker()
    }
}

//MARK: - ItemDetailViewController Delegate
protocol ItemDetailViewControllerDelegate: class {
    //Invoke when user press Cancel button
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController)
    //Invoke when user finish editing an exist item and press Done
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: CheckListItem)
    //Invoke when user finish create new item and press Done
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: CheckListItem)
}
