//
//  UnitAPIModel.swift
//  Prototype Wireframe
//
//  Created by MAC on 6/3/19.
//  Copyright © 2019 Jaime Lai. All rights reserved.
//

import Foundation

class Unit: NSObject {

    let unit: String
    let conversionToBaseUnit: Double
    
    init(unitName: String, baseUnits: Double) {

        unit = unitName
        conversionToBaseUnit = baseUnits
        
        super.init()
    }
    
}
