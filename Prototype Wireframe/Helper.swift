//
//  Helper.swift
//  Prototype Wireframe
//
//  Created by MAC on 5/22/19.
//  Copyright © 2019 Jaime Lai. All rights reserved.
//

import Foundation
import UIKit

class Helper {
    static func showAlert(viewController: UIViewController,title: String?,message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        alert.addAction(dismiss)
        viewController.present(alert, animated: true, completion: nil)
    }
}
