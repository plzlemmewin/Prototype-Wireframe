//
//  DBFoodCell.swift
//  Prototype Wireframe
//
//  Created by MAC on 12/4/18.
//  Copyright © 2018 Jaime Lai. All rights reserved.
//

import UIKit

class DBFoodCell: UITableViewCell {
    
    @IBOutlet var idLabel: UILabel!
    @IBOutlet var brandLabel: UILabel!
    @IBOutlet var variantLabel: UILabel!
    @IBOutlet var cookedLabel: UILabel!
    @IBOutlet var servingSizeLabel: UILabel!
    @IBOutlet var calorieLabel: UILabel!

    
}



//func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//    let cell = tableView.dequeueReusableCell(withIdentifier: "AddFoodCell", for: indexPath) as! DBFoodCell
//    
//    let food = foodDatabase[indexPath.row]
//    
//    cell.idLabel.text = food.name
//    if let brand = food.brand {
//        cell.brandLabel.text = brand
//    } else {
//        cell.brandLabel.text = ""
//    }
//    if let variant = food.variant {
//        cell.variantLabel.text = ", \(variant)"
//    } else {
//        cell.variantLabel.text = ""
//    }
//    if let cooked = food.cooked {
//        cell.cookedLabel.text = "\(cooked), "
//    } else {
//        cell.cookedLabel.text = ""
//}
