//
//  DBFood.swift
//  
//
//  Created by MAC on 12/4/18.
//

import Foundation
import RealmSwift

class Food: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var brand: String? = ""
    @objc dynamic var variant: String? = ""
    @objc dynamic var cooked: String? = ""
    @objc dynamic var defaultServing: Double = 0
    @objc dynamic var defaultUnit: String = ""
    @objc dynamic var caloriesPerBaseUnit: Double = 0
    @objc dynamic var fatsPerBaseUnit: Double = 0
    @objc dynamic var carsPerBaseUnit: Double = 0
    @objc dynamic var proteinPerBaseUnit: Double = 0
    @objc dynamic var alcoholPerBaseUnit: Double = 0
    @objc dynamic var breakfast = false
    @objc dynamic var lunch = false
    @objc dynamic var dinner = false
    @objc dynamic var snack = false
    @objc dynamic var main = false
    @objc dynamic var side = false
    @objc dynamic var cuisine: String = ""
    let acceptedUnits = List<UnitofMeasure>()
}
