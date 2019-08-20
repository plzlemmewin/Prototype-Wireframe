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
    let profileURL = API_HOST + "/profile"
    let activityLevelSelection = ["Sedentary", "Slightly Active", "Moderately Active", "Very Active", "Extremely Active"]
//    var gender: String?
//    var birthday: String?
//    var height: Double?
//    var activityLevel: String?
    
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
    }
    
    //MARK: Loading Data
    func loadData() {
        let params: [String: Any] = ["user": User.current.username]
        
        Alamofire.request(profileURL, method: .get, parameters: params).responseJSON {
            response in
            if response.result.isSuccess {
                let responseJSON: JSON  = JSON(response.result.value!)[0]
                print("\(responseJSON)")
                
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
    @IBAction func birthdayButtonPressed(_ sender: Any) {
        loadData()
    }
    
    //MARK: User-facing Methods
    func updateLabels(height: Double, gender: String, birthday: String, activityLevel: String) {
        switch gender {
        case "male":
            genderSegmentedControl.selectedSegmentIndex = 0
        case "female":
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
