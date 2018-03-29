//
//  ViewController.swift
//  coreDataCacao1987
//
//  Created by Rudi Krämer on 29.03.18.
//  Copyright © 2018 Rudi Krämer. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var people = [Person]()

    override func viewDidLoad() {
        super.viewDidLoad()

//      get data from coredata
        let fetchRequest: NSFetchRequest<Person> = Person.fetchRequest()
        
        do {
            let fetchedPeople = try persistenceService.context.fetch(fetchRequest)
            self.people = fetchedPeople
            self.tableView.reloadData()
        } catch {}
        
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
        
        let action = UIAlertAction(title: "POST", style: .default) { (_) in
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
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
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
    
}
