//
//  LogViewController.swift
//  Prototype Wireframe
//
//  Created by MAC on 12/4/18.
//  Copyright © 2018 Jaime Lai. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

class LogViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let realm = try! Realm()
    var userFoods: List<Food>!
    var dateOffset: Int = 0
    
    let dateFormatterInitial: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .none
        return df
    }()
    
    let dateFormatterUser: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "MMM dd, yyyy"
        return df
    }()
    
    let dateFormatterSave: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "MM/dd/yyyy, HH:mm:ssZ"
//        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return df
    }()

    
    @IBOutlet var foodTableView: UITableView!
    
    //MARK: Class Properties
    let sectionHeaderHeight: CGFloat = 35
    
    enum Meals: Int {
        case breakfast = 0, lunch, dinner, snacks
    }
    
    var data = [Meals: [Food]]()
    
    func sortData() {
        data[.breakfast] = userFoods.filter { $0.timing == "breakfast" }
        data[.lunch] = userFoods.filter {$0.timing == "lunch"}
        data[.dinner] = userFoods.filter{$0.timing == "dinner"}
        data[.snacks] = userFoods.filter{$0.timing == "snacks"}
        print("\(data[.breakfast])")
    }
    
    //MARK: Loading Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        foodTableView.delegate = self
        foodTableView.dataSource = self
        
        loadUserData()
