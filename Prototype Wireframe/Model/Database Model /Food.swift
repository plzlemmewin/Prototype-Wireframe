//
//  Food.swift
//  Prototype Wireframe
//
//  Created by MAC on 12/4/18.
//  Copyright © 2018 Jaime Lai. All rights reserved.
//

import Foundation
import RealmSwift

class Food: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var brand: String? = ""
    @objc dynamic var variant: String? = ""
    @objc dynamic var cooked: String? = ""
    @objc dynamic var servingSize: Double = 0
    @objc dynamic var unit: String = ""
    @objc dynamic var calories: Double = 0
    @objc dynamic var fats: Double = 0
    @objc dynamic var carbs: Double = 0
    @objc dynamic var protein: Double = 0
    @objc dynamic var alcohol: Double = 0
    @objc dynamic var timing: String = ""
}
