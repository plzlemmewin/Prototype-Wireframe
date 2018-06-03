//
//  LoginViewController.swift
//  Prototype Wireframe
//
//  Created by MAC on 6/2/18.
//  Copyright © 2018 Jaime Lai. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class LoginViewController: UIViewController {
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        
        SVProgressHUD.show()
        
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if error != nil {
                print(error!)
                SVProgressHUD.dismiss()
                
                let alert = UIAlertController(title: "Login Failed", message: "Login Unsucessful", preferredStyle: .alert)
                let ok = UIAlertAction(title: "Try Again", style: .default, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
                
            } else {
                print("Login successful!")
                
                SVProgressHUD.dismiss()
                self.performSegue(withIdentifier: "goToMain", sender: self)
            }
        }
    }
    
}
