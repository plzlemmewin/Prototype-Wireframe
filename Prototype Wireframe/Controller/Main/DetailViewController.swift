//
//  DetailViewController.swift
//  Prototype Wireframe
//
//  Created by MAC on 5/29/18.
//  Copyright © 2018 Jaime Lai. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITextFieldDelegate/*, UIPickerViewDelegate, UIPickerViewDataSource*/ {
    
    @IBOutlet var nameField: UITextField!
    @IBOutlet var servingSizeField: UITextField!
    @IBOutlet var caloriesField: UITextField!
    @IBOutlet var miscLabel: UILabel!
    
    var food: FoodItem! {
        didSet {
            navigationItem.title = "Edit Food"
        }
    }
    
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
        
        nameField.text = food.identifier
        servingSizeField.text = food.servingSize
        caloriesField.text = "\(food.calories)"
        
        miscLabel.text = "PlaceHolder Section"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        view.endEditing(true)
        
        food.identifier = nameField.text ?? ""
        food.servingSize = servingSizeField.text ?? ""
        
        // Iffy, needs to be revisited
        if let value = Int(caloriesField.text!) {
            food.calories = value
        } else {
            food.calories = 0
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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

