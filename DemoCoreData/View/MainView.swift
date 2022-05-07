//
//  MainView.swift
//  DemoCoreData
//
//  Created by Vladislav Miroshnichenko on 17.07.2021.
//

import UIKit
import CoreData

class MainView: UITableViewController {

    private var controller = MainController(appDelegate: UIApplication.shared.delegate as! AppDelegate)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        controller.preloadTasks()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return controller.getTasks().count
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        showAlert()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        cell.textLabel?.text = controller.getTask(at: indexPath.row).title

        return cell
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editButton = editAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [editButton])
    }
    
    private func editAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "Edit") { (action, view, completion) in
            self.showEditAlert(at: indexPath)
            completion(true)
        }
        action.backgroundColor = .gray
        action.image = UIImage(systemName: "square.and.pencil")
        return action
    }
    
    private func showAlert() {
        let alertController = UIAlertController(title: "Add task", message: "Please, add a new taks.", preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Save", style: .default) { action in
            let textField = alertController.textFields?.first
            
            if let newTask = textField?.text {
                self.controller.saveTask(title: newTask)
                self.tableView.reloadData()
            }
        }
        
        alertController.addTextField {_ in }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(cancelAction)
        alertController.addAction(addAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func showEditAlert(at indexPath: IndexPath) {
        let alertController = UIAlertController(title: "Edit task", message: "Please, change the taks.", preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.text = self.controller.getTask(at: indexPath.row).title
        }
        
        let changeAction = UIAlertAction(title: "Change", style: .default) { action in
            let textField = alertController.textFields?.first
            
            if let newTask = textField?.text {
                self.controller.editTask(title: newTask, at: indexPath.row)
                self.tableView.reloadData()
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(cancelAction)
        alertController.addAction(changeAction)
        
        present(alertController, animated: true, completion: nil)
    }


    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    


    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            controller.deleteTask(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
