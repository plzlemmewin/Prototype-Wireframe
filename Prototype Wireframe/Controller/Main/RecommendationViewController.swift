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
    let placeholderMessage = "We don't have any recommendations for you at the moment. Check in again later!"
    
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
                if responseJSON.isEmpty {
                    print("Empty Response")
                    DispatchQueue.main.async {
                        self.textRecommendationTextField.text = self.placeholderMessage
                    }
                } else {
                    for (_, obj) in responseJSON {
                    let text = obj["text_eng"].stringValue
                    self.recommendations.append(text)
                    }
                }
                // Need to handle empty response
                self.updateLabels()
            } else {
                print("Error")
            }
        }
    }
    
    func updateLabels() {
        if self.recommendations.isEmpty {
            self.textRecommendationTextField.text = self.placeholderMessage
        } else {
            self.textRecommendationTextField.text = self.recommendations[0]
        }
    }
    
}

