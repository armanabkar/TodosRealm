//
//  CategoryViewController.swift
//  TodosRealm
//
//  Created by Arman Abkar on 5/15/21.
//

import UIKit
import RealmSwift

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        
        tableView.separatorStyle = .none
        view.backgroundColor = UIColor(hex: "#1D9BF6")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        guard let navBar = navigationController?.navigationBar else { fatalError("Navigation controller does not exist.")
        }
        navBar.backgroundColor = UIColor(hex: "#1D9BF6")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories added yet"
        
        if let category = categories?[indexPath.row] {
            DispatchQueue.main.async {
                let categoryColour = UIColor(hex: category.colour)
                cell.backgroundColor = categoryColour
                cell.textLabel?.textColor = categoryColour.inverseColor()
                cell.textLabel?.font = UIFont.systemFont(ofSize: 22.0, weight: UIFont.Weight(rawValue: 0.5))
            }
        }
        return cell
    }
    
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category \(error)")
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func loadCategories() {
        categories = realm.objects(Category.self)
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("Error deleting category, \(error)")
            }
        }
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        DispatchQueue.main.async {
            var textField = UITextField()
            let alert = UIAlertController(title: "Add a New Cateogry", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "Add", style: .default) { (action) in
                if textField.text != "" {
                    let newCategory = Category()
                    newCategory.name = textField.text!
                    newCategory.colour = UIColor.random().toHexString()
                    self.save(category: newCategory)
                }
            }
            
            alert.addAction(action)
            alert.addTextField { (field) in
                textField = field
                textField.placeholder = "Add a new category"
            }
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
}
