//
//  ListDetailTableViewController.swift
//  ReCheck
//
//  Created by Dmytro Pasinchuk on 07.06.17.
//  Copyright © 2017 Dmytro Pasinchuk. All rights reserved.
//

import UIKit

class ListDetailTableViewController: UITableViewController, UITextFieldDelegate, IconPickerViewControllerDelegate {
    
    weak var delegate: ListDetailTableViewControllerDelegate?
    var checklistToEdding: CheckList?
    var iconName = "Folder"
    
    //MARK: - Outlets
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var iconImageView: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let checklistToEdding = checklistToEdding {
            title = "Edit checklist"
            textField.text = checklistToEdding.name
            doneBarButton.isEnabled = true
            iconName = checklistToEdding.iconName
        }
        iconImageView.image = UIImage(named: iconName)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancel() {
        delegate?.listDetailViewControllerDidCancel(self)
    }
    @IBAction func done() {
        if let checklist = checklistToEdding {
            checklist.name = textField.text!
            checklist.iconName = iconName
            delegate?.listDetailViewController(self, didFinishEditing: checklist)
        } else {
            let checkList = CheckList(name: textField.text!, iconName: iconName)
            delegate?.listDetailViewController(self, didFinishAdding: checkList)
        }
    }
    
    //IconPickerViewController Delegate
    func iconPicker(_ picker: IconPickerViewController, didPick iconName: String) {
        self.iconName = iconName
        iconImageView.image = UIImage(named: iconName)
        let _ = navigationController!.popViewController(animated: true)
        
    }
    //TableView Delegate & DataSource
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldString = textField.text! as NSString
        let newString = oldString.replacingCharacters(in: range, with: string) as NSString
        
        doneBarButton.isEnabled = (newString.length > 0)
        
        return true
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 1 {
            return indexPath
        } else {
        return nil
        }
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "PickIcon" {
            let destination = segue.destination as! IconPickerViewController
            destination.delegate = self
        }
    }
    

}

protocol ListDetailTableViewControllerDelegate: class {
    func listDetailViewControllerDidCancel(_ controller: ListDetailTableViewController)
    func listDetailViewController(_ controller: ListDetailTableViewController, didFinishEditing checklist: CheckList)
    func listDetailViewController(_ controller: ListDetailTableViewController, didFinishAdding checklist: CheckList)
}
