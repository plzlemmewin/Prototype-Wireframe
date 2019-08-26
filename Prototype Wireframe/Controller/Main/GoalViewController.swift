//
//  ViewController.swift
//  Prototype Wireframe
//
//  Created by MAC on 4/22/18.
//  Copyright © 2018 Jaime Lai. All rights reserved.
//

import UIKit

class GoalViewController: UIViewController {
    
    var pageViewController: UIPageViewController!
    
    
    @IBOutlet weak var summaryLabel: UILabel!
    
    let chartNameArray = ["Weight","Macronutrients","Calories by Category"]
    
    let personalTrainerComment = [
    "Great job! You've managed to ",
    "",
    "You're diet"]
    
    @IBOutlet weak var chartLabel: UILabel!
    
    @IBOutlet weak var startValue: UILabel!
    @IBOutlet weak var currentValue: UILabel!
    @IBOutlet weak var goalValue: UILabel!
    
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var currentLabel: UILabel!
    @IBOutlet weak var goalLabel: UILabel!
    
    @IBOutlet weak var chartName: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("\(User.current!)")
        print("\(User.current.id)")
        print("\(User.current.username)")

    }
    
    
    func updateData() {
        chartLabel.text = chartNameArray[0]
        summaryLabel.text = personalTrainerComment[0]
    }
    
    /*Load User Data*/
//    func loadData() {
//        let params = ["username": username,"password": password] as [String:Any]
//        Alamofire.request(API_HOST + "/login", method: .post, parameters: params).responseData
//            { response in switch response.result {
//            case .success(let data):
//                switch response.response?.statusCode ?? -1 {
//                case 200:
//                    SVProgressHUD.dismiss()
//                    self.didLogin(userData: data)
//                case 401:
//                    SVProgressHUD.dismiss()
//                    Helper.showAlert(viewController: self, title: "Oops", message: "Username or Password Incorrect")
//                default:
//                    SVProgressHUD.dismiss()
//                    Helper.showAlert(viewController: self, title: "Oops", message: "Unexpected Error")
//                }
//            case .failure(let error):
//                Helper.showAlert(viewController: self,title: "Oops!",message: error.localizedDescription)
//                }
//        }
//    }

    
    @IBAction func goalInfoPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "goalStats", sender: self)
    }

    @IBAction func goalSelectionPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "goalSelection", sender: self)
    }
    
    @IBAction func unwindToGoalVC(segue: UIStoryboardSegue) {
        
    }
    
    
}

