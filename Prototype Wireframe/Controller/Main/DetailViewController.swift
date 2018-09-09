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
    
    var foodToAdd: DBFood?
    var food: Food? /*{
        didSet {
            navigationItem.title = "Edit Food"
        }
    }*/
    
    var servingData: [[String]] = [[String]]()
    
    // let fullServings = ["-","1","2","3","4","5","6","7","8","9","10","11","12","13","14"]
    var fullServings = ["-"]
    var fullServingsSetup = [Int]()
    
    let partialServings = ["-","1/8","1/4","1/3","3/8","1/2","5/8","2/3","3/4","7/8"]
    var conversionList = [String]()
    var servingInUnits: Double = 0
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
//
//        servingData = [["-","1","2","3","4","5","6","7","8","9","10","11",],
//                       ["-","1/8","1/4","1/3","1/2","2/3","3/4",],
//                       ["oz","g",],
//                       ]
        
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
        }
//        } else {
//            servingPicker.selectRow(Int((food?.servingSize)!)!, inComponent: 0, animated: false)
//            servingPicker.selectRow(0, inComponent: 1, animated: false)
//            servingPicker.selectRow(Int((foodToAdd?.acceptedUnits.first?.conversionToBaseUnit)!), inComponent: 2, animated: false)
//        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        nameLabel.text = food?.name ?? foodToAdd?.name
        servingSizeField.text = food?.servingSize ?? "\(foodToAdd!.defaultServing) \(foodToAdd!.defaultUnit)"
        if let item = food {
            caloriesField.text = "\(item.calories)"
            totalCalories = Double(item.calories)
        } else {
            totalCalories = (foodToAdd?.acceptedUnits.first?.conversionToBaseUnit)! * foodToAdd!.caloriesPerBaseUnit
            caloriesField.text = "\(roundToTens(x: totalCalories))"
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
        if let foodFromDatabse = foodToAdd {
            for unit in foodFromDatabse.acceptedUnits {
                conversionList.append(unit.unit)
            }
        }
    }
    
    func roundToTens(x: Double) -> Int {
        return 10 * Int(round(x / 10.0))
    }
    
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        let newFood = Food()
        newFood.name = (food?.name ?? foodToAdd?.name)!
        newFood.brand = food?.brand ?? foodToAdd?.brand
        newFood.cooked = food?.cooked ?? foodToAdd?.cooked
        newFood.servingSize = servingSizeField.text
        newFood.calories = (food?.calories ?? Int(totalCalories))
        newFood.fats = (food?.fats ?? round((foodToAdd?.fatsPerBaseUnit)! * servingInUnits))
        newFood.carbs = (food?.carbs ?? round((foodToAdd?.carbsPerBaseUnit)! * servingInUnits))
        newFood.protein = (food?.protein ?? round((foodToAdd?.proteinPerBaseUnit)! * servingInUnits))
        newFood.alcohol = (food?.alcohol ?? round((foodToAdd?.alcoholPerBaseUnit)! * servingInUnits))
        newFood.timing = (timing ?? food?.timing)!
        newFood.breakfast = (food?.breakfast ?? foodToAdd?.breakfast)!
        newFood.lunch = (food?.lunch ?? foodToAdd?.lunch)!
        newFood.dinner = (food?.dinner ?? foodToAdd?.dinner)!
        newFood.snack = (food?.snack ?? foodToAdd?.snack)!
        newFood.main = (food?.main ?? foodToAdd?.main)!
        newFood.side = (food?.side ?? foodToAdd?.side)!
        newFood.cuisine = food?.cuisine ?? foodToAdd?.cuisine
        do {
            try realm.write {
                realm.objects(UserData.self).first?.data.append(newFood)
            }
        } catch {
            print("Error saving new items, \(error)")
        }
        dismiss(animated: true, completion: nil)
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
            switch servingData[1][servingPicker.selectedRow(inComponent: 1)] {
            case "-":
                partialServing = 0
            case "1/8":
                partialServing = 1/8
            case "1/4":
                partialServing = 1/4
            case "1/3":
                partialServing = 1/3
            case "3/8":
                partialServing = 3/8
            case "1/2":
                partialServing = 1/2
            case "5/8":
                partialServing = 5/8
            case "2/3":
                partialServing = 2/3
            case "3/4":
                partialServing = 3/4
            case "7/8":
                partialServing = 7/8
            default:
                partialServing = 0
            }
            servingInUnits = wholeNumberServing + partialServing
            if let unitConversion = foodToAdd?.acceptedUnits[servingPicker.selectedRow(inComponent: 2)].conversionToBaseUnit, let caloriesPerUnit = foodToAdd?.caloriesPerBaseUnit  {
                totalCalories = servingInUnits * caloriesPerUnit * unitConversion
                caloriesField.text = String(roundToTens(x: totalCalories))
            }

        case 1:
            if let serving = Double(servingData[0][servingPicker.selectedRow(inComponent: 0)]) {
                wholeNumberServing = serving
            } else {
                wholeNumberServing = 0
            }
            switch servingData[component][servingPicker.selectedRow(inComponent: component)] {
            case "-":
                partialServing = 0
            case "1/8":
                partialServing = 1/8
            case "1/4":
                partialServing = 1/4
            case "1/3":
                partialServing = 1/3
            case "3/8":
                partialServing = 3/8
            case "1/2":
                partialServing = 1/2
            case "5/8":
                partialServing = 5/8
            case "2/3":
                partialServing = 2/3
            case "3/4":
                partialServing = 3/4
            case "7/8":
                partialServing = 7/8
            default:
                partialServing = 0
            }
            servingInUnits = wholeNumberServing + partialServing
            if let unitConversion = foodToAdd?.acceptedUnits[servingPicker.selectedRow(inComponent: 2)].conversionToBaseUnit, let caloriesPerUnit = foodToAdd?.caloriesPerBaseUnit {
                totalCalories = servingInUnits * caloriesPerUnit * unitConversion
                caloriesField.text = String(roundToTens(x: totalCalories))
            }

        case 2:
            if let selectedUnit = foodToAdd?.acceptedUnits[servingPicker.selectedRow(inComponent: component)].conversionToBaseUnit, let caloriesPerUnit = foodToAdd?.caloriesPerBaseUnit {
                servingInUnits = Double(totalCalories) / (selectedUnit * caloriesPerUnit)
                wholeNumberServing = servingInUnits.rounded(.down)
                partialServing = servingInUnits - wholeNumberServing
                print("\(partialServing)")
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
        
//        if let serving = Double(servingData[component][servingPicker.selectedRow(inComponent: 0)] + servingData[component][servingPicker.selectedRow(inComponent: 1)]) {
//            servingInBaseUnits = serving
//        }
        
    }

    
}

