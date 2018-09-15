//
//  DetailViewController.swift
//  Prototype Wireframe
//
//  Created by MAC on 5/29/18.
//  Copyright © 2018 Jaime Lai. All rights reserved.
//

import UIKit
import RealmSwift

class DetailViewController: UIViewController, UITextFieldDelegate , UIPickerViewDelegate, UIPickerViewDataSource {

    
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet var servingSizeField: UITextField!
    @IBOutlet var caloriesField: UITextField!
    @IBOutlet var miscLabel: UILabel!
    

    let realm = try! Realm()
    
    var timing: String? {
        didSet {
            print("\(timing ?? "nil")")
        }
    }
    
    var mappedDBFood: DBFood?
    var foodToAdd: DBFood?
    var food: Food?
    
    var servingData: [[String]] = [[String]]()
    var fullServings = ["-"]
    var fullServingsSetup = [Int]()
    
    let partialServings = ["-","1/8","1/4","1/3","3/8","1/2","5/8","2/3","3/4","7/8"]
    var conversionList = [String]()
    var servingInUnits: Double = 0
    var unit: String = ""
    var totalCalories: Double = 0

    @IBOutlet var servingPicker: UIPickerView!
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        servingPicker.delegate = self
        servingPicker.dataSource = self
        loadAcceptedUnits()
        
        fullServingsSetup += 1...2000
        let stringSetup = fullServingsSetup.map { String($0) }
        fullServings.append(contentsOf: stringSetup)

        servingData = [fullServings,
                       partialServings,
                       conversionList,
        ]
        
        if let enteredFood = foodToAdd {
            servingPicker.selectRow(enteredFood.defaultServing, inComponent: 0, animated: false)
            servingPicker.selectRow(0, inComponent: 1, animated: false)
            servingPicker.selectRow(0, inComponent: 2, animated: false)
            
            servingInUnits = Double(enteredFood.defaultServing)
            unit = enteredFood.defaultUnit
            print("true")
            
        } else if let enteredFood = food {
            
            servingInUnits = enteredFood.servingSize
            var fullServing = Int(servingInUnits)
            var partialServing = servingInUnits - Double(fullServing)
            let unit = enteredFood.unit

            switch partialServing {
            case 0..<0.0625:
                partialServing = 0
            case 0.0625..<0.1875 :
                partialServing = 1
            case 0.1875..<0.291666:
                partialServing = 2
            case 0.291666..<0.354166:
                partialServing = 3
            case 0.354166..<0.4375:
                partialServing = 4
            case 0.4375..<0.5625:
                partialServing = 5
            case 0.5625..<0.645833:
                partialServing = 6
            case 0.645833..<0.70833:
                partialServing = 7
            case 0.70833..<0.8125:
                partialServing = 8
            case 0.8125..<0.9375:
                partialServing = 9
            case 0.9375...1:
                partialServing = 0
                fullServing = fullServing + 1
            default:
                print("not working")
            }
//            print("\(fullServing) \(partialServing) \(unit)")
            
            servingPicker.selectRow(fullServing, inComponent: 0, animated: false)
            servingPicker.selectRow(Int(partialServing), inComponent: 1, animated: false)
            
            mappedDBFood = realm.objects(DBFood.self).filter("id = \(enteredFood.id)").first
            var supportedUnits = [String]()
            for unit in (mappedDBFood?.acceptedUnits)! {
                supportedUnits.append(unit.unit)
            }
            
            servingPicker.selectRow(supportedUnits.index(of: "\(unit)")!, inComponent: 2, animated: false)
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        nameLabel.text = food?.name ?? foodToAdd?.name
        if let item = food {
            totalCalories = item.calories
            caloriesField.text = "\(roundToTens(x: item.calories))"
            servingSizeField.text = "\(item.servingSize) \(item.unit)"
        } else {
            totalCalories = (foodToAdd?.acceptedUnits.first?.conversionToBaseUnit)! * foodToAdd!.caloriesPerBaseUnit
            caloriesField.text = "\(roundToTens(x: totalCalories))"
            servingSizeField.text = "\(foodToAdd!.defaultServing) \(foodToAdd!.defaultUnit)"
        }
        
        miscLabel.text = "PlaceHolder Section"
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        view.endEditing(true)
    }
    
