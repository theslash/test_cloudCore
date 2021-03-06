//
//  ViewController.swift
//  coreDataCacao1987
//
//  Created by Rudi Krämer on 29.03.18.
//  Copyright © 2018 Rudi Krämer. All rights reserved.
//

import UIKit
import CoreData
import CloudCore

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var people = [Person]()

    override func viewDidLoad() {
        super.viewDidLoad()
                
        tableView.delegate = self
        tableView.dataSource = self
    
        
        getCoreData()
        
    }

    @IBAction func onPlusTabbed() {
        let alert = UIAlertController(title: "Add Person", message: nil, preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Name"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Age"
            textField.keyboardType = .numberPad
        }
        
        let action = UIAlertAction(title: "Save", style: .default) { (_) in
            let name = alert.textFields!.first!.text!
            let age = alert.textFields!.last!.text!
//            print(name, age)
            
//            fill container
            let person = Person(context: persistenceService.context)
            person.name = name
            person.age = Int16(age)!
           
//            save container
            persistenceService.saveContext()
            self.people.append(person)
            
            self.tableView.reloadData()
            
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action: UIAlertAction) in
        }
        
        alert.addAction(action)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func loadData(_ sender: Any) {
        
        fetchCloudData()
 
    }
    
    @IBAction func reloadTableView(_ sender: Any) {
        getCoreData()
    }
    
    func getCoreData() {
        print("getCoreData")
        //      get data from coredata
        let fetchRequest: NSFetchRequest<Person> = Person.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "recordID", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            self.people = try persistenceService.context.fetch(fetchRequest)
//            self.people = fetchedPeople
        } catch {}
        self.tableView.reloadData()

    }
    
    func fetchCloudData() {
        print("fetchAndSave and Reloading Tableview")
        CloudCore.fetchAndSave(to: persistenceService.persistentContainer, error: { (error) in
            print("FetchAndSave error: \(error)")
            DispatchQueue.main.async {
//                persistenceService.context.reset()
//                self.getCoreData()
            }
        }) {
            DispatchQueue.main.async {
                persistenceService.context.reset()
                self.getCoreData()
            }
        }
    }

}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell (style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = people[indexPath.row].name
        cell.detailTextLabel?.text = String(people[indexPath.row].age)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
       
        let itemToDelete = people[indexPath.row]

        print(itemToDelete)
        
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            // handle delete (by removing the data from your array and updating the tableview)

            persistenceService.context.delete(itemToDelete)
            self.people.remove(at: indexPath.row)
            
            do {
                try persistenceService.context.save()
            } catch let error as NSError {
                print("Error While Deleting: \(error.userInfo)")
            }
            
            
        }
        getCoreData()
        
    }
    
}

// MARK: - Table View Delegate
extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedItem = people[indexPath.row]
        print(selectedItem)
        
        let alert = UIAlertController(title: "Edit Person", message: nil, preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.text = selectedItem.name
        }
        alert.addTextField { (textField) in
            textField.text = String(selectedItem.age)
            textField.keyboardType = .numberPad
        }
        
        let action = UIAlertAction(title: "Update", style: .default) { (_) in
            
            let name = alert.textFields!.first!.text!
            let age = alert.textFields!.last!.text!
            
            
            selectedItem.setValue(name, forKey: "name")
            selectedItem.setValue(Int16(age), forKey: "age")
            
            do{
                try persistenceService.context.save()
            } catch {
                print("Error saving")
            }
            
            self.tableView.reloadData()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action: UIAlertAction) in
        }
        
        alert.addAction(action)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
        
    }
}
