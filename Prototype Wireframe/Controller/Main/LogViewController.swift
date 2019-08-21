//
//  LogViewController.swift
//  Prototype Wireframe
//
//  Created by MAC on 12/4/18.
//  Copyright © 2018 Jaime Lai. All rights reserved.
//

import UIKit
import SwipeCellKit
import Alamofire
import SwiftyJSON

class LogViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: Variables & Constants
    let userDataURL = API_HOST + "/my-dailydata"
    let foodLogURL = API_HOST + "/my-foodlog"
    let foodDBURL = API_HOST + "/foods"
    var modifiedDate = ""
    var mappedFood: DBFoodAPIModel?
    @IBOutlet var foodTableView: UITableView!
    
    // Full list of a user's foods for the respective date, sorted via the sort function.
    var userFoods = [UserFoodAPIModel]() {
        didSet {
            sortData()
            updateLabels()
            foodTableView.reloadData()
        }
    }
    
    
    /* Food Setup */
    var data = [Meals: [UserFoodAPIModel]]()
    enum Meals: Int {
        case breakfast = 0, lunch, dinner, snacks
    }
    
    /* Date Setup */
    // Keeps track of how many days ahead or behind of today's date that the user is on
    var dateOffset: Int = 0
    
    // Used for networking calls
    let baseDateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        return df
    }()
    
    
    // Used for the date in the Nav Bar. Format: Jul 25, 2019
    let dateFormatterUser: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "MMM dd, yyyy"
        return df
    }()

    
    //MARK: Class Properties
    let sectionHeaderHeight: CGFloat = 35
    
    
    //MARK: View Loading & Appearing
    override func viewDidLoad() {
        super.viewDidLoad()
        
        foodTableView.delegate = self
        foodTableView.dataSource = self

        foodTableView.rowHeight = 85
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadUserData()
        foodTableView.reloadData()
        
    }
    
    
    //MARK: TableViewController Methods
    
    // Sets the number of sections in table equal to the declared enumeration.
    func numberOfSections(in tableView: UITableView) -> Int {
        return Meals.snacks.rawValue + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tableSection = Meals(rawValue: section), let mealData = data[tableSection] {
            return mealData.count
            
        }
        return 1
    }
    
    // Sets the section header height equal to the property declared within Class Properties
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
        
        // Calculate calories in header
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
        
        /*Header Label Outlines - Testing Purposes*/
        //        nameLabel.layer.borderWidth = 1.0
        //        nameLabel.layer.borderColor = UIColor.black.cgColor
        //        addButton.layer.borderWidth = 1.0
        //        addButton.layer.borderColor = UIColor.black.cgColor
        
        view.addSubview(nameLabel)
        view.addSubview(addButton)
        
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = foodTableView.dequeueReusableCell(withIdentifier: "FoodCell", for: indexPath) as! SwipeTableViewCell
        
        if let section = Meals(rawValue: indexPath.section), let food = data[section]?[indexPath.row] {
            cell.textLabel?.text = "\(food.name)"
            cell.detailTextLabel?.text = "\(roundToTens(x: food.calories))"
        }
        
        cell.delegate = self
        return cell
    }
    
    
    //MARK: Data Loading Functions
    
    func loadUserData() {
        
        let currentDate = Date()
        modifiedDate = baseDateFormatter.string(from: Calendar.current.date(byAdding: .day, value: dateOffset, to: currentDate)!)
        print("\(modifiedDate)")
        let params: [String: Any] = ["user": User.current.username, "date": modifiedDate]
        userFoods.removeAll()
        
        Alamofire.request(foodLogURL, method: .get, parameters: params).responseJSON {
            response in
            if response.result.isSuccess {
                let data: JSON  = JSON(response.result.value!)
                print("\(data)")
                for (_, obj) in data {
                    let pk = obj["id"].intValue
                    let id = obj["food_id"].intValue
                    let name = obj["name"].stringValue
                    let brand = obj["brand"].stringValue
                    let variant = obj["variant"].stringValue
                    let cooked = obj["cooked"].stringValue
                    let servingSize = obj["serving_size"].doubleValue
                    let unit = obj["unit"].stringValue
                    let calories = obj["calories"].doubleValue
                    let fats = obj["fats"].doubleValue
                    let carbs = obj["carbs"].doubleValue
                    let protein = obj["protein"].doubleValue
                    let alcohol = obj["alcohol"].doubleValue
                    let timing = obj["timing"].stringValue
                    let newFood = UserFoodAPIModel(pkSetup: pk, idSetUp: id, nameSetUp: name, brandSetUp: brand, variantSetUp: variant, cookedSetUp: cooked, servingSizeSetUp: servingSize, unitSetUp: unit, caloriesSetUp: calories, fatsSetUp: fats, carbsSetUp: carbs, proteinSetUp: protein, alcoholSetUp: alcohol, timingSetUp: timing)
                    print("\(newFood.name)")
                    self.userFoods.append(newFood)
                }
                print("\(self.userFoods) #2")
            } else {
                print("Error")
            }
        }
        sortData()
        updateLabels()
        
    }
    
    // Splits a user's food by meals for use with the TableView methods
    func sortData() {
        data[.breakfast] = userFoods.filter { $0.timing == "breakfast" }
        data[.lunch] = userFoods.filter {$0.timing == "lunch"}
        data[.dinner] = userFoods.filter{$0.timing == "dinner"}
        data[.snacks] = userFoods.filter{$0.timing == "snacks"}
    }
    
    //MARK: Segue Methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showFood"?:
            if let section = Meals(rawValue: (foodTableView.indexPathForSelectedRow?.section)!), let foodToBeEditted = data[section]?[(foodTableView.indexPathForSelectedRow?.row)!] {
                let detailVC = segue.destination as! DetailViewController
                detailVC.foodToEdit = foodToBeEditted
                detailVC.mappedDBFood = mappedFood
                detailVC.navigationItem.title = "Edit Food"
            }
        case "addFood"?:
            let destinationNavigationC = segue.destination as! UINavigationController
            let targetController = destinationNavigationC.topViewController as! AddFoodViewController
            targetController.selectedMeal = (sender as! UIButton).tag
            targetController.logDate = modifiedDate
        default:
            preconditionFailure("Unexpected segue identifier")
        }
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
    }
    
    @objc func addNewFood(_ sender: UIButton) {
        performSegue(withIdentifier: "addFood", sender: sender)
    }
    

    //MARK: - User Navigation Functions
    
    // Loads the next day's data.
    @IBAction func nextDayPressed(_ sender: UIBarButtonItem) {
        dateOffset = dateOffset + 1
        loadUserData()
        foodTableView.reloadData()
    }
    
    // Loads the previous day's data.
    @IBAction func previousDayPressed(_ sender: UIBarButtonItem) {
        dateOffset = dateOffset - 1
        loadUserData()
        foodTableView.reloadData()
    }
    
    
    //MARK: - User Facing Functions
    
    // Rounds calculations to the nearest 10. -- DONE
    private func roundToTens(x: Double) -> Int {
        return 10 * Int(round(x / 10.0))
    }
    
    // Refreshes all labels are change. *Incomplete - missing summary labels (Calories Remaining, etc.)*
    func updateLabels() {
        setNavTitle()
        // function for updating summary labels
    }
    
    // Changes the title
    func setNavTitle() {
        if dateOffset == 0 {
            navigationItem.title = "Today"
        } else {
            let currentDate = Date()
            navigationItem.title = dateFormatterUser.string(from: Calendar.current.date(byAdding: .day, value: dateOffset, to: currentDate)!)
        }
    }
    
}

