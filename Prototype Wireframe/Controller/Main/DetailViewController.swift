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
    
    
    /*enum Meals: Int {
     case breakfast = 0, lunch, dinner, snacks
     }
     
     var data = [Meals: [Food]]()
     
     func sortData() {
     data[.breakfast] = userFoods.filter { $0.timing == "breakfast" }
     data[.lunch] = userFoods.filter {$0.timing == "lunch"}
     data[.dinner] = userFoods.filter{$0.timing == "dinner"}
     data[.snacks] = userFoods.filter{$0.timing == "snacks"}
     print("\(data[.breakfast])")
     }*/
    
    var servingData: [[String]] = [[String]]()
    let fullServings = ["-","1","2","3","4","5","6","7","8","9","10","11",]
    let partialServings = ["-","1/8","1/4","1/3","1/2","2/3","3/4",]
    
    @IBOutlet var servingPicker: UIPickerView!
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        servingPicker.delegate = self
        servingPicker.dataSource = self
//
//        servingData = [["-","1","2","3","4","5","6","7","8","9","10","11",],
//                       ["-","1/8","1/4","1/3","1/2","2/3","3/4",],
//                       ["oz","g",],
//                       ]
        
        
        servingData = [fullServings,
                       partialServings,
                       ["oz","g",],
        ]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        nameLabel.text = food?.name ?? foodToAdd?.name
        servingSizeField.text = food?.servingSize ?? foodToAdd?.servingSize
        if let item = food {
            caloriesField.text = "\(item.calories)"
        } else {
            caloriesField.text = "\(foodToAdd!.calories)"
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
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        let newFood = Food()
        newFood.name = (food?.name ?? foodToAdd?.name)!
        newFood.brand = food?.brand ?? foodToAdd?.brand
        newFood.cooked = food?.cooked ?? foodToAdd?.cooked
        newFood.servingSize = servingSizeField.text
        newFood.calories = (food?.calories ?? foodToAdd?.calories)!
        newFood.fats = (food?.fats ?? foodToAdd?.fats)!
        newFood.carbs = (food?.carbs ?? foodToAdd?.carbs)!
        newFood.protein = (food?.protein ?? foodToAdd?.protein)!
        newFood.alcohol = (food?.alcohol ?? foodToAdd?.alcohol)!
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
    
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        
//    }

    
}