    // MARK: UITextFieldDelegate Methods
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
    
    // MARK: Private Methods
    private func updateSaveButtonState() {
        let text = nameLabel.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
    private func loadAcceptedUnits() {
        if let foodFromDatabase = foodToAdd {
            for unit in foodFromDatabase.acceptedUnits {
                conversionList.append(unit.unit)
            }
        } else if let existingFood = food {
            let mappedDBFood = realm.objects(DBFood.self).filter("id = \(existingFood.id)").first
            for unit in (mappedDBFood?.acceptedUnits)! {
                conversionList.append(unit.unit)
            }
        }
    }
        
    func roundToTens(x: Double) -> Int {
        return 10 * Int(round(x / 10.0))
    }
    
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        if let foodToBeAdded = foodToAdd, let unitConversion = foodToAdd?.acceptedUnits[servingPicker.selectedRow(inComponent: 2)].conversionToBaseUnit {
            
            let newFood = Food()
            newFood.id = foodToBeAdded.id
            newFood.name = foodToBeAdded.name
            newFood.brand = foodToBeAdded.brand
            newFood.cooked = foodToBeAdded.cooked
            newFood.servingSize = servingInUnits
            newFood.unit = "\(foodToBeAdded.acceptedUnits[servingPicker.selectedRow(inComponent: 2)].unit)"
            newFood.calories = foodToBeAdded.caloriesPerBaseUnit * servingInUnits * unitConversion
            newFood.fats = foodToBeAdded.fatsPerBaseUnit * servingInUnits * unitConversion
            newFood.carbs = foodToBeAdded.carbsPerBaseUnit * servingInUnits * unitConversion
            newFood.protein = foodToBeAdded.proteinPerBaseUnit * servingInUnits * unitConversion
            newFood.alcohol = foodToBeAdded.alcoholPerBaseUnit * servingInUnits * unitConversion
            newFood.timing = timing!
            
            do {
                try realm.write {
                    realm.objects(UserData.self).first?.data.append(newFood)
                }
            } catch {
                print("Error saving new items, \(error)")
            }
            dismiss(animated: true, completion: nil)
        } else if let foodToBeEditedInfo = mappedDBFood, let unitConversion = mappedDBFood?.acceptedUnits[servingPicker.selectedRow(inComponent: 2)].conversionToBaseUnit {
            print("starting process")
            do {
                try realm.write {
                    print("in process")
                    food!.calories = totalCalories
                    food!.servingSize = servingInUnits
                    food!.unit = "\(foodToBeEditedInfo.acceptedUnits[servingPicker.selectedRow(inComponent: 2)].unit)"
                    food!.fats = foodToBeEditedInfo.caloriesPerBaseUnit * servingInUnits * unitConversion
                    food!.carbs = foodToBeEditedInfo.carbsPerBaseUnit * servingInUnits * unitConversion
                    food!.protein = foodToBeEditedInfo.proteinPerBaseUnit * servingInUnits * unitConversion
                    food!.alcohol = foodToBeEditedInfo.alcoholPerBaseUnit * servingInUnits * unitConversion
                }
                
            } catch {
                print("Error saving new items, \(error)")
            }
            _ = navigationController?.popViewController(animated: true)
            print("process complete")
        }
    }
        

    
    
