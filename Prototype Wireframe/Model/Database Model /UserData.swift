//
//  UserData.swift
//  Prototype Wireframe
//
//  Created by MAC on 6/24/18.
//  Copyright © 2018 Jaime Lai. All rights reserved.
//

import Foundation
import RealmSwift

class UserData: Object {
    @objc dynamic var name: String = ""
    let data = List<Food>()
}
