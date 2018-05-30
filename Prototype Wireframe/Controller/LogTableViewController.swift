//
//  LogTableViewController.swift
//  Prototype Wireframe
//
//  Created by MAC on 4/22/18.
//  Copyright © 2018 Jaime Lai. All rights reserved.
//

import UIKit

class LogTableViewController: UITableViewController {
    
    var foodDatabase = FoodDatabase()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        tableView.rowHeight = UITableViewAutomaticDimension
//        tableView.estimatedRowHeight = 65
        tableView.rowHeight = 55
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodDatabase.foodList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoodCell", for: indexPath) as! FoodCell
        
        let food = foodDatabase.foodList[indexPath.row]
        cell.idLabel.text = food.identifier
        cell.calorieLabel.text = "\(food.calories)"
        cell.servingSizeLabel.text = food.servingSize
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showFood"?:
            if let row = tableView.indexPathForSelectedRow?.row {
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    @IBAction func addNewFood(_ sender: UIBarButtonItem) {
        let newFood = foodDatabase.createFood()
        if let index = foodDatabase.foodList.index(of: newFood) {
            let indexPath = IndexPath(row: index, section: 0)
            
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
}
