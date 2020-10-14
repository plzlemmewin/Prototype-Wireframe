//
//  Onboarding4ViewController.swift
//  Prototype Wireframe
//
//  Created by MAC on 10/2/20.
//  Copyright © 2020 Jaime Lai. All rights reserved.
//

import UIKit

class Onboarding4ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    
    
    var name: String?
    var gender: Int?
    var birthday: String?
    var activityLevel: String?
    var height: Double?
    var goal: Int?
    var progressRate = "" {
        didSet {
            enableNextButton()
        }
    }
    
    let progressRateSelections = ["Slow", "Moderate", "Aggressive"]
    
    let progressExplanations = [
        "Recommended for beginners. You'll be losing 0.5 lbs a week",
        "If you're up for a challenge, this is for you. You'll lose around 1 lb a week.",
        "This will be challenging! Only pick this option if you have prior experience with weight loss. You'll lose 1.5 lbs a week",
    ]
    
    let progressRatePicker: UIPickerView = {
        let pk = UIPickerView()
        return pk
    }()
    
    let toolBar: UIToolbar = {
        let tb = UIToolbar()
        tb.barStyle = .default
        tb.isUserInteractionEnabled = true
        return tb
    }()
    
    @IBOutlet weak var progressRateButton: UIButton!
    @IBOutlet weak var progressExplanataionTextField: UITextView!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // progressRatePicker setup
        progressRatePicker.delegate = self
        progressRatePicker.dataSource = self
        
        // Progress Rate Picker Set up
        progressRatePicker.frame = CGRect(x: 0, y: self.view.frame.maxY, width: self.view.frame.width, height: 200)
        
        // Toolbar Set up
        toolBar.frame = CGRect(x: 0, y: self.view.frame.maxY, width: self.view.frame.width, height: 50)
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(closeToolBar))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(closeToolBar))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        self.view.addSubview(progressRatePicker)
        self.view.addSubview(toolBar)
        
        // Disabling Next button until progress is changed
        nextButton.isEnabled = false
        nextButton.alpha = 0.75
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setInitialValues()
    }
    
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return progressRateSelections.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return progressRateSelections[row]
    }
    
    
    
    
    func setInitialValues() {
        setInitialProgressRate()
    }
    
    
    func setInitialProgressRate() {
        progressRatePicker.selectRow(1, inComponent: 0, animated: false)
    }
    
    // Disable & Enabling Onboarding Progress
    func hideNextButton() {
        nextButton.isHidden = true
    }
    
    func showNextButton() {
        nextButton.isHidden = false
    }
    
    @IBAction func progressRateButtonPressed(_ sender: Any) {
        hideNextButton()
        progressRatePicker.frame = CGRect(x: 0, y: self.view.frame.maxY - 200, width: self.view.frame.width, height: 200)
        toolBar.frame = CGRect(x: 0, y: self.view.frame.maxY - 250, width: self.view.frame.width, height: 50)
    }
    
    @objc func closeToolBar() {
        
        progressRatePicker.frame = CGRect(x: 0, y: self.view.frame.maxY, width: self.view.frame.width, height: 200)
        
        toolBar.frame = CGRect(x: 0, y: self.view.frame.maxY, width: self.view.frame.width, height: 50)
        
        progressRate = progressRateSelections[progressRatePicker.selectedRow(inComponent: 0)]
        updateLabels() // Will need to make it so that canceling the button doesn't update the labels, only saving does.
        showNextButton()
    }
    
    func updateLabels() {
        
        let currentPickerSelection = progressRatePicker.selectedRow(inComponent: 0)
        
        progressRateButton.setTitle(progressRate, for: .normal)
        progressExplanataionTextField.text = progressExplanations[currentPickerSelection]
    }
    
    func enableNextButton() {
        nextButton.isUserInteractionEnabled = true
        nextButton.isEnabled = true
        nextButton.alpha = 1
    }

    // Segue to Onboarding Step 4
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let onboarding5VC = segue.destination as! Onboarding5ViewController
        onboarding5VC.name = name!
        onboarding5VC.birthday = birthday
        onboarding5VC.gender = gender
        onboarding5VC.activityLevel = activityLevel
        onboarding5VC.height = height
        onboarding5VC.goal = goal
        onboarding5VC.progressRate = progressRate
    }

}
