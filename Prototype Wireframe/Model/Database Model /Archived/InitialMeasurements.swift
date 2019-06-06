//
//  InitialMeasurements.swift
//  Prototype Wireframe
//
//  Created by MAC on 3/29/19.
//  Copyright © 2019 Jaime Lai. All rights reserved.
//

import Foundation

class InitialMeasurements {
    
    let foodId: Int
    let unit: String
    let conversionToBaseUnit: Double
    
    init(id: Int, unitName: String, baseUnits: Double) {
        foodId = id
        unit = unitName
        conversionToBaseUnit = baseUnits
    }
}
