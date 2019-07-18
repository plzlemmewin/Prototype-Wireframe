//
//  RecommendationViewController.swift
//  Prototype Wireframe
//
//  Created by MAC on 6/21/19.
//  Copyright © 2019 Jaime Lai. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class RecommendationViewController: UIViewController {
    
    //MARK: Variables & Constants
    let recommendationURL = API_HOST + "/my-recommendations/"
    var recommendations = [String]()
    @IBOutlet weak var textRecommendationTextField: UITextView!
    
    @IBAction func requestButton(_ sender: Any) {
        getRecommendation()
    }
    
    func getRecommendation() {
        
        let url = recommendationURL
        let params: [String: Any] = ["user": User.current.username]
        print(params)
        
        Alamofire.request(url, method: .get, parameters: params).responseJSON {
            response in
            if response.result.isSuccess {
                let responseJSON: JSON  = JSON(response.result.value!)
                print("\(responseJSON)")
                for (_, obj) in responseJSON {
                    let text = obj["text_eng"].stringValue
                    self.recommendations.append(text)
                }
                self.textRecommendationTextField.text = self.recommendations[0]
            }
        }
    }
}
