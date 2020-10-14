//
//  Onboarding3ViewController.swift
//  Prototype Wireframe
//
//  Created by MAC on 10/2/20.
//  Copyright © 2020 Jaime Lai. All rights reserved.
//

import UIKit

class Onboarding3ViewController: UIViewController {
    
    var name: String?
    var gender: Int?
    var birthday: String?
    var activityLevel: String?
    var height: Double?
    var goal = 1
    
    

    @IBOutlet weak var weightLossButton: UIButton!
    @IBOutlet weak var maintenanceButton: UIButton!
    @IBOutlet weak var weightGainButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Button Properties
        let borderColor = UIColor.lightGray
        let opacity: CGFloat = 0.75
        
        
        // Button Set Up
        weightLossButton.layer.borderWidth = 1.0
        weightLossButton.layer.borderColor = UIColor.blue.cgColor
        
        weightGainButton.alpha = opacity
        weightGainButton.layer.borderWidth = 1.0
        weightGainButton.layer.borderColor = borderColor.withAlphaComponent(opacity).cgColor
        
        maintenanceButton.alpha = opacity
        maintenanceButton.layer.borderWidth = 1.0
        maintenanceButton.layer.borderColor = borderColor.withAlphaComponent(opacity).cgColor
        
        nextButton.alpha = opacity
        
        // Disable other buttons for the time being
        maintenanceButton.isEnabled = false
        weightGainButton.isEnabled = false
        nextButton.isEnabled = false
        
        print("\(name), \(gender), \(birthday), \(height)")
    }
    

    @IBAction func weightLossButtonPressed(_ sender: Any) {
        if weightLossButton.isSelected == false {
            weightLossButton.isSelected = true
            nextButton.isEnabled = true
            nextButton.alpha = 1
        } else {
            weightLossButton.isSelected = false
            nextButton.isEnabled = false
            nextButton.alpha = 0.75
        }

        
    }
    
    // Segue to Onboarding Step 4
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let onboarding4VC = segue.destination as! Onboarding4ViewController
        onboarding4VC.name = name!
        onboarding4VC.birthday = birthday
        onboarding4VC.gender = gender
        onboarding4VC.activityLevel = activityLevel
        onboarding4VC.height = height
        onboarding4VC.goal = goal
    }
    
    
    

}
