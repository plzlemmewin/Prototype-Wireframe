//
//  GoalSelectionViewController.swift
//  Prototype Wireframe
//
//  Created by MAC on 8/26/19.
//  Copyright © 2019 Jaime Lai. All rights reserved.
//

import UIKit

class GoalSelectionViewController: UIViewController {

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
    @IBAction func newGoalPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "goalCreation", sender: self)
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
