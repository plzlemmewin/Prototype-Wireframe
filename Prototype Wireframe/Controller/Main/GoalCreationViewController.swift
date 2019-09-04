//
//  GoalCreationViewController.swift
//  Prototype Wireframe
//
//  Created by MAC on 8/26/19.
//  Copyright © 2019 Jaime Lai. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class GoalCreationViewController: UIViewController {
    //MARK: Variables & Constants
    let goalURL = API_HOST + "/goal"
    let rateOfProgressSelection = ["Aggressive", "Moderate", "Slow"]
    let todaysDate = Date()
    let lbsInKG: Double = 2.20462

    let picker: UIDatePicker = {
        let pk = UIDatePicker()
        pk.datePickerMode = .date
        return pk
    }()
    
    let toolBar: UIToolbar = {
        let tb = UIToolbar()
        tb.barStyle = .default
        tb.isUserInteractionEnabled = true
        return tb
    }()
    
    @IBOutlet weak var targetDateButton: UIButton!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var startingWeightButton: UIButton!
    @IBOutlet weak var targetWeightButton: UIButton!
    @IBOutlet weak var rateOfProgressButton: UIButton!
    
    
    // Used for networking calls
    let baseDateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        return df
    }()
    
    //MARK: View Loading & Appearing
    override func viewDidLoad() {
        super.viewDidLoad()
    

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let formattedTodaysDate = baseDateFormatter.string(from: todaysDate)
        startDateLabel.text = formattedTodaysDate
        
        picker.frame = CGRect(x: 0, y: self.view.frame.maxY, width: self.view.frame.width, height: 200)
        let defaultDate = baseDateFormatter.date(from: "1980-01-01")
        picker.date = defaultDate!
        
        // Toolbar Set up
        toolBar.frame = CGRect(x: 0, y: self.view.frame.maxY, width: self.view.frame.width, height: 50)
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.dateModified))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(closeDatePicker))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        
        self.view.addSubview(picker)
        self.view.addSubview(toolBar)
    }
    
    @IBAction func dateButtonPressed(_ sender: Any) {
        picker.frame = CGRect(x: 0, y: self.view.frame.maxY - 200, width: self.view.frame.width, height: 200)
        toolBar.frame = CGRect(x: 0, y: self.view.frame.maxY - 250, width: self.view.frame.width, height: 50)
    }
    
    
    @objc func dateModified(_ sender: Any) {
        let birthday = baseDateFormatter.string(from: picker.date)
        
        DispatchQueue.main.async {
            self.targetDateButton.setTitle(birthday, for: .normal)
        }
        
        closeDatePicker()
    }
    
    @objc func closeDatePicker() {
        picker.frame = CGRect(x: 0, y: self.view.frame.maxY, width: self.view.frame.width, height: 200)
        
        toolBar.frame = CGRect(x: 0, y: self.view.frame.maxY, width: self.view.frame.width, height: 50)
    }

    
    
    @IBAction func rateOfProgressPressed(_ sender: Any) {
        
        
    }
    
    
    
    

    // MARK: - Navigation
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func startGoalPressed(_ sender: Any) {
        let date = Date()
        let targetDate = /*baseDateFormatter.string(from: picker.date)*/ baseDateFormatter.string(from: date)
        let goalType = 1
        let startingWeight = 200.0 / lbsInKG
        let targetWeight = 150.0 / lbsInKG
        let progression = "moderate"
        let params: [String: Any] = ["user": User.current.username, "goal_id": goalType, "target_date": targetDate, "starting_weight": startingWeight, "target_weight": targetWeight, "progression": progression]
        let url = goalURL + "/"
        
        Alamofire.request(url, method: .post, parameters: params).responseJSON {
            response in
            if response.result.isSuccess {
                print("Successfully created new goal!")
            } else {
                print("Error")
            }
        }
        
        performSegue(withIdentifier: "unwindToGoalVC", sender: self)
    }
    
    
    
}