//        print("\(userFoods)")
        
        //        tableView.rowHeight = UITableViewAutomaticDimension
        //        tableView.estimatedRowHeight = 65
        foodTableView.rowHeight = 85
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadUserData()
//        updateLabels()
        foodTableView.reloadData()
        
    }
    
    
    // MARK: TableViewController Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Meals.snacks.rawValue + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //       return foodDatabase.foodList.count
        if let tableSection = Meals(rawValue: section), let mealData = data[tableSection] {
            return mealData.count
            
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: sectionHeaderHeight))
        view.backgroundColor = UIColor(red: 118/255, green: 214/255, blue: 255/255, alpha: 1)
        let nameLabel = UILabel(frame: CGRect(x: 15, y: 0, width: 160, height: sectionHeaderHeight))
        
        let addButton = UIButton(type: .contactAdd)
        
        // Configure button
        addButton.frame = CGRect(x: tableView.bounds.width - 45, y: 0, width: 35, height: sectionHeaderHeight)
        addButton.tintColor = UIColor.lightGray
        addButton.tag = section
        addButton.addTarget(self, action: #selector(self.addNewFood), for: .touchUpInside)
        
        var totalCalories: Double = 0
        if let tableSection = Meals(rawValue: section), let mealData = data[tableSection] {
            for value in mealData {
                totalCalories += value.calories
            }
        } else {
            totalCalories = 0
        }
        
        if let section = Meals(rawValue: section) {
            switch section {
            case .breakfast:
                nameLabel.text = "Breakfast:  \(roundToTens(x: totalCalories))"
            case .lunch:
                nameLabel.text = "Lunch: \(roundToTens(x: totalCalories))"
            case .dinner:
                nameLabel.text = "Dinner: \(roundToTens(x: totalCalories))"
            case .snacks:
                nameLabel.text = "Snacks: \(roundToTens(x: totalCalories))"
            }
        }
        
        /*NEED TO REVIST AND ADJUST HEADER LABEL AND CALORIE LABEL TO BE DYNAMIC*/
        //        nameLabel.layer.borderWidth = 1.0
        //        nameLabel.layer.borderColor = UIColor.black.cgColor
        //        addButton.layer.borderWidth = 1.0
        //        addButton.layer.borderColor = UIColor.black.cgColor
        
        view.addSubview(nameLabel)
        view.addSubview(addButton)
        
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "FoodCell", for: indexPath) as! UserFoodCell
//
//        if let section = Meals(rawValue: indexPath.section), let food = data[section]?[indexPath.row] {
//            cell.idLabel.text = food.name
//            cell.calorieLabel.text = "\(food.calories)"
//            cell.detailLabel.text = "\(food.servingSize) \(food.unit)"
//        } else {
//            cell.idLabel.text = "Add a Food"
//        }
        
        
        let cell = foodTableView.dequeueReusableCell(withIdentifier: "FoodCell", for: indexPath) as! SwipeTableViewCell
        
        if let section = Meals(rawValue: indexPath.section), let food = data[section]?[indexPath.row] {
        
            cell.textLabel?.text = "\(food.name)"
            cell.detailTextLabel?.text = "\(roundToTens(x: food.calories))"
        }
        
        cell.delegate = self
        return cell
    }
    
    // MARK: Segue Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showFood"?:
            if let section = Meals(rawValue: (foodTableView.indexPathForSelectedRow?.section)!), let foodToBeEditted = data[section]?[(foodTableView.indexPathForSelectedRow?.row)!] {
                let detailVC = segue.destination as! DetailViewController
                detailVC.food = foodToBeEditted
                detailVC.navigationItem.title = "Edit Food"
            }
        case "addFood"?:
            let currentDate = Date()
            let destinationNavigationC = segue.destination as! UINavigationController
            let targetController = destinationNavigationC.topViewController as! AddFoodViewController
            targetController.selectedMeal = (sender as! UIButton).tag
            targetController.logDate = dateFormatterUser.date(from: dateFormatterInitial.string(from: Calendar.current.date(byAdding: .day, value: dateOffset, to: currentDate)!))
        //            print("\(targetController.selectedMeal)")
        default:
            preconditionFailure("Unexpected segue identifier")
        }
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
    }
    
    @objc func addNewFood(_ sender: UIButton) {
        let section = sender.tag
        
        performSegue(withIdentifier: "addFood", sender: sender)
    }
    
    func loadUserData() {
        
        let currentDate = Date()
        let modifiedDate = Calendar.current.date(byAdding: .day, value: dateOffset, to: currentDate)!
        
        let formattedDate = dateFormatterInitial.string(from: Calendar.current.date(byAdding: .day, value: dateOffset, to: currentDate)!)
        
     
        let dbDate = dateFormatterUser.date(from: formattedDate)
        
        let predicate = NSPredicate(format: "date = %@", dbDate as! NSDate)
        
        if let existingData =
            realm.objects(UserData.self).first?.dailyData.filter(predicate).first?.data {
            
//            print("\(existingData)")
            userFoods = existingData
            
        } else {
            let newDate = DailyData()
            newDate.date = dbDate!
            newDate.dailyCaloricTarget = (realm.objects(UserData.self).first?.currentCaloricTarget)!
            do {
                try realm.write {
                    realm.objects(UserData.self).first?.dailyData.append(newDate)
                }
            } catch {
                print("Error creating new date, \(error)")
            }
            userFoods = realm.objects(UserData.self).first?.dailyData.filter(predicate).first?.data
        }
        
        sortData()
        updateLabels()
        
    }
    
    private func roundToTens(x: Double) -> Int {
        return 10 * Int(round(x / 10.0))
    }
    
    
    @IBAction func nextDayPressed(_ sender: UIBarButtonItem) {
        dateOffset = dateOffset + 1
        loadUserData()
        foodTableView.reloadData()
    }
    
    @IBAction func previousDayPressed(_ sender: UIBarButtonItem) {
        dateOffset = dateOffset - 1
        loadUserData()
        foodTableView.reloadData()
    }
    
    func updateLabels() {
        setNavTitle()
    }
    
    func setNavTitle() {
        if dateOffset == 0 {
            navigationItem.title = "Today"
        } else {
            let currentDate = Date()
            navigationItem.title = dateFormatterUser.string(from: Calendar.current.date(byAdding: .day, value: dateOffset, to: currentDate)!)
            print("\(navigationItem.title!)")
        }
    }
    
}

//MARK: - Swipe Cell Delegate Methods

extension LogViewController: SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            
            if let section = Meals(rawValue: indexPath.section), let foodForDeletion = self.data[section]?[indexPath.row] {

                print("deleted \(foodForDeletion) at \(indexPath)")
                do {
                    try self.realm.write {
                        self.realm.delete(foodForDeletion)
                    }
                } catch {
                    print("Error deleting: \(error)")
                }
                
                self.loadUserData()
                print("completed")
            }
        }
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
    
}
