//
//  DetailViewController.swift
//  Prototype Wireframe
//
//  Created by MAC on 5/29/18.
//  Copyright © 2018 Jaime Lai. All rights reserved.
//

import UIKit
import RealmSwift

class DetailViewController: UIViewController, UITextFieldDelegate /*, UIPickerViewDelegate, UIPickerViewDataSource*/ {
    
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
    var food: Food! /*{
        didSet {
            navigationItem.title = "Edit Food"
        }
    }*/
    
    @IBOutlet var servingPicker: UIPickerView!
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
//    struct ServingSize {
//        <#fields#>
//    }
//
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        servingPicker.delegate = self
//        servingPicker.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        nameLabel.text = food.name
        servingSizeField.text = food.servingSize
        caloriesField.text = "\(food.calories)"
        
        miscLabel.text = "PlaceHolder Section"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        view.endEditing(true)
        
//        food.name = nameField.text ?? ""
//        food.servingSize = servingSizeField.text ?? ""
//
//        // Iffy, needs to be revisited
//        if let value = Int(caloriesField.text!) {
//            food.calories = value
//        } else {
//            food.calories = 0
//        }
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
        newFood.name = food.name
        newFood.brand = food.brand
        newFood.cooked = food.cooked
        newFood.servingSize = servingSizeField.text
        newFood.calories = food.calories
        newFood.fats = food.fats
        newFood.carbs = food.carbs
        newFood.protein = food.protein
        newFood.alcohol = food.alcohol
        newFood.timing = timing ?? food.timing
        newFood.breakfast = food.breakfast
        newFood.lunch = food.lunch
        newFood.dinner = food.dinner
        newFood.snack = food.snack
        newFood.main = food.main
        newFood.side = food.side
        newFood.cuisine = food.cuisine
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
    
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 3
//    }
//
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        <#code#>
//    }

//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        <#code#>
//    }

}

