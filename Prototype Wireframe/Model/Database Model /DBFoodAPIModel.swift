//
//  DBFoodAPIModel.swift
//  Prototype Wireframe
//
//  Created by MAC on 6/3/19.
//  Copyright © 2019 Jaime Lai. All rights reserved.
//

import Foundation

class DBFoodAPIModel: NSObject {
    let id: Int
    let name: String
    let brand: String?
    let variant: String?
    let cooked: String?
    let defaultServing: Double
    let defaultUnit: String
    let caloriesPerBaseUnit: Double
    let fatsPerBaseUnit: Double
    let carbsPerBaseUnit: Double
    let proteinPerBaseUnit: Double
    let alcoholPerBaseUnit: Double
    var units: [Unit]
    
    init(idSetUp: Int, nameSetUp: String, brandSetUp: String? = nil, variantSetUp: String? = nil, cookedSetUp: String? = nil, defaultServingSetUp: Double, defaultUnitSetUp: String, caloriesPerBaseUnitSetUp: Double, fatsPerBaseUnitSetUp: Double, carbsPerBaseUnitSetUp: Double, proteinPerBaseUnitSetUp: Double, alcoholPerBaseUnitSetUp: Double, supportedUnits: [Unit]) {
        
        id = idSetUp
        name = nameSetUp
        brand = brandSetUp
        variant = variantSetUp
        cooked = cookedSetUp
        defaultServing = defaultServingSetUp
        defaultUnit = defaultUnitSetUp
        caloriesPerBaseUnit = caloriesPerBaseUnitSetUp
        fatsPerBaseUnit = fatsPerBaseUnitSetUp
        carbsPerBaseUnit = carbsPerBaseUnitSetUp
        proteinPerBaseUnit = proteinPerBaseUnitSetUp
        alcoholPerBaseUnit = alcoholPerBaseUnitSetUp
        units = supportedUnits
        
        super.init()
        
    }
    
}
