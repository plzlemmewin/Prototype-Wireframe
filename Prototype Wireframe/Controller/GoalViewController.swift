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

        updateData()
    }
    
    func updateData() {
        chartLabel.text = chartNameArray[0]
        summaryLabel.text = personalTrainerComment[0]
    }

}

