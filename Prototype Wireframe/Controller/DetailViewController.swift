//
//  DetailViewController.swift
//  Prototype Wireframe
//
//  Created by MAC on 5/29/18.
//  Copyright © 2018 Jaime Lai. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var nameField: UITextField!
    @IBOutlet var servingSizeField: UITextField!
    @IBOutlet var caloriesField: UITextField!
    @IBOutlet var miscLabel: UILabel!
    
    var food: FoodItem! {
        didSet {
            navigationItem.title = "Edit Food"
        }
    }
    
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
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
    
}
