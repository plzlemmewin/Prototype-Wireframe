//
//  Onboarding5ViewController.swift
//  Prototype Wireframe
//
//  Created by MAC on 10/2/20.
//  Copyright © 2020 Jaime Lai. All rights reserved.
//

import UIKit

class Onboarding5ViewController: UIViewController {
    
    var name: String?
    var gender: Int?
    var birthday: String?
    var activityLevel: String?
    var height: Double?
    var goal: Int?
    var progressRate: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let registerVC = segue.destination as! RegisterViewController
        registerVC.name = name!
        registerVC.birthday = birthday
        registerVC.gender = gender
        registerVC.activityLevel = activityLevel
        registerVC.height = height
        registerVC.goal = goal
        registerVC.progressRate = progressRate
    }

}
