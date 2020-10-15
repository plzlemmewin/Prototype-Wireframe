//
//  Onboarding2ViewController.swift
//  Prototype Wireframe
//
//  Created by MAC on 10/2/20.
//  Copyright © 2020 Jaime Lai. All rights reserved.
//

import UIKit

class Onboarding2ViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    //MARK: Variables & Constants
    var buttonID = 0
    var numFieldsModified = 0
    
    var name: String?
    var birthday: String = ""
    var activityLevel: String = ""
    var height: Double = 0.0
    var weight: Double = 0.0
    
    let cmToInchConversion = 0.393701
    let activityLevelSelections = ["Sedentary", "Slightly Active", "Moderately Active", "Very Active", "Extremely Active"]
    
    // Control Flow
    @IBOutlet weak var userGreeting: UITextView!
    @IBOutlet weak var nextButton: UIButton!
    
    // User Input Buttons
    @IBOutlet weak var birthdayButton: UIButton!
    @IBOutlet weak var genderSegmentedControl: UISegmentedControl!
    @IBOutlet weak var heightButton: UIButton!
    @IBOutlet weak var activityLevelButton: UIButton!
    @IBOutlet weak var heightUnitsSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var weightUnitsSegmentedControl: UISegmentedControl!
    @IBOutlet weak var weightButton: UIButton!
    
    // Date Formatters
    let baseDateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        return df
    }()
    
    // Used for the date in the Nav Bar. Format: Jul 25, 2019
    let dateFormatterUser: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "MMM dd, yyyy"
        return df
    }()
    
    // UIPickers
    let datePicker: UIDatePicker = {
        let pk = UIDatePicker()
        pk.datePickerMode = .date
        return pk
    }()
    
    let activityLevelPicker: UIPickerView = {
        let pk = UIPickerView()
        return pk
    }()
    
    let heightPicker: UIPickerView = {
        let pk = UIPickerView()
        return pk
    }()
    
    let weightPicker: UIPickerView = {
        let pk = UIPickerView()
        return pk
    }()
    
    // heightPicker components
    var heightUnits = ["in"] // ["in","cm"]
    var heightData: [[String]] = [[String]]()
    
    // weightPicker components
    var weightUnits = ["lb"] // ["lbs","kg"]
    var weightData: [[String]] = [[String]]()
    
    
    let toolBar: UIToolbar = {
        let tb = UIToolbar()
        tb.barStyle = .default
        tb.isUserInteractionEnabled = true
        return tb
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Disabling Next button fields are entered
//        nextButton.isEnabled = false
//        nextButton.alpha = 0.75

        // Do any additional setup after loading the view.
        if let userName = name {
           userGreeting.text = "Great meeting you, \(userName)!"
        }
        

        // heightPicker setup
        heightPicker.delegate = self
        heightPicker.dataSource = self
        heightUnitsSegmentedControl.isEnabled = false
        
        // weightPicker setup
        weightPicker.delegate = self
        weightPicker.dataSource = self
        weightUnitsSegmentedControl.isEnabled = false
        
        // activityLevelPicker setup
        activityLevelPicker.delegate = self
        activityLevelPicker.dataSource = self
        
        // Set Button Tags
        genderSegmentedControl.tag = 0
        birthdayButton.tag = 1
        heightButton.tag = 2
        weightButton.tag = 3
        activityLevelButton.tag = 4
        
        pickerSetup()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Date Picker Set up
        datePicker.frame = CGRect(x: 0, y: self.view.frame.maxY, width: self.view.frame.width, height: 200)
        let defaultDate = baseDateFormatter.date(from: "1980-01-01")
        datePicker.date = defaultDate!
        
        // Activity Level Picker Set up
        activityLevelPicker.frame = CGRect(x: 0, y: self.view.frame.maxY, width: self.view.frame.width, height: 200)
        
        // Height Picker Set up
        heightPicker.frame = CGRect(x: 0, y: self.view.frame.maxY, width: self.view.frame.width, height: 200)
        
        // Weight Picker Set up
        weightPicker.frame = CGRect(x: 0, y: self.view.frame.maxY, width: self.view.frame.width, height: 200)
        
        // Toolbar Set up
        toolBar.frame = CGRect(x: 0, y: self.view.frame.maxY, width: self.view.frame.width, height: 50)
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(closeToolBar))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(closeToolBar))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        
        self.view.addSubview(datePicker)
        self.view.addSubview(activityLevelPicker)
        self.view.addSubview(heightPicker)
        self.view.addSubview(weightPicker)
        self.view.addSubview(toolBar)
        
        setInitialValues()
    }

    
     // MARK: User Facing Button Functions
    /* Pressing the User Info Buttons*/

    @IBAction func genderButtonPressed(_ sender: Any) {
    }
    
    
    @IBAction func birthdayButtonPressed(_ sender: Any) {
        buttonID = birthdayButton.tag
        print("\(buttonID)")
        hideNextButton()
        datePicker.frame = CGRect(x: 0, y: self.view.frame.maxY - 200, width: self.view.frame.width, height: 200)
        toolBar.frame = CGRect(x: 0, y: self.view.frame.maxY - 250, width: self.view.frame.width, height: 50)
    }
    
    
    @IBAction func activityLevelButtonPressed(_ sender: Any) {
        buttonID = activityLevelButton.tag
        print("\(buttonID)")
        hideNextButton()
        activityLevelPicker.frame = CGRect(x: 0, y: self.view.frame.maxY - 200, width: self.view.frame.width, height: 200)
        toolBar.frame = CGRect(x: 0, y: self.view.frame.maxY - 250, width: self.view.frame.width, height: 50)
    }
    
    @IBAction func heightButtonPressed(_ sender: Any) {
        buttonID = heightButton.tag
        print("\(buttonID)")
        hideNextButton()
        print("\(heightData)")
        heightPicker.frame = CGRect(x: 0, y: self.view.frame.maxY - 200, width: self.view.frame.width, height: 200)
        toolBar.frame = CGRect(x: 0, y: self.view.frame.maxY - 250, width: self.view.frame.width, height: 50)
    }
    
    @IBAction func weightButtonPressed(_ sender: Any) {
        buttonID = weightButton.tag
        print("\(buttonID)")
        hideNextButton()
        print("\(weightData)")
        weightPicker.frame = CGRect(x: 0, y: self.view.frame.maxY - 200, width: self.view.frame.width, height: 200)
        toolBar.frame = CGRect(x: 0, y: self.view.frame.maxY - 250, width: self.view.frame.width, height: 50)
    }
    
    

    // MARK: Set Up Functions
    
    // Picker Set up
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView == activityLevelPicker {
            return 1
        } else {
            return 3
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == activityLevelPicker {
            return activityLevelSelections.count
        } else if pickerView == heightPicker {
            return heightData[component].count
        } else {
            return weightData[component].count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == activityLevelPicker {
            activityLevel = activityLevelSelections[row]
            return activityLevel
        } else if pickerView == heightPicker {
            return heightData[component][row]
            
        } else {
            return weightData[component][row]
            
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 35
    }

    
    // Set up all components of the UIPicker
    func pickerSetup() {
        
        var wholeNums = [String]()
        var fractionalNums = [String]()
        
        wholeNumsSetup(wholeNumsArray: &wholeNums)
        fractionalNumsSetup(fractionalNumsArray: &fractionalNums)
        
        heightData = [wholeNums,
                       fractionalNums,
                       heightUnits,
        ]
        
        weightData = [wholeNums,
                      fractionalNums,
                      weightUnits,
        ]
        
    }
    
    func wholeNumsSetup(wholeNumsArray: inout [String]) {
        var wholeNumsSetup = [Int]()
        
        wholeNumsSetup += 1...250
        let stringSetup = wholeNumsSetup.map { String($0) }
        wholeNumsArray.append("-")
        wholeNumsArray.append(contentsOf: stringSetup)
    }
    
    func fractionalNumsSetup(fractionalNumsArray: inout [String]) {
        let setUp = ["-","1/8","1/4","1/3","3/8","1/2","5/8","2/3","3/4","7/8"]
        fractionalNumsArray.append(contentsOf: setUp)
    }
    
    // Load weightPicker components in the right placement
    func setInitialWeightPicker() {
        let averageMaleWeightlbs = 220.0
        let averageFemaleWeightlbs = 180.0
        
        
        if genderSegmentedControl.selectedSegmentIndex == 0 {
            weight = averageMaleWeightlbs
        } else {
            weight = averageFemaleWeightlbs
        }
        print("weight: \(weight)")
        var wholeNum = Int(weight)
        var fractionalNum = weight - Double(wholeNum)
        var partialPickerPosition = 0
        
        convertValueToPartial(partialValue: &fractionalNum, partialPicker: &partialPickerPosition, wholeValue: &wholeNum)
        print("wholeNum: \(wholeNum)")
        print("fractionalNumb: \(fractionalNum)")
        
        weightPicker.selectRow(wholeNum, inComponent: 0, animated: false)
        weightPicker.selectRow(partialPickerPosition, inComponent: 1, animated: false)
    }

     // Load heightPicker components in the right placement
    func setInitialHeightPicker() {
        let averageMaleHeightCM = 175.4
        let averageFemaleHeightCM = 159.5
        

        if genderSegmentedControl.selectedSegmentIndex == 0 {
            height = averageMaleHeightCM
        } else {
            height = averageFemaleHeightCM
        }
        print("height: \(height)")
        var wholeNum = Int(height * cmToInchConversion)
        var fractionalNum = (height * cmToInchConversion) - Double(wholeNum)
        var partialPickerPosition = 0
        
        convertValueToPartial(partialValue: &fractionalNum, partialPicker: &partialPickerPosition, wholeValue: &wholeNum)
        print("wholeNum: \(wholeNum)")
        print("fractionalNumb: \(fractionalNum)")
        
        heightPicker.selectRow(wholeNum, inComponent: 0, animated: false)
        heightPicker.selectRow(partialPickerPosition, inComponent: 1, animated: false)
    }
    
    // Decimal Value to Partial Serving UIPicker conversion
    func convertValueToPartial(partialValue: inout Double, partialPicker: inout Int, wholeValue: inout Int) {
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
            wholeValue = wholeValue + 1
        default:
            print("not working")
        }
        
    }
    
    // Parital Serving UIPicker to Decimal conversion
    private func convertPartialServingPickerToValue(selection: Int, output: inout String) {
        switch selection {
        case 0:
            output = ""
        case 1:
            output = "1/8"
        case 2:
            output = "1/4"
        case 3:
            output = "1/3"
        case 4:
            output = "3/8"
        case 5:
            output = "1/2"
        case 6:
            output = "5/8"
        case 7:
            output = "2/3"
        case 8:
            output = "3/4"
        case 9:
            output = "7/8"
        default:
            output = ""
        }
    }
    
    

    // MARK: - User Experience Functions
    
    // Disable & Enabling Onboarding Progress
    func hideNextButton() {
        nextButton.isHidden = true
    }
    
    func showNextButton() {
        nextButton.isHidden = false
    }
    
    @objc func closeToolBar() {
        
        datePicker.frame = CGRect(x: 0, y: self.view.frame.maxY, width: self.view.frame.width, height: 200)
        
        activityLevelPicker.frame = CGRect(x: 0, y: self.view.frame.maxY, width: self.view.frame.width, height: 200)
        
        heightPicker.frame = CGRect(x: 0, y: self.view.frame.maxY, width: self.view.frame.width, height: 200)
        
        weightPicker.frame = CGRect(x: 0, y: self.view.frame.maxY, width: self.view.frame.width, height: 200)
        
        toolBar.frame = CGRect(x: 0, y: self.view.frame.maxY, width: self.view.frame.width, height: 50)
        
        
    
        updateLabel() // Will need to make it so that canceling the button doesn't update the labels, only saving does.
        showNextButton()
    }
    
    
    // Initial UI Setup
    func setInitialValues() {
        setInitialActivity()
//        setInitialHeightUnit()
        setInitialHeightPicker()
        setInitialWeightPicker()
    }
    
    func setInitialActivity() {
        activityLevelPicker.selectRow(2, inComponent: 0, animated: false)
    }
    
    func setInitialHeightUnit() {
        heightUnitsSegmentedControl.selectedSegmentIndex = 0
    }
    
    // Update Labels functions
    func updateLabel() {
        switch buttonID {
        case 1:
            birthday = baseDateFormatter.string(from: datePicker.date)
            birthdayButton.setTitle(dateFormatterUser.string(from: datePicker.date), for: .normal)
        case 2:
            let wholeNum = Int(height * cmToInchConversion)
            var fractionalNum = ""
            convertPartialServingPickerToValue(selection: heightPicker.selectedRow(inComponent: 1), output: &fractionalNum)

            print("whole num: \(wholeNum), fractional num: \(fractionalNum)")
            
            let heightValue = "\(wholeNum) \(fractionalNum)"
            heightButton.setTitle(heightValue, for: .normal)
        case 3:
            let wholeNum = Int(weight)
            var fractionalNum = ""
            convertPartialServingPickerToValue(selection: weightPicker.selectedRow(inComponent: 1), output: &fractionalNum)
            
            print("whole num: \(wholeNum), fractional num: \(fractionalNum)")
            
            let weightValue = "\(wholeNum) \(fractionalNum)"
            weightButton.setTitle(weightValue, for: .normal)
        case 4:
            activityLevelButton.setTitle(activityLevel, for: .normal)
        default:
            print("Error: Out of index range")
        }
    }
    
    
    
    
    // MARK: - Navigation

     // Segue to Onboarding Step 3
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     let onboarding3VC = segue.destination as! Onboarding3ViewController
        onboarding3VC.name = name!
        onboarding3VC.birthday = baseDateFormatter.string(from: datePicker.date)
        onboarding3VC.gender = genderSegmentedControl.selectedSegmentIndex
        onboarding3VC.activityLevel = activityLevel
        onboarding3VC.height = height
     }
 

}
