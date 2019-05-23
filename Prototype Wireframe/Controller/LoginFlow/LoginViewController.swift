//
//  LoginViewController.swift
//  Prototype Wireframe
//
//  Created by MAC on 6/2/18.
//  Copyright © 2018 Jaime Lai. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire

class LoginViewController: UIViewController {
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Check if we are logged in on load
        if let data = UserDefaults.standard.data(forKey: "user") {
            didLogin(userData: data)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        SVProgressHUD.show()
        login(username: emailTextField.text!, password: passwordTextField.text!)
    }
    
    /*Login with username and password*/
    func login(username: String,password: String) {
        let params = ["username": username,"password": password] as [String:Any]
        Alamofire.request(API_HOST + "/login", method: .post, parameters: params).responseData
            { response in switch response.result {
            case .success(let data):
                switch response.response?.statusCode ?? -1 {
                case 200:
                    SVProgressHUD.dismiss()
                    self.didLogin(userData: data)
                case 401:
                    SVProgressHUD.dismiss()
                    Helper.showAlert(viewController: self, title: "Oops", message: "Username or Password Incorrect")
                default:
                    SVProgressHUD.dismiss()
                    Helper.showAlert(viewController: self, title: "Oops", message: "Unexpected Error")
                }
            case .failure(let error):
                Helper.showAlert(viewController: self,title: "Oops!",message: error.localizedDescription)
                }
        }
    }
    
    func didLogin(userData: Data) {
        do {
            //decode data into user object
            User.current = try JSONDecoder().decode(User.self, from: userData)
            emailTextField.text = ""
            passwordTextField.text = ""
            self.view.endEditing(false)
            self.performSegue(withIdentifier: "goToMain", sender: self)
        } catch {
            Helper.showAlert(viewController: self,title: "Oops!",message: error.localizedDescription)
        }
    }
    
}
