//
//  Food Item.swift
//  Prototype Wireframe
//
//  Created by MAC on 5/25/18.
//  Copyright © 2018 Jaime Lai. All rights reserved.
//

import UIKit

class FoodItem: NSObject {
    
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
    

    var meal: String
    var breakfast: Bool
    var lunch: Bool
    var dinner: Bool
    var snack: Bool
    
    var main: Bool
    var side: Bool
    
    var cuisine: String?
    
    
    init(name: String, brand: String?, variant: String?, cooked: String?, servingSize: String?, calories: Int, fats: Double, carbs: Double, protein: Double, alcohol: Double?, meal: String, breakfast: Bool, lunch: Bool, dinner: Bool, snack: Bool, main: Bool, side: Bool, cuisine: String?) {
        
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
        self.meal = meal
        self.breakfast = breakfast
        self.lunch = lunch
        self.dinner = dinner
        self.snack = snack
        self.main = main
        self.side = side
        self.cuisine = cuisine
        
        super.init()
    }
    
    
    
    
//    var identifier: String
//    var calories: Int
//    var servingSize: String
//    var meal: String
//
//    init(name: String, calories: Int, servingSize: String, meal: String) {
//        self.identifier = name
//        self.calories = calories
//        self.servingSize = servingSize
//        self.meal = meal
//
//
//        super.init()
//    }
    
//    convenience init(random: Bool = false) {
//        if random {
//            let foodArray = ["Chicken Drumstick", "Waffles", "Pancakes", "Beer", "McDouble", "Chicken Sandwich", "Energy Drink", "Caramel Macchiato"]
//            let descriptionArray = ["1 Large", "2", "100g", "tall", "16 fl oz"]
//            let mealArray = ["breakfast", "lunch", "dinner", "snacks"]
//
//            let randomFoodName = foodArray[Int(arc4random_uniform(UInt32(foodArray.count)))]
//            let randomDetails = descriptionArray[Int(arc4random_uniform(UInt32(descriptionArray.count)))]
//            let randomCalories = Int(arc4random_uniform(700))
//            let randomMeal = mealArray[Int(arc4random_uniform(UInt32(mealArray.count)))]
//
//            self.init(name: randomFoodName, calories: randomCalories, servingSize: randomDetails, meal: randomMeal)
//        } else {
//            self.init(name: "", calories: 0, servingSize: "", meal: "")
//        }
//    }
}