/***************************************************************/
// Extension Functionality
/***************************************************************/

//MARK: - SwipeCell Class

extension LogViewController: SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            print("delete started!")
            // Old Realm Method
//            if let section = Meals(rawValue: indexPath.section), let foodForDeletion = self.data[section]?[indexPath.row] {
//
//                do {
//                    try self.realm.write {
//                        self.realm.delete(foodForDeletion)
//                    }
//                } catch {
//                    print("Error deleting: \(error)")
//                }
//
//                self.loadUserData()
//            }
//            New Delete method
//            if let section = Meals(rawValue: (self.foodTableView.indexPathForSelectedRow?.section)!), let foodToBeDeleted = self.data[section]?[(self.foodTableView.indexPathForSelectedRow?.row)!] {
//
            if let section = Meals(rawValue: indexPath.section), let foodToBeDeleted = self.data[section]?[indexPath.row] {
                
                let params: [String: Any] = ["id": foodToBeDeleted.pk]
                let url = self.foodLogURL + "/\(foodToBeDeleted.pk)/"
                self.data[section]?.remove(at: indexPath.row)
                
                Alamofire.request(url, method: .delete, parameters: params).responseJSON {
                    response in
                    if response.result.isSuccess {
                        print("delete complete!")
                    } else {
                        print("Error")
                    }
//                    self.loadUserData()
                }

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
