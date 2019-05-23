//
//  User.swift
//  Prototype Wireframe
//
//  Created by MAC on 5/22/19.
//  Copyright © 2019 Jaime Lai. All rights reserved.
//

import Foundation

struct User:Codable {
    static var current: User!
    var id: String
    var username: String
}
