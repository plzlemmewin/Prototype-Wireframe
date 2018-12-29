//
//  DailyData.swift
//  Prototype Wireframe
//
//  Created by MAC on 9/16/18.
//  Copyright © 2018 Jaime Lai. All rights reserved.
//

import Foundation
import RealmSwift

class DailyData: Object {
    @objc dynamic var date = Date()
    @objc dynamic var dailyCaloricTarget: Int = 0
    let data = List<Food>()
}

