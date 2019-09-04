//
//  SettingsViewController.swift
//  Prototype Wireframe
//
//  Created by MAC on 8/19/19.
//  Copyright © 2019 Jaime Lai. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SettingsViewController: UIViewController {
    //MARK: Variables & Constants
    var id: Int = 0
    let profileURL = API_HOST + "/profile"
    let activityLevelSelection = ["Sedentary", "Slightly Active", "Moderately Active", "Very Active", "Extremely Active"]
//    var gender: String?
//    var birthday: String?
//    var height: Double?
//    var activityLevel: String?
    let datePicker: UIDatePicker = {
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
    
    @IBOutlet weak var birthdayButton: UIButton!
    @IBOutlet weak var heightButton: UIButton!
    @IBOutlet weak var activityLevelButton: UIButton!
    @IBOutlet weak var genderSegmentedControl: UISegmentedControl!
    
    // Used for networking calls
    let baseDateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        return df
    }()
    
    //MARK: View Loading & Appearing
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        datePicker.frame = CGRect(x: 0, y: self.view.frame.maxY - self.tabBarController!.tabBar.frame.size.height, width: self.view.frame.width, height: 200)
        let defaultDate = baseDateFormatter.date(from: "1980-01-01")
        datePicker.date = defaultDate!
        
        // Toolbar Set up
        toolBar.frame = CGRect(x: 0, y: self.view.frame.maxY - self.tabBarController!.tabBar.frame.size.height, width: self.view.frame.width, height: 50)
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.dateModified))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(closeDatePicker))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        
        self.view.addSubview(datePicker)
        self.view.addSubview(toolBar)
    }
    
    //MARK: Loading Data
    func loadData() {
        let params: [String: Any] = ["user": User.current.username]
        
        Alamofire.request(profileURL, method: .get, parameters: params).responseJSON {
            response in
            if response.result.isSuccess {
                let responseJSON: JSON  = JSON(response.result.value!)[0]
                print("\(responseJSON)")
                
                self.id = responseJSON["user_id"].intValue
                let height = responseJSON["height"].doubleValue
                let gender  = responseJSON["gender"].stringValue
                let birthday = responseJSON["birthday"].stringValue
                let activityLevel = responseJSON["activity_level"].stringValue
                
                DispatchQueue.main.async {
                    self.updateLabels(height: height, gender: gender, birthday: birthday, activityLevel: activityLevel)
                }
                
            } else {
                print("Error")
            }
        }
        
    }
    
    //MARK: Setting Modification Methods
    @IBAction func genderButtonPressed(_ sender: Any) {
        if let gender = genderSegmentedControl.titleForSegment(at: genderSegmentedControl.selectedSegmentIndex) {
            let params: [String: Any] = ["user": User.current.username, "gender": gender]
            let url = profileURL + "/\(id)/"
            
            Alamofire.request(url, method: .patch, parameters: params).responseJSON {
                response in
                if response.result.isSuccess {
                    let responseJSON: JSON  = JSON(response.result.value!)
                    print(responseJSON)
                    print("process complete")
                } else {
                    print("Error")
                }
            }
        }
    }
    
    @IBAction func birthdayButtonPressed(_ sender: Any) {
        
        datePicker.frame = CGRect(x: 0, y: self.view.frame.maxY - 200 - self.tabBarController!.tabBar.frame.size.height, width: self.view.frame.width, height: 200)
        toolBar.frame = CGRect(x: 0, y: self.view.frame.maxY - 250 - self.tabBarController!.tabBar.frame.size.height, width: self.view.frame.width, height: 50)
        
    }
    
    @objc func dateModified(_ sender: Any) {
        let birthday = baseDateFormatter.string(from: datePicker.date)
        let params: [String: Any] = ["user": User.current.username, "birthday": birthday]
        let url = profileURL + "/\(id)/"
        
        Alamofire.request(url, method: .patch, parameters: params).responseJSON {
            response in
            if response.result.isSuccess {
                DispatchQueue.main.async {
                    self.birthdayButton.setTitle(birthday, for: .normal)
                }
            } else {
                print("Error")
            }
        }
        closeDatePicker()
    }
    
    @objc func closeDatePicker() {
        datePicker.frame = CGRect(x: 0, y: self.view.frame.maxY - self.tabBarController!.tabBar.frame.size.height, width: self.view.frame.width, height: 200)
        
        toolBar.frame = CGRect(x: 0, y: self.view.frame.maxY - self.tabBarController!.tabBar.frame.size.height, width: self.view.frame.width, height: 50)
    }
    
    
    @IBAction func heightButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func activityLevelButtonPressed(_ sender: Any) {
        
    }
    
    
    //MARK: User-facing Methods
    func updateLabels(height: Double, gender: String, birthday: String, activityLevel: String) {
        switch gender {
        case "Male":
            genderSegmentedControl.selectedSegmentIndex = 0
        case "Female":
            genderSegmentedControl.selectedSegmentIndex = 1
        default:
            print("Error: Out of index range")
            genderSegmentedControl.selectedSegmentIndex = 0
            genderSegmentedControl.tintColor = UIColor.darkGray
        }
        birthdayButton.setTitle(birthday, for: .normal)
        heightButton.setTitle(String(height), for: .normal)
        activityLevelButton.setTitle(activityLevel, for: .normal)
    }
    
}

