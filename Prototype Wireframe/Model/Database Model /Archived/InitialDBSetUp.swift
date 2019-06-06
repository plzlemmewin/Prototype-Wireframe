//
//  InitialDBSetUp.swift
//  Prototype Wireframe
//
//  Created by MAC on 3/29/19.
//  Copyright © 2019 Jaime Lai. All rights reserved.
//

import Foundation

class InitialDBSetUp {
    
    var foodList = [InitialFood]()
    
    init() {
        
        var butterMeasurements = [InitialMeasurements]()
        butterMeasurements.append(InitialMeasurements(id: 1001, unitName: "pat", baseUnits: 5))
        butterMeasurements.append(InitialMeasurements(id: 1001, unitName: "tbsp", baseUnits: 14))
        butterMeasurements.append(InitialMeasurements(id: 1001, unitName: "stick", baseUnits: 113))
        butterMeasurements.append(InitialMeasurements(id: 1001, unitName: "cup", baseUnits: 227))
        
        var friedEggMeasurements = [InitialMeasurements]()
        friedEggMeasurements.append(InitialMeasurements(id: 1128, unitName: "large", baseUnits: 46))
        
        var appleJuiceMeasurements = [InitialMeasurements]()
        appleJuiceMeasurements.append(InitialMeasurements(id: 9016, unitName: "cup", baseUnits: 248))
        appleJuiceMeasurements.append(InitialMeasurements(id: 9016, unitName: "fl oz", baseUnits: 31))
        appleJuiceMeasurements.append(InitialMeasurements(id: 9016, unitName: "drink box", baseUnits: 262))
        
        foodList.append(InitialFood(idSetUp: 1001, nameSetUp: "Butter", variantSetUp: "salted", defaultServingSetUp: 1, defaultUnitSetUp: "pat", caloriesPerBaseUnitSetUp: 7.17, fatsPerBaseUnitSetUp: 0.8111, carbsPerBaseUnitSetUp: 0.0006, proteinPerBaseUnitSetUp: 0.0085, alcoholPerBaseUnitSetUp: 0, breakfastSetUp: false, lunchSetUp: false, dinnerSetUp: false, snackSetUp: false, mainSetUp: false, sideSetUp: false, acceptedUnitsSetUp: butterMeasurements))
        foodList.append(InitialFood(idSetUp: 1128, nameSetUp: "Fried Egg", defaultServingSetUp: 1, defaultUnitSetUp: "large", caloriesPerBaseUnitSetUp: 1.96, fatsPerBaseUnitSetUp: 0.1484, carbsPerBaseUnitSetUp: 0.00083, proteinPerBaseUnitSetUp: 0.1361, alcoholPerBaseUnitSetUp: 0, breakfastSetUp: false, lunchSetUp: false, dinnerSetUp: false, snackSetUp: false, mainSetUp: false, sideSetUp: false, acceptedUnitsSetUp: friedEggMeasurements))
        foodList.append(InitialFood(idSetUp: 1128, nameSetUp: "Apple Juice", variantSetUp: "unsweetened", defaultServingSetUp: 1, defaultUnitSetUp: "cup", caloriesPerBaseUnitSetUp: 0.32, fatsPerBaseUnitSetUp: 0.003, carbsPerBaseUnitSetUp: 0.0769, proteinPerBaseUnitSetUp: 0.004, alcoholPerBaseUnitSetUp: 0, breakfastSetUp: false, lunchSetUp: false, dinnerSetUp: false, snackSetUp: false, mainSetUp: false, sideSetUp: false, acceptedUnitsSetUp: appleJuiceMeasurements))
    }
    
}
