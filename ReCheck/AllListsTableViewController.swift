//
//  AllListsTableViewController.swift
//  ReCheck
//
//  Created by Dmytro Pasinchuk on 07.06.17.
//  Copyright © 2017 Dmytro Pasinchuk. All rights reserved.
//

import UIKit

class AllListsTableViewController: UITableViewController, ListDetailTableViewControllerDelegate, UINavigationControllerDelegate {
    //MARK: - Properties
    var dataModel: DataModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.delegate = self
        let index = dataModel.indexOfSelectedChecklist
        if index >= 0 && index < dataModel.lists.count{
            let checklist = dataModel.lists[index]
            performSegue(withIdentifier: "ShowChecklist", sender: checklist)
        }
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func makeCell(for tableView: UITableView) -> UITableViewCell {
        let cellIdentifer = "Cell"
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifer) {
            return cell
        } else {
            return UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifer)
        }
    }
    
    func countingMassage(of checklist: CheckList) -> String {
        let count = checklist.countUncheckedItems()
        if checklist.items.count == 0 {
            return "(No Items)"
        } else if count == 0 {
            return "All done!"
        } else {
            return "\(count) Remaining"
        }
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let navController = storyboard!.instantiateViewController(withIdentifier: "ListDetailTableViewNavController") as! UINavigationController
        let destination = navController.topViewController as! ListDetailTableViewController
        destination.delegate = self
        let checklist = dataModel.lists[indexPath.row]
        destination.checklistToEdding = checklist
        
        present(navController, animated: true, completion: nil)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataModel.lists.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        let cell = makeCell(for: tableView)
        let checkList = dataModel.lists[indexPath.row]
        cell.textLabel?.text = checkList.name
        cell.detailTextLabel?.text = countingMassage(of: checkList)
        cell.accessoryType = .detailDisclosureButton
        cell.imageView?.image = UIImage(named: checkList.iconName)
        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dataModel.indexOfSelectedChecklist = indexPath.row
        let checkList = dataModel.lists[indexPath.row]
        performSegue(withIdentifier: "ShowChecklist", sender: checkList)
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            dataModel.lists.remove(at: indexPath.row)
            let indexPaths = [indexPath]
            tableView.deleteRows(at: indexPaths, with: .automatic)
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

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
    
    //ListDetailTableViewController Delegate
    
    func listDetailViewControllerDidCancel(_ controller: ListDetailTableViewController) {
        dismiss(animated: true, completion: nil)
        
    }
    func listDetailViewController(_ controller: ListDetailTableViewController, didFinishEditing checklist: CheckList) {
        dataModel.sortChecklists()
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
        
    }
    func listDetailViewController(_ controller: ListDetailTableViewController, didFinishAdding checklist: CheckList) {
        dataModel.lists.append(checklist)
        dataModel.sortChecklists()
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
        
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController === self {
            dataModel.indexOfSelectedChecklist = -1
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowChecklist" {
            let destinationController = segue.destination as! CheckListViewController
            destinationController.checklist = sender as! CheckList
        } else if segue.identifier == "AddChecklist" {
            let navController = segue.destination as! UINavigationController
            let destination = navController.topViewController as! ListDetailTableViewController
            destination.delegate = self
            destination.checklistToEdding = nil
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
