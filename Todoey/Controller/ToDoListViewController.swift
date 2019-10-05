//
//  ViewController.swift
//  Todoey
//
//  Created by 张子轩 on 7/31/19.
//  Copyright © 2019 Zixuan Zhang. All rights reserved.
//

import UIKit
//import CoreData
import RealmSwift

class ToDoListViewController: SwipeTableViewController {
    
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var todoItems: Results<Item>?
    let realm = try! Realm()
    
    
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
//    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
//        if let items = defaults.array(forKey: "ToDoListArray") as? [String] {
//            itemArray = items
////        }
//        let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
        
//        loadItems()
    }
    
    //MARK: - Table View Data Source Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = todoItems?[indexPath.row].title ?? "No item"
        cell.accessoryType = (todoItems?[indexPath.row].isComplete ?? false) ? .checkmark : .none
        return cell
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let itemToDelete = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(itemToDelete)
                }
            } catch {
                print(error)
            }
        }
    }
    
    
    //MARK: - Table View Dalegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.isComplete = !item.isComplete
                }
            } catch {
                print(error)
            }
            
            
        }
        
//        let cell = tableView.cellForRow(at: indexPath)

//        itemArray[indexPath.row].isComplete = !itemArray[indexPath.row].isComplete
//        itemArray[indexPath.row].setValue("Completed", forKey: "title")
        
//        context.delete(itemArray[indexPath.row])
//        todoItems?.remove(at: indexPath.row)

//        cell?.accessoryType = curItem.isComplete ? .checkmark : .none
        tableView.deselectRow(at: indexPath, animated: true)
        
        tableView.reloadData()
    }
    
    //MARK: - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new todoey item", message: "Message", preferredStyle: .alert)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Creat new item"
            textField = alertTextField
        }
        
        alert.addAction(UIAlertAction(title: "Add Item", style: .default, handler: { action in
            
//
//            let newItem = Item(context: self.context)
//            newItem.title = textField.text!
//            newItem.isComplete = false
//            newItem.parentCategory = self.selectedCategory
//
////            self.defaults.set(self.itemArray, forKey: "ToDoListArray")
//
//            self.itemArray.append(newItem) // Arrays are value types
            
            if let currentCategory = self.selectedCategory {
                
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print(error)
                }
                
                self.tableView.reloadData()
                
            }
            
            
            
            
//            self.tableView.reloadData()
        }))
        
//
//        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action in
//
//        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Model Manipulation Methods
    
//    func saveItems(item: Item) {
////        do {
////            try context.save()
////        } catch {
////            print("Error saving context \(error)")
////        }
//
//        do {
//            try realm.write {
//                realm.add(item)
//            }
//        } catch {
//            print(error)
//        }
//
//
//
//        tableView.reloadData()
//    }
    
    func loadItems() {//with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        //Core Data
////        let request: NSFetchRequest<Item> = Item.fetchRequest()
//        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
//
//        if let additionalPredicate = predicate {
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
//        } else {
//            request.predicate = categoryPredicate
//        }
//
//        do {
//             itemArray = try context.fetch(request)
//        } catch {
//            print("Error fetching data from context: \(error)")
//        }
        
        //Realm
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    
}


//MARK: - Search Bar Delegate Methods
extension ToDoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // Realm
        todoItems = todoItems?.filter("title CONTAINStfg[cd] %@ ", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
        
        // Core Data
//        let request: NSFetchRequest<Item> = Item.fetchRequest()
//
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        loadItems(with: request, predicate: predicate)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        }
    }
}

