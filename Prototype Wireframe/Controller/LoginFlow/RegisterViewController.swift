//
//  RegisterViewController.swift
//  Prototype Wireframe
//
//  Created by MAC on 6/2/18.
//  Copyright © 2018 Jaime Lai. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire

class RegisterViewController: UIViewController {
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func registerPressed(_ sender: AnyObject) {
        SVProgressHUD.show()
        signUp(username: emailTextField.text!, password: passwordTextField.text!)
    }
    
    /*Signup with username and password*/
    func signUp(username: String, password: String) {
        let params = ["username": username, "password": password] as [String:Any]
        Alamofire.request(API_HOST + "/signup", method: .post, parameters: params).responseData
            { response in switch response.result {
            case .success(let data):
                switch response.response?.statusCode ?? -1 {
                case 200:
                    do {
                        User.current = try JSONDecoder().decode(User.self, from: data)
                        self.emailTextField.text = ""
                        self.passwordTextField.text = ""
                        SVProgressHUD.dismiss()
                        self.performSegue(withIdentifier: "goToMain", sender: nil)
                    } catch {
                        SVProgressHUD.dismiss()
                        Helper.showAlert(viewController: self,title: "Oops!",message: error.localizedDescription)
                    }
                case 401:
                    SVProgressHUD.dismiss()
                    Helper.showAlert(viewController: self, title: "Oops", message: "Username Taken")
                default:
                    SVProgressHUD.dismiss()
                    Helper.showAlert(viewController: self, title: "Oops", message: "Unexpected Error")
                }
            case .failure(let error):
                SVProgressHUD.dismiss()
                Helper.showAlert(viewController: self,title: "Oops!",message: error.localizedDescription)
                }
        }
    }
    
    
}

