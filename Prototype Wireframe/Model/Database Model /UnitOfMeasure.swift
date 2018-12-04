//
//  UnitOfMeasure.swift
//  Prototype Wireframe
//
//  Created by MAC on 12/4/18.
//  Copyright © 2018 Jaime Lai. All rights reserved.
//

import Foundation
import RealmSwift

class UnitOfMeasure: Object {
    @objc dynamic var foodId: Int = 0
    @objc dynamic var unit: String = ""
    @objc dynamic var conversionToBaseUnit: Double = 0
}
