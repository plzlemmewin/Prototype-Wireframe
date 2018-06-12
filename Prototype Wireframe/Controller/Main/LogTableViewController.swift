//
//  LogTableViewController.swift
//  Prototype Wireframe
//
//  Created by MAC on 4/22/18.
//  Copyright © 2018 Jaime Lai. All rights reserved.
//

import UIKit

class LogTableViewController: UITableViewController {
    
    //MARK: Class Properties
    var foodDatabase = FoodDatabase()
    
    
    enum Meals: Int {
        case breakfast = 0, lunch, dinner, snacks
    }
    
    let sectionHeaderHeight: CGFloat = 35
    
    var data = [Meals: [Food]]()
    
    func sortData() {
        data[.breakfast] = foodDatabase.foodList.filter { $0.timing == "breakfast" }
        data[.lunch] = foodDatabase.foodList.filter{$0.timing == "lunch"}
        data[.dinner] = foodDatabase.foodList.filter{$0.timing == "dinner"}
        data[.snacks] = foodDatabase.foodList.filter{$0.timing == "snacks"}
    }
    
    //MARK: Loading Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        tableView.rowHeight = UITableViewAutomaticDimension
//        tableView.estimatedRowHeight = 65
        tableView.rowHeight = 55
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = "Today"
        
        
        sortData()
        tableView.reloadData()
    }
    
    
    // MARK: TableViewController Methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return Meals.snacks.rawValue + 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
 //       return foodDatabase.foodList.count
        if let tableSection = Meals(rawValue: section), let mealData = data[tableSection] {
            return mealData.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionHeaderHeight
    }
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: sectionHeaderHeight))
        view.backgroundColor = UIColor(red: 118/255, green: 214/255, blue: 255/255, alpha: 1)
        let nameLabel = UILabel(frame: CGRect(x: 15, y: 0, width: 160, height: sectionHeaderHeight))
        
        let button = UIButton(frame: CGRect(x: tableView.bounds.width - 65, y: 0, width: 55, height: sectionHeaderHeight))
        
        
        let totalCalories = 0
        if let section = Meals(rawValue: section) {
            switch section {
            case .breakfast:
                nameLabel.text = "Breakfast:  \(totalCalories)"
            case .lunch:
                nameLabel.text = "Lunch: \(totalCalories)"
            case .dinner:
                nameLabel.text = "Dinner: \(totalCalories)"
            case .snacks:
                nameLabel.text = "Snacks: \(totalCalories)"
            default:
                nameLabel.text = ""
            }
        }
        
//        let calorieLabel = UILabel(frame: CGRect(x: tableView.bounds.width - 45, y: 0, width: 45, height: sectionHeaderHeight))
//        calorieLabel.text = "\(300)"
        
        /*NEED TO REVIST AND ADJUST HEADER LABEL AND CALORIE LABEL TO BE DYNAMIC*/
//        nameLabel.layer.borderWidth = 1.0
//        nameLabel.layer.borderColor = UIColor.black.cgColor
//        calorieLabel.layer.borderWidth = 1.0
//        calorieLabel.layer.borderColor = UIColor.black.cgColor
        
        view.addSubview(nameLabel)
        
//        view.addSubview(calorieLabel)
        return view
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoodCell", for: indexPath) as! UserFoodCell
        
        if let section = Meals(rawValue: indexPath.section), let food = data[section]?[indexPath.row] {
            cell.idLabel.text = food.identifier
            cell.calorieLabel.text = "\(food.calories)"
            cell.detailLabel.text = food.servingSize
        }
        
//        let food = foodDatabase.foodList[indexPath.row]
//        cell.idLabel.text = food.identifier
//        cell.calorieLabel.text = "\(food.calories)"
//        cell.servingSizeLabel.text = food.servingSize
        
        return cell
    }
    
    // MARK: Segue Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showFood"?:
            if let row = tableView.indexPathForSelectedRow?.row {
                let food = foodDatabase.foodList[row]
                let detailVC = segue.destination as! DetailViewController
                detailVC.food = food
            }
        case "addFood"?:
            print("Adding New Food")
        default:
            preconditionFailure("Unexpected segue identifier")
        }
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "showFood" {
//            if let row = tableView.indexPathForSelectedRow?.row {
//                let food = foodDatabase.foodList[row]
//                let detailVC = segue.destination as! DetailViewController
//                detailVC.food = food
//                let backItem = UIBarButtonItem()
//                backItem.title = "Back"
//                navigationItem.backBarButtonItem = backItem
//            }
//        }
//    }
    
//    @IBAction func addNewFood(_ sender: UIBarButtonItem) {
//        performSegue(withIdentifier: "addFood", sender: self)
//    }
}
