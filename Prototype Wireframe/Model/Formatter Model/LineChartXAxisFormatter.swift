//
//  LineChartXAxisFormatter.swift
//  Prototype Wireframe
//
//  Created by MAC on 2/2/19.
//  Copyright © 2019 Jaime Lai. All rights reserved.
//

import Foundation
import Charts

class LineChartXAxisFormatter: NSObject {
    fileprivate var dateFormatter: DateFormatter?
    fileprivate var referenceTimeInterval: TimeInterval?
    
    convenience init(referenceTimeInterval: TimeInterval, dateFormatter: DateFormatter) {
        self.init()
        self.referenceTimeInterval = referenceTimeInterval
        self.dateFormatter = dateFormatter
    }
}

extension LineChartXAxisFormatter: IAxisValueFormatter {
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        guard let dateFormatter = dateFormatter, let referenceTimeInterval = referenceTimeInterval
            else {
                return ""
        }
        
        let date = Date(timeIntervalSince1970: value * 3600 * 24 + referenceTimeInterval)
        return dateFormatter.string(from: date)
    }
    
}
