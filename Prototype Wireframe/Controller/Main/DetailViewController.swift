//
//  DetailViewController.swift
//  Prototype Wireframe
//
//  Created by MAC on 5/29/18.
//  Copyright © 2018 Jaime Lai. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class DetailViewController: UIViewController, UITextFieldDelegate , UIPickerViewDelegate, UIPickerViewDataSource {

    //MARK: Variables & Constants
    let foodDBURL = API_HOST + "/foods"
    let foodLogURL = API_HOST + "/my-foodlog/"

    /* Views */
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet var servingSizeField: UITextField!
    @IBOutlet var caloriesField: UITextField!
    @IBOutlet var miscLabel: UILabel!
    @IBOutlet var servingPicker: UIPickerView!
    
    /* Variables & Constants */
    // UIPicker Components
    var servingData: [[String]] = [[String]]() 
    
    var servingInUnits: Double = 0
    var unit: String = ""
    var totalCalories: Double = 0
    
    /* Identifying adding new food or editing existing food */
    var timing: String?
    var logDate: String?
    
    var foodToAdd: DBFoodAPIModel?
    var foodToEdit: UserFoodAPIModel?
    
    // Mapping from the 'Food' class to the 'DBFood' class
    var mappedDBFood: DBFoodAPIModel?
    
    var foodLoadedTracker = false {
        didSet {
            uiPickerSetup()
            setInitialUIPicker()
        }
    }

    
    //MARK: View Loading & Appearing
    override func viewDidLoad() {
        super.viewDidLoad()
        
        servingPicker.delegate = self
        servingPicker.dataSource = self
        
        // Setting up the uipicker
        uiPickerSetup()
        setInitialUIPicker()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        updateLabels()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        view.endEditing(true)
    }

    //MARK: - Saving Data
    func saveNewFood(food: UserFoodAPIModel) {
        
        let params: [String: Any] = ["user": User.current.username, "date": logDate!, "food_id": food.id, "name": food.name, "brand": food.brand,
                                     "variant": food.variant, "cooked": food.cooked, "serving_size": food.servingSize, "unit": food.unit, "calories": food.calories,
                                     "fats": food.fats, "carbs": food.carbs, "protein": food.protein, "alcohol": food.alcohol, "timing": food.timing]
        
        Alamofire.request(foodLogURL, method: .post, parameters: params).responseJSON {
            response in
            if response.result.isSuccess {
                let responseJSON: JSON  = JSON(response.result.value!)
                print("\(responseJSON)")

            } else {
                print("Error")
            }
        }
        
        print("all done!")
        dismiss(animated: true, completion: nil)
    }
    
//    func editExistingFood() {
//        _ = navigationController?.popViewController(animated: true)
//        print("process complete")
//    }
    
    
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        
        if let foodToBeAdded = foodToAdd, let unitConversion = foodToAdd?.units[servingPicker.selectedRow(inComponent: 2)].conversionToBaseUnit {
            let foodUnit = "\(foodToBeAdded.units[servingPicker.selectedRow(inComponent: 2)].unit)"
            let calories = foodToBeAdded.caloriesPerBaseUnit * servingInUnits * unitConversion
            let fats = foodToBeAdded.fatsPerBaseUnit * servingInUnits * unitConversion
            let carbs = foodToBeAdded.carbsPerBaseUnit * servingInUnits * unitConversion
            let protein = foodToBeAdded.proteinPerBaseUnit * servingInUnits * unitConversion
            let alcohol = foodToBeAdded.alcoholPerBaseUnit * servingInUnits * unitConversion
            let timing = self.timing!
            let newFood = UserFoodAPIModel(idSetUp: foodToBeAdded.id, nameSetUp: foodToBeAdded.name, servingSizeSetUp: servingInUnits, unitSetUp: foodUnit, caloriesSetUp: calories, fatsSetUp: fats, carbsSetUp: carbs, proteinSetUp: protein, alcoholSetUp: alcohol, timingSetUp: timing)
            saveNewFood(food: newFood)
        } else {
            print("In Progress")
            // Adding the Edit Functionality shortly
//            editExistingFood()
        }
    
