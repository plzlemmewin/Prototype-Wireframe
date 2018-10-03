//
//  AddFoodViewController.swift
//  Prototype Wireframe
//
//  Created by MAC on 6/4/18.
//  Copyright © 2018 Jaime Lai. All rights reserved.
//

import UIKit
import RealmSwift

class AddFoodViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let realm = try! Realm()
    
    //    var foodDatabase = FoodDatabase()
    var foodDatabase: Results<DBFood>!

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var foodTableView: UITableView!
    

    var selectedMeal: Int?
    var logDate: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        foodTableView.delegate = self
        foodTableView.dataSource = self
        
        foodTableView.rowHeight = 55
        
        print("\(String(describing: selectedMeal))")
        loadDatabase()
    }
    
    // MARK: - TableView Datasource Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodDatabase.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddFoodCell", for: indexPath) as! DBFoodCell

        let food = foodDatabase[indexPath.row]

        cell.idLabel.text = food.name
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
        cell.calorieLabel.text = "\(roundToTens(x: ((food.caloriesPerBaseUnit) * (food.acceptedUnits.first?.conversionToBaseUnit)! * (food.defaultServing))))"
        cell.servingSizeLabel.text = "\(food.defaultServing) \(food.defaultUnit)"

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
                let food = foodDatabase[row]

                let detailVC = segue.destination as! DetailViewController
                detailVC.foodToAdd = food
                detailVC.navigationItem.title = "Add Food"
                detailVC.logDate = self.logDate
                switch selectedMeal! {
                case 0:
                    detailVC.timing = "breakfast"
                case 1:
                    detailVC.timing = "lunch"
                case 2:
                    detailVC.timing = "dinner"
                case 3:
                    detailVC.timing = "snacks"
                default:
                    detailVC.timing = ""
                }
                
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
    
    func loadDatabase() {
        
        foodDatabase = realm.objects(DBFood.self)
        foodTableView.reloadData()
        
    }
    
    private func roundToTens(x: Double) -> Int {
        return 10 * Int(round(x / 10.0))
    }
    
    
}

extension AddFoodViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        foodDatabase = foodDatabase!.filter("name CONTAINS[cd] %@", searchBar.text!)// .sorted(byKeyPath: "name", ascending: true)
        
        foodTableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadDatabase()
            
//            DispatchQueue.main.async {
//                searchBar.resignFirstResponder()
//            }
// This is A QUICK FIX. THIS WHOLE SECTION IS NOT THE RIGHT WAY TO ADDRESS THIS ISSUE.
        } else {
            loadDatabase()
            foodDatabase = foodDatabase!.filter("name CONTAINS[cd] %@", searchBar.text!)// .sorted(byKeyPath: "name", ascending: true)
            
            foodTableView.reloadData()
            
        }
        
    }
}
