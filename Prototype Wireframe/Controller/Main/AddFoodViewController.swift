//
//  AddFoodViewController.swift
//  Prototype Wireframe
//
//  Created by MAC on 6/4/18.
//  Copyright © 2018 Jaime Lai. All rights reserved.
//

import UIKit

class AddFoodViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet var foodTableView: UITableView!
    
    var foodDatabase = FoodDatabase()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        foodTableView.delegate = self
        foodTableView.dataSource = self
        
        foodTableView.rowHeight = 55

    }
    
    // MARK: - TableView Datasource Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodDatabase.foodList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddFoodCell", for: indexPath) as! DBFoodCell

        let food = foodDatabase.foodList[indexPath.row]

        cell.idLabel.text = food.identifier
        if let brand = food.brand {
            cell.brandLabel.text = brand
        } else {
            cell.brandLabel.text = ""
        }
        if let variant = food.variant {
            cell.variantLabel.text = ", \(variant)"
        } else {
            cell.variantLabel.text = ""
        }
        if let cooked = food.cooked {
            cell.cookedLabel.text = "\(cooked), "
        } else {
            cell.cookedLabel.text = ""
        }
        cell.calorieLabel.text = "\(food.calories)"
        if let servingSize = food.servingSize {
            cell.servingSizeLabel.text = servingSize
        } else {
            cell.servingSizeLabel.text = ""
        }

        return cell
    }
    
    // MARK: - TableView Delegate Methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "FoodDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "FoodDetail"?:
            if let row = foodTableView.indexPathForSelectedRow?.row {
                let food = foodDatabase.foodList[row]
                let detailVC = segue.destination as! DetailViewController
                detailVC.food = food
            }
        default:
            preconditionFailure("Unexpected segue identifier")
        }
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
    }
    
    // MARK: - Navigation Methods
    
    @IBAction func cancelPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        switch segue.identifier {
//        case "addFoodDetail"?:
//            if let row = foodTableView.indexPathForSelectedRow?.row {
//                let food = foodDatabase.foodList
//                let detailVC = segue.destination as! DetailViewController
//                detailVC.food = food
//            }
//        default:
//            preconditionFailure("Unexpected segue identifier")
//        }
//        let backItem = UIBarButtonItem()
//        backItem.title = "Back"
//        navigationItem.backBarButtonItem = backItem
//        navigationItem.title = "Add Food"
//    }
}

extension AddFoodViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
//        let request: NSFetchRequest<Item> = Item.fetchRequest()
//
//        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        loadItems(with: request)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchBar.text?.count == 0 {
//            loadItems()
//
//            DispatchQueue.main.async {
//                searchBar.resignFirstResponder()
//            }
//
        }
}