    func partialServingMatch(selection: String, output: inout Double) {
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
    
    
    // MARK: UIPicker Delegate Methods
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return servingData[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return servingData[component][row]
    }
    
    /* Main Picker Function logic here. Very poorly written, so will need to be refactored */
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        var partialServing: Double = 0
        var wholeNumberServing: Double = 0
        
        switch component {
        case 0:
            if let fullServing = Double(servingData[component][servingPicker.selectedRow(inComponent: component)]) {
                wholeNumberServing = fullServing
            } else {
                wholeNumberServing = 0
            }
            partialServingMatch(selection: servingData[1][servingPicker.selectedRow(inComponent: 1)], output: &partialServing)

            servingInUnits = wholeNumberServing + partialServing
            if let unitConversion = foodToAdd?.acceptedUnits[servingPicker.selectedRow(inComponent: 2)].conversionToBaseUnit, let caloriesPerUnit = foodToAdd?.caloriesPerBaseUnit  {
                totalCalories = servingInUnits * caloriesPerUnit * unitConversion
                caloriesField.text = String(roundToTens(x: totalCalories))
            } else if let existingFood = mappedDBFood {
                let caloriesPerUnit = existingFood.caloriesPerBaseUnit
                let unitConversion = existingFood.acceptedUnits[servingPicker.selectedRow(inComponent: 2)].conversionToBaseUnit
                totalCalories = servingInUnits * caloriesPerUnit * unitConversion
                caloriesField.text = String(roundToTens(x: totalCalories))
            }

        case 1:
            if let serving = Double(servingData[0][servingPicker.selectedRow(inComponent: 0)]) {
                wholeNumberServing = serving
            } else {
                wholeNumberServing = 0
            }
            partialServingMatch(selection: servingData[component][servingPicker.selectedRow(inComponent: component)], output: &partialServing)

            servingInUnits = wholeNumberServing + partialServing
            if let unitConversion = foodToAdd?.acceptedUnits[servingPicker.selectedRow(inComponent: 2)].conversionToBaseUnit, let caloriesPerUnit = foodToAdd?.caloriesPerBaseUnit {
                totalCalories = servingInUnits * caloriesPerUnit * unitConversion
                caloriesField.text = String(roundToTens(x: totalCalories))
            } else if let existingFood = mappedDBFood {
                let caloriesPerUnit = existingFood.caloriesPerBaseUnit
                let unitConversion = existingFood.acceptedUnits[servingPicker.selectedRow(inComponent: 2)].conversionToBaseUnit
                totalCalories = servingInUnits * caloriesPerUnit * unitConversion
                caloriesField.text = String(roundToTens(x: totalCalories))
            }

        case 2:
            if let selectedUnit = foodToAdd?.acceptedUnits[servingPicker.selectedRow(inComponent: component)].conversionToBaseUnit, let caloriesPerUnit = foodToAdd?.caloriesPerBaseUnit {
                servingInUnits = Double(totalCalories) / (selectedUnit * caloriesPerUnit)
                wholeNumberServing = servingInUnits.rounded(.down)
                partialServing = servingInUnits - wholeNumberServing
            } else if let existingFood = mappedDBFood {
                let caloriesPerUnit = existingFood.caloriesPerBaseUnit
                let selectedUnit = existingFood.acceptedUnits[servingPicker.selectedRow(inComponent: component)].conversionToBaseUnit
                servingInUnits = Double(totalCalories) / (selectedUnit * caloriesPerUnit)
                wholeNumberServing = servingInUnits.rounded(.down)
                partialServing = servingInUnits - wholeNumberServing
            }
            switch partialServing {
            case 0..<0.0625:
                partialServing = 0
                print("\(partialServing)")
            case 0.0625..<0.1875 :
                partialServing = 1
                print("\(partialServing)")
            case 0.1875..<0.291666:
                partialServing = 2
                print("\(partialServing)")
            case 0.291666..<0.354166:
                partialServing = 3
                print("\(partialServing)")
            case 0.354166..<0.4375:
                partialServing = 4
                print("\(partialServing)")
            case 0.4375..<0.5625:
                partialServing = 5
                print("\(partialServing)")
            case 0.5625..<0.645833:
                partialServing = 6
                print("\(partialServing)")
            case 0.645833..<0.70833:
                partialServing = 7
                print("\(partialServing)")
            case 0.70833..<0.8125:
                partialServing = 8
                print("\(partialServing)")
            case 0.8125..<0.9375:
                partialServing = 9
                print("\(partialServing)")
            case 0.9375...1:
                partialServing = 0
                wholeNumberServing = wholeNumberServing + 1
                print("\(partialServing)")
            default:
                print("not working")
            }
            servingPicker.selectRow(Int(wholeNumberServing), inComponent: 0, animated: true)
            servingPicker.selectRow(Int(partialServing), inComponent: 1, animated: true)
            
        default:
            print("error")
        }
    }
}

