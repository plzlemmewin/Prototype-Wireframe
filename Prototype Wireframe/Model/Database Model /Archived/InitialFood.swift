//
//  InitialFood.swift
//  Prototype Wireframe
//
//  Created by MAC on 3/29/19.
//  Copyright © 2019 Jaime Lai. All rights reserved.
//

import Foundation

class InitialFood {
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
    let breakfast: Bool
    let lunch: Bool
    let dinner: Bool
    let snack: Bool
    let main: Bool
    let side: Bool
    let cuisine: String?
    var acceptedUnits = [InitialMeasurements]()
    
    init(idSetUp: Int, nameSetUp: String, brandSetUp: String? = nil, variantSetUp: String? = nil, cookedSetUp: String? = nil, defaultServingSetUp: Double, defaultUnitSetUp: String, caloriesPerBaseUnitSetUp: Double, fatsPerBaseUnitSetUp: Double, carbsPerBaseUnitSetUp: Double, proteinPerBaseUnitSetUp: Double, alcoholPerBaseUnitSetUp: Double, breakfastSetUp: Bool, lunchSetUp: Bool, dinnerSetUp: Bool, snackSetUp: Bool, mainSetUp: Bool, sideSetUp: Bool, cuisineSetUp: String? = nil, acceptedUnitsSetUp: [InitialMeasurements]) {
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
        breakfast = breakfastSetUp
        lunch = lunchSetUp
        dinner = dinnerSetUp
        snack = snackSetUp
        main = mainSetUp
        side = sideSetUp
        cuisine = cuisineSetUp
        acceptedUnits = acceptedUnitsSetUp
    }
}
