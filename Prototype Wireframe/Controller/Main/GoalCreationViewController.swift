//
//  GoalCreationViewController.swift
//  Prototype Wireframe
//
//  Created by MAC on 8/26/19.
//  Copyright © 2019 Jaime Lai. All rights reserved.
//

import UIKit

class GoalCreationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func startGoalPressed(_ sender: Any) {
        performSegue(withIdentifier: "unwindToGoalVC", sender: self)
    }
    
}