//        Old Realm method
//        if let foodToBeAdded = foodToAdd, let unitConversion = foodToAdd?.units[servingPicker.selectedRow(inComponent: 2)].conversionToBaseUnit {
//
//            let newFood = Food()
//            newFood.id = foodToBeAdded.id
//            newFood.name = foodToBeAdded.name
//            newFood.brand = foodToBeAdded.brand
//            newFood.cooked = foodToBeAdded.cooked
//            newFood.servingSize = servingInUnits
//            newFood.unit = "\(foodToBeAdded.units[servingPicker.selectedRow(inComponent: 2)].unit)"
//            newFood.calories = foodToBeAdded.caloriesPerBaseUnit * servingInUnits * unitConversion
//            newFood.fats = foodToBeAdded.fatsPerBaseUnit * servingInUnits * unitConversion
//            newFood.carbs = foodToBeAdded.carbsPerBaseUnit * servingInUnits * unitConversion
//            newFood.protein = foodToBeAdded.proteinPerBaseUnit * servingInUnits * unitConversion
//            newFood.alcohol = foodToBeAdded.alcoholPerBaseUnit * servingInUnits * unitConversion
//            newFood.timing = timing!
//
//            print("\(foodToBeAdded.caloriesPerBaseUnit) \(servingInUnits) \(unitConversion)")
//            print("\(logDate!)")
//
//            let predicate = NSPredicate(format: "date = %@", logDate as! NSDate)
//
//            do {
//                try realm.write {
//                    realm.objects(UserData.self).first?.dailyData.filter(predicate).first?.data.append(newFood)
//                }
//            } catch {
//                print("Error saving new items, \(error)")
//            }
//            dismiss(animated: true, completion: nil)
//        } else if let foodToBeEditedInfo = mappedDBFood, let unitConversion = mappedDBFood?.acceptedUnits[servingPicker.selectedRow(inComponent: 2)].conversionToBaseUnit {
//            print("starting process")
//            do {
//                try realm.write {
//                    print("in process")
//                    foodToEdit!.calories = totalCalories
//                    foodToEdit!.servingSize = servingInUnits
//                    foodToEdit!.unit = "\(foodToBeEditedInfo.acceptedUnits[servingPicker.selectedRow(inComponent: 2)].unit)"
//                    foodToEdit!.fats = foodToBeEditedInfo.caloriesPerBaseUnit * servingInUnits * unitConversion
//                    foodToEdit!.carbs = foodToBeEditedInfo.carbsPerBaseUnit * servingInUnits * unitConversion
//                    foodToEdit!.protein = foodToBeEditedInfo.proteinPerBaseUnit * servingInUnits * unitConversion
//                    foodToEdit!.alcohol = foodToBeEditedInfo.alcoholPerBaseUnit * servingInUnits * unitConversion
//                }
//
//            } catch {
//                print("Error saving new items, \(error)")
//            }
//            _ = navigationController?.popViewController(animated: true)
//            print("process complete")
//        }
    }
    
    
    
    // MARK: UIPicker
    
    /*Delegate Methods*/
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return servingData[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return servingData[component][row]
    }
    
    /*Picker Methods*/
    
    // Set up all components of the UIPicker
    func uiPickerSetup() {
        
        var fullServings = [String]()
        var partialServings = [String]()
        var conversionList = [String]()
        
        fullServingSetup(fullServingsArray: &fullServings)
        partialServingsSetup(partialServingsArray: &partialServings)
        conversionListSetup(conversionListArray: &conversionList)
        
        servingData = [fullServings,
                       partialServings,
                       conversionList,
        ]
        
    }
    
    func fullServingSetup (fullServingsArray: inout [String]) {
        var fullServingsSetup = [Int]()
        
        fullServingsSetup += 1...2000
        let stringSetup = fullServingsSetup.map { String($0) }
        fullServingsArray.append("-")
        fullServingsArray.append(contentsOf: stringSetup)
    }
    
    func partialServingsSetup(partialServingsArray: inout [String]) {
        let setUp = ["-","1/8","1/4","1/3","3/8","1/2","5/8","2/3","3/4","7/8"]
        partialServingsArray.append(contentsOf: setUp)
    }
    
    // Loads Accepted Units based on the food item pulled
    private func conversionListSetup(conversionListArray: inout [String]) {
        if let foodFromDatabase = foodToAdd {
            for unit in foodFromDatabase.units {
                conversionListArray.append(unit.unit)
                print("\(unit.unit) and \(unit.conversionToBaseUnit)")
                print(conversionListArray)
            }
            mappedDBFood = foodFromDatabase
        } else if let existingFood = foodToEdit {
            if mappedDBFood != nil {
                print("fully loaded")
            } else {
            let foodId = existingFood.id
            var supportedUnits = [String]()
            let params = ["foodId": foodId] as [String:Any]
            Alamofire.request(foodDBURL, method: .get, parameters: params).responseJSON {
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
                            supportedUnits.append(name)
                            units.append(newUnit)
                        }
                        let returnedFood = DBFoodAPIModel(idSetUp: id, nameSetUp: name, brandSetUp: brand, variantSetUp: variant, cookedSetUp: cooked, defaultServingSetUp: defaultServing, defaultUnitSetUp: defaultUnit, caloriesPerBaseUnitSetUp: caloriesPerBaseUnit, fatsPerBaseUnitSetUp: fatsPerBaseUnit, carbsPerBaseUnitSetUp: carbsPerBaseUnit, proteinPerBaseUnitSetUp: proteinPerBaseUnit, alcoholPerBaseUnitSetUp: alcoholPerBaseUnit, supportedUnits: units)
                        self.mappedDBFood = returnedFood
                        if self.foodLoadedTracker == false {
                            self.foodLoadedTracker = true
                        }
                    }
                    supportedUnits.reverse()
                } else {
                    print("Error")
                }
            }
            conversionListArray = supportedUnits
            }
            
        }
    }
    
    
    // Load UIPicker components in the right placement
    func setInitialUIPicker() {
        
        servingInUnits = (foodToAdd?.defaultServing ?? foodToEdit?.servingSize)!
        unit = foodToAdd?.defaultUnit ?? foodToEdit?.unit ?? "Loading"
        var unitList = servingData.last
        print(unitList)
        
        var fullServing = Int(servingInUnits)
        var partialServing = servingInUnits - Double(fullServing)
        var partialPickerPosition = 0
        
        convertValueToPartialServingPicker(partialValue: &partialServing, partialPicker: &partialPickerPosition, fullServingValue: &fullServing)
        
        servingPicker.selectRow(fullServing, inComponent: 0, animated: false)
        servingPicker.selectRow(partialPickerPosition, inComponent: 1, animated: false)
        if unitList!.isEmpty {
            unitList!.append("Loading")
            servingPicker.selectRow(0, inComponent: 2, animated: false)
        } else {
            servingPicker.selectRow(servingData.last!.index(of: "\(unit)")!, inComponent: 2, animated: false)
        }
    }
    
    // Handles conversion of UIPicker when user switches a unit
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let unitConversion = mappedDBFood!.units[servingPicker.selectedRow(inComponent: 2)].conversionToBaseUnit
        let caloriesPerBaseUnit = mappedDBFood!.caloriesPerBaseUnit
        var fullServing: Int = Int(servingInUnits.rounded(.down))
        var partialServing: Double = servingInUnits - Double(fullServing)
        var partialPickerPosition = 0
        
        switch component {
        case 0:
            fullServing = Int(servingData[component][servingPicker.selectedRow(inComponent: component)]) ?? 0
        case 1:
            convertPartialServingPickerToValue(selection: servingData[component][servingPicker.selectedRow(inComponent: component)], output: &partialServing)
        case 2:
            let newlySelectedUnitConversionToBase = mappedDBFood!.units[servingPicker.selectedRow(inComponent: component)].conversionToBaseUnit
            
            
            servingInUnits = totalCalories / (newlySelectedUnitConversionToBase * caloriesPerBaseUnit)
            print("total calories: \(totalCalories), servingInUnits: \(servingInUnits)")
            fullServing = Int(servingInUnits.rounded(.down))
            partialServing = servingInUnits - Double(fullServing)
            print("full servings: \(fullServing), partialServings: \(partialServing)")
            convertValueToPartialServingPicker(partialValue: &partialServing, partialPicker: &partialPickerPosition, fullServingValue: &fullServing)
            

            servingPicker.selectRow(fullServing, inComponent: 0, animated: true)
            servingPicker.selectRow(partialPickerPosition, inComponent: 1, animated: true)
            
        default:
            print("error")
        }
        servingInUnits = Double(fullServing) + partialServing
        print("After In&Out function state:: full servings: \(fullServing), partialServings: \(partialServing), servingInUnits: \(servingInUnits)")
        totalCalories = servingInUnits * caloriesPerBaseUnit * unitConversion
        caloriesField.text = String(roundToTens(x: totalCalories))
        
    }
    
    // Parital Serving UIPicker to Decimal conversion
    func convertPartialServingPickerToValue(selection: String, output: inout Double) {
        switch selection {
        case "-":
            output = 0
        case "1/8":
            output = 1/8
        case "1/4":
            output = 1/4
        case "1/3":
            output = 1/3
        case "3/8":
            output = 3/8
        case "1/2":
            output = 1/2
        case "5/8":
            output = 5/8
        case "2/3":
            output = 2/3
        case "3/4":
            output = 3/4
        case "7/8":
            output = 7/8
        default:
            output = 0
        }
    }
    
    // Decimal Value to Partial Serving UIPicker conversion
    func convertValueToPartialServingPicker(partialValue: inout Double, partialPicker: inout Int, fullServingValue: inout Int) {
        switch partialValue {
        case 0..<0.0625:
            partialPicker = 0
        case 0.0625..<0.1875 :
            partialPicker = 1
        case 0.1875..<0.291666:
            partialPicker = 2
        case 0.291666..<0.354166:
            partialPicker = 3
        case 0.354166..<0.4375:
            partialPicker = 4
        case 0.4375..<0.5625:
            partialPicker = 5
        case 0.5625..<0.645833:
            partialPicker = 6
        case 0.645833..<0.70833:
            partialPicker = 7
        case 0.70833..<0.8125:
            partialPicker = 8
        case 0.8125..<0.9375:
            partialPicker = 9
        case 0.9375...1:
            partialPicker = 0
            partialValue = 0
            fullServingValue = fullServingValue + 1
        default:
            print("not working")
        }
        
    }
    
    
    //MARK: - User Facing Functions
    
    // Reloads all labels - needs refactoring, but low priority
    func updateLabels() {
        nameLabel.text = foodToEdit?.name ?? foodToAdd?.name
        if let item = foodToEdit {
            totalCalories = item.calories
            caloriesField.text = "\(roundToTens(x: item.calories))"
            servingSizeField.text = "\(item.servingSize) \(item.unit)"
        } else {
            totalCalories = (foodToAdd?.units.first?.conversionToBaseUnit)! * foodToAdd!.caloriesPerBaseUnit * (foodToAdd?.defaultServing)!
            caloriesField.text = "\(roundToTens(x: totalCalories))"
            servingSizeField.text = "\(foodToAdd!.defaultServing) \(foodToAdd!.defaultUnit)"
        }
        
        miscLabel.text = "PlaceHolder Section"
    }
    
    // Rounds calculations to the nearest 10.
    func roundToTens(x: Double) -> Int {
        return 10 * Int(round(x / 10.0))
    }
    
    // MARK: Text Edit Methods
    
    /* UITextFieldDelegate Methods */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        saveButton.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
    }
    
    /* Additional Functionality Methods */
    // User can't save if in the middle of editing text
    private func updateSaveButtonState() {
        let text = nameLabel.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
    // End editing when background is tapped
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
}

