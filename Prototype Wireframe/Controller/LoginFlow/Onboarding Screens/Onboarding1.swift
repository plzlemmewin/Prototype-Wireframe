//
//  Onboarding1ViewController.swift
//  Prototype Wireframe
//
//  Created by MAC on 10/2/20.
//  Copyright © 2020 Jaime Lai. All rights reserved.
//

import UIKit

class Onboarding1ViewController: UIViewController, UITextFieldDelegate {

    //MARK: Variables & Constants
    
    @IBOutlet weak var nameInput: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameInput.delegate = self
        
        // Disabling Next button until a name is entered.
        nextButton.isEnabled = false
        nextButton.alpha = 0.75

    }
    

    //MARK: Functions
    
    // Checks to see if user has entered a name
    @IBAction func nameInputChanged(_ sender: Any) {
        if let text = nameInput.text, text.isEmpty {
            nextButton.isUserInteractionEnabled = false
            nextButton.isEnabled = false
            nextButton.alpha = 0.5
        } else {
            nextButton.isUserInteractionEnabled = true
            nextButton.isEnabled = true
            nextButton.alpha = 1
        }
    }
    
    // Segue to Onboarding Step 2
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let onboarding2VC = segue.destination as! Onboarding2ViewController
        onboarding2VC.name = nameInput.text
    }
    
    

}
