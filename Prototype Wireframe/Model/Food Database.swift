//
//  Food Database.swift
//  Prototype Wireframe
//
//  Created by MAC on 5/25/18.
//  Copyright © 2018 Jaime Lai. All rights reserved.
//

import UIKit

class FoodDatabase {
    
    var foodList = [FoodItem]()
    
    @discardableResult func createFood() -> FoodItem {
        let newItem = FoodItem(random: true)
        foodList.append(newItem)
        
        return newItem
    }
    
    init() {
        for _ in 0..<20 {
            createFood()
        }
    }

}
