//
//  Food.swift
//  Prototype Wireframe
//
//  Created by MAC on 6/6/18.
//  Copyright © 2018 Jaime Lai. All rights reserved.
//

import UIKit

class Food: NSObject {
    var identifier: String
    var brand: String?
    var variant: String?
    var cooked: String?
    
    var servingSize: String?
    var calories: Int
    var fats: Double
    var carbs: Double
    var protein: Double
    var alcohol: Double?
    
    var timing: String?
    var breakfast: Bool
    var lunch: Bool
    var dinner: Bool
    var snack: Bool
    
    var main: Bool
    var side: Bool
    
    var cuisine: String?
    
    
    init(name: String, brand: String?, variant: String?, cooked: String?, servingSize: String?, calories: Int, fats: Double, carbs: Double, protein: Double, alcohol: Double?, timing: String?, breakfast: Bool, lunch: Bool, dinner: Bool, snack: Bool, main: Bool, side: Bool, cuisine: String?) {
        
        self.identifier = name
        self.brand = brand
        self.variant = variant
        self.cooked = cooked
        self.servingSize = servingSize
        self.calories = calories
        self.fats = fats
        self.carbs = carbs
        self.protein = protein
        self.alcohol = alcohol
        self.timing = timing
        self.breakfast = breakfast
        self.lunch = lunch
        self.dinner = dinner
        self.snack = snack
        self.main = main
        self.side = side
        self.cuisine = cuisine
        
        super.init()
    }
}
