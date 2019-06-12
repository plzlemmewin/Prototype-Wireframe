//
//  AddFoodViewController.swift
//  Prototype Wireframe
//
//  Created by MAC on 6/4/18.
//  Copyright © 2018 Jaime Lai. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class AddFoodViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: Variables & Constants
    let foodDBURL = API_HOST + "/foods"
    
    var transferredDBSnapshot = [DBFoodAPIModel]()
    var foodDatabase = [DBFoodAPIModel]() {
        didSet {
            foodTableView.reloadData()
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var foodTableView: UITableView!
    
    // Data passed over from addFood segue
    var selectedMeal: Int?
    var logDate: String?
    

    //MARK: View Loading & Appearing
    override func viewDidLoad() {
        super.viewDidLoad()
        
        foodTableView.delegate = self
        foodTableView.dataSource = self
        
        foodTableView.rowHeight = 55
        
        loadDatabase()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    //MARK: - TableView Datasource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.foodDatabase.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddFoodCell", for: indexPath) as! DBFoodCell
        let food = foodDatabase[indexPath.row]
        
        cell.idLabel.text = food.name
        if let brand = food.brand, brand != "" {
            cell.brandLabel.text = brand
        } else {
            cell.brandLabel.text = ""
        }
        if let variant = food.variant, variant != "" {
            cell.variantLabel.text = ", \(variant)"
        } else {
            cell.variantLabel.text = ""
        }
        if let cooked = food.cooked, cooked != "" {
            cell.cookedLabel.text = ", \(cooked), "
        } else {
            cell.cookedLabel.text = ""
        }
        
        cell.calorieLabel.text = "\(roundToTens(x: ((food.caloriesPerBaseUnit) * (food.units.first?.conversionToBaseUnit)! * (food.defaultServing))))"
        cell.servingSizeLabel.text = "\(food.defaultServing) \(food.defaultUnit)"
        
        return cell
        
    }
    
    //MARK: - TableView Delegate Methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "FoodDetail", sender: self)
    }
    
    //MARK: - Load Data
    
    //Load Database
    func loadDatabase() {
        
        Alamofire.request(foodDBURL, method: .get).responseJSON {
            response in
            if response.result.isSuccess {
                let data: JSON  = JSON(response.result.value!)
                for (_, obj) in data {
                    let id = obj["food_id"].intValue
                    let name = obj["name"].stringValue
                    let brand = obj["brand"].stringValue
                    let variant = obj["variant"].stringValue
                    let cooked = obj["cooked"].stringValue
                    let defaultServing = obj["default_serving"].doubleValue
                    let defaultUnit = obj["default_unit"].stringValue
                    let caloriesPerBaseUnit = obj["calories_per_base_unit"].doubleValue
                    let fatsPerBaseUnit = obj["fats_per_base_unit"].doubleValue
                    let carbsPerBaseUnit = obj["carbs_per_base_unit"].doubleValue
                    let proteinPerBaseUnit = obj["protein_per_base_unit"].doubleValue
                    let alcoholPerBaseUnit = obj["alcohol_per_base_unit"].doubleValue
                    var units = [Unit]()
                    for (_, unit) in obj["units"] {
                        let name = unit["unit"].stringValue
                        let conversion = unit["conversion_to_base_unit"].doubleValue
                        let newUnit = Unit(unitName: name, baseUnits: conversion)
                        units.append(newUnit)
                    }
                    let newFood = DBFoodAPIModel(idSetUp: id, nameSetUp: name, brandSetUp: brand, variantSetUp: variant, cookedSetUp: cooked, defaultServingSetUp: defaultServing, defaultUnitSetUp: defaultUnit, caloriesPerBaseUnitSetUp: caloriesPerBaseUnit, fatsPerBaseUnitSetUp: fatsPerBaseUnit, carbsPerBaseUnitSetUp: carbsPerBaseUnit, proteinPerBaseUnitSetUp: proteinPerBaseUnit, alcoholPerBaseUnitSetUp: alcoholPerBaseUnit, supportedUnits: units)
                    newFood.units.reverse()
                    self.foodDatabase.append(newFood)
                }
                self.transferredDBSnapshot = self.foodDatabase
            } else {
                print("Error")
            }
        }
    }
    
    //MARK: Navigation Methods

    // Segue to DetailViewController
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
    
    // Return to user's log
    @IBAction func cancelPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - User Facing Functions
    
    // Rounds calculations to the nearest 10. -- DONE
    private func roundToTens(x: Double) -> Int {
        return 10 * Int(round(x / 10.0))
    }
    
    
}

/***************************************************************/
// Extension Functionality
/***************************************************************/

//MARK: - Search Bar

extension AddFoodViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        foodDatabase = foodDatabase.filter{ $0.name.range(of: searchBar.text!, options: [.caseInsensitive, .diacriticInsensitive]) != nil}
        foodTableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            foodDatabase = transferredDBSnapshot
        } else {
        foodDatabase = transferredDBSnapshot
        foodDatabase = foodDatabase.filter{ $0.name.range(of: searchBar.text!, options: [.caseInsensitive, .diacriticInsensitive]) != nil}
            foodTableView.reloadData()
        }

    }
}
