//
//  UserFoodAPIModel.swift
//  Prototype Wireframe
//
//  Created by MAC on 6/4/19.
//  Copyright © 2019 Jaime Lai. All rights reserved.
//

import Foundation

class UserFoodAPIModel: NSObject {
    
    let pk: Int
    let id: Int
    let name: String
    let brand: String?
    let variant: String?
    let cooked: String?
    let servingSize: Double
    let unit: String
    let calories: Double
    let fats: Double
    let carbs: Double
    let protein: Double
    let alcohol: Double
    let timing: String
    
    init(pkSetup: Int, idSetUp: Int, nameSetUp: String, brandSetUp: String? = nil, variantSetUp: String? = nil, cookedSetUp: String? = nil, servingSizeSetUp: Double, unitSetUp: String, caloriesSetUp: Double, fatsSetUp: Double, carbsSetUp: Double, proteinSetUp: Double, alcoholSetUp: Double, timingSetUp: String) {
        
        pk = pkSetup
        id = idSetUp
        name = nameSetUp
        brand = brandSetUp
        variant = variantSetUp
        cooked = cookedSetUp
        servingSize = servingSizeSetUp
        unit = unitSetUp
        calories = caloriesSetUp
        fats = fatsSetUp
        carbs = carbsSetUp
        protein = proteinSetUp
        alcohol = alcoholSetUp
        timing = timingSetUp
        
        super.init()
        
    }
    
    
    
    
}
