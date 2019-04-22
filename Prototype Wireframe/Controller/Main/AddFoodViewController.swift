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
        setUpDB()
//        loadDatabase()
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
        
        if food.acceptedUnits.isEmpty {
            let foodUnits = realm.objects(UnitOfMeasure.self).filter("foodId = %@", food.id)
            for unit in foodUnits {
                do {
                    try realm.write {
                        food.acceptedUnits.append(unit)
                    }
                } catch {
                    print("Error saving new items, \(error)")
                }
            }
            cell.calorieLabel.text = "\(roundToTens(x: ((food.caloriesPerBaseUnit) * (food.acceptedUnits.first?.conversionToBaseUnit)! * (food.defaultServing))))"
            cell.servingSizeLabel.text = "\(food.defaultServing) \(food.defaultUnit)"
        } else {
            cell.calorieLabel.text = "\(roundToTens(x: ((food.caloriesPerBaseUnit) * (food.acceptedUnits.first?.conversionToBaseUnit)! * (food.defaultServing))))"
            cell.servingSizeLabel.text = "\(food.defaultServing) \(food.defaultUnit)"
            
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
    
    // MARK: - Tempporary Food Database Loading
    func setUpDB() {
        
        if realm.objects(DBFood.self).first != nil {
            loadDatabase()
        } else {
            let initialDB = InitialDBSetUp()
            for food in initialDB.foodList {
                let dBFood = DBFood()
                dBFood.id = food.id
                dBFood.name = food.name
                dBFood.brand = food.brand
                dBFood.cooked = food.cooked
                dBFood.defaultServing = food.defaultServing
                dBFood.defaultUnit = food.defaultUnit
                dBFood.caloriesPerBaseUnit = food.caloriesPerBaseUnit
                dBFood.fatsPerBaseUnit = food.fatsPerBaseUnit
                dBFood.carbsPerBaseUnit = food.carbsPerBaseUnit
                dBFood.proteinPerBaseUnit = food.proteinPerBaseUnit
                dBFood.alcoholPerBaseUnit = food.alcoholPerBaseUnit
                dBFood.breakfast = food.breakfast
                dBFood.lunch = food.lunch
                dBFood.dinner = food.dinner
                dBFood.snack = food.snack
                dBFood.main = food.main
                dBFood.side = food.side
                dBFood.cuisine = food.cuisine
                for unit in food.acceptedUnits {
                    let dBMeasurement = UnitOfMeasure()
                    dBMeasurement.foodId = unit.foodId
                    dBMeasurement.conversionToBaseUnit = unit.conversionToBaseUnit
                    dBMeasurement.unit = unit.unit
                    do {
                        try realm.write {
                            realm.add(dBMeasurement)
                        }
                    } catch {
                        print("Error creating new date, \(error)")
                    }
                }
                
                do {
                    try realm.write {
                        realm.add(dBFood)
                    }
                } catch {
                    print("Error creating new date, \(error)")
                }
            }
            
            loadDatabase()
        }
        
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
