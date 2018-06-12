//
//  FoodData.swift
//  Prototype Wireframe
//
//  Created by MAC on 6/6/18.
//  Copyright © 2018 Jaime Lai. All rights reserved.
//

import UIKit

class FoodDatabase {
    
    var foodList = [Food]()
    
    init() {
        let entry = Food(name: "Bud Light", brand: "Budweiser", variant: nil, cooked: nil, servingSize: "1 bottle", calories: 110, fats: 0, carbs: 6.6, protein: 0, alcohol: nil, timing: nil, breakfast: false, lunch: false, dinner: false, snack: false, main: false, side: false, cuisine: nil)
        foodList.append(entry)
        foodList.append(Food(name: "Dinner Roll", brand: "Andrea's Gluten-Free", variant: nil, cooked: nil, servingSize: "1 roll", calories: 130, fats: 3.5, carbs: 20, protein: 3, alcohol: nil, timing: nil, breakfast: false, lunch: true, dinner: true, snack: true, main: false, side: true, cuisine: nil))
        foodList.append(Food(name: "McDouble", brand: "McDonald's", variant: nil, cooked: nil, servingSize: "1 sandwich", calories: 380, fats: 18, carbs: 34, protein: 23, alcohol: nil, timing: nil, breakfast: false, lunch: true, dinner: true, snack: true, main: true, side: true, cuisine: "American"))
        foodList.append(Food(name:"Chicken Thigh", brand: nil, variant: "w/out skin", cooked: "Roasted", servingSize: "1 medium", calories: 236, fats: 12.3, carbs: 0, protein: 29.3, alcohol: nil, timing: nil, breakfast: false, lunch: true, dinner: true, snack: true, main: true, side: true, cuisine: nil))
        foodList.append(Food(name: "Chicken Thigh", brand: nil, variant: nil, cooked: "Raw", servingSize: "1 medium", calories: 211, fats: 15.3, carbs: 0, protein: 17.3, alcohol: nil, timing: nil, breakfast: false, lunch: true, dinner: true, snack: true, main: true, side: true, cuisine: nil))
        foodList.append(Food(name: "Red Delicious Apple", brand: nil, variant: nil, cooked: nil, servingSize: "1 medium", calories: 80, fats: 0, carbs: 19.5, protein: 0.5, alcohol: nil, timing: nil, breakfast: false, lunch: false, dinner: false, snack: true, main: false, side: true, cuisine: nil))
        foodList.append(Food(name: "Granny Smith Apple", brand: nil, variant: nil, cooked: nil, servingSize: "1 medium", calories: 72, fats: 0, carbs: 17.5, protein: 0.5, alcohol: nil, timing: nil, breakfast: false, lunch: false, dinner: false, snack: true, main: false, side: true, cuisine: nil))
        foodList.append(Food(name: "Double Crunch Shrimp", brand: "Applebee's", variant: nil, cooked: nil, servingSize: "1", calories: 524, fats: 30, carbs: 38, protein: 23, alcohol: nil, timing: nil, breakfast: false, lunch: true, dinner: true, snack: false, main: true, side: false, cuisine: "American"))
        foodList.append(Food(name: "Rice", brand: nil, variant: "white", cooked: nil, servingSize: "150 g", calories: 206, fats: 0.4, carbs: 45, protein: 4.3, alcohol: nil, timing: nil, breakfast: true, lunch: true, dinner: true, snack: true, main: false, side: true, cuisine: nil))
        foodList.append(Food(name: "Rice", brand: nil, variant: "brown", cooked: nil, servingSize: "150 g", calories: 216, fats: 1.8, carbs: 45, protein: 5, alcohol: nil, timing: nil, breakfast: true, lunch: true, dinner: true, snack: true, main: false, side: true, cuisine: nil))
        foodList.append(Food(name: "Chicken Nuggets", brand: "Tyson", variant: nil, cooked: nil, servingSize: "5 pieces", calories: 170, fats: 9, carbs: 10, protein: 13, alcohol: nil, timing: nil, breakfast: false, lunch: true, dinner: true, snack: true, main: false, side: true, cuisine: "American"))
    }
}
