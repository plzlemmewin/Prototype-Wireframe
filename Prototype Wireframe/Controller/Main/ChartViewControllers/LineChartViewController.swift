//
//  LineChartViewController.swift
//  Prototype Wireframe
//
//  Created by MAC on 12/17/18.
//  Copyright © 2018 Jaime Lai. All rights reserved.
//

import UIKit
import RealmSwift
import Charts

struct WeightAndDate {
    var date: Date
    var weight: Double
}

class LineChartViewController: BaseChartsViewController {
    
    let realm = try! Realm()
    var rawData: Results<DailyData>!
    var data = [WeightAndDate]()
    @IBOutlet weak var chartView: LineChartView!
    
    let dateFormatterInitial: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .none
        return df
    }()
    
    let dateFormatterUser: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "MMM dd, yyyy"
        return df
    }()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.options = [.toggleValues,
                       .toggleFilled,
                       .toggleCircles,
                       .toggleCubic,
                       .toggleHorizontalCubic,
                       .toggleIcons,
                       .toggleStepped,
                       .toggleHighlight,
                       .animateX,
                       .animateY,
                       .animateXY,
                       .saveToGallery,
                       .togglePinchZoom,
                       .toggleAutoScaleMinMax,
                       .toggleData]
        
        chartView.delegate = self
        chartView.isUserInteractionEnabled = false
        
        let leftAxis = chartView.leftAxis

        leftAxis.axisMaximum = 200
        leftAxis.axisMinimum = 0 
        
        chartView.rightAxis.enabled = false
        
        dataPrepared()
        updateChartData()
    }
    
    override func updateChartData() {
        if self.shouldHideData {
            chartView.data = nil
            return
        }
        
        self.setDataCount(12, range: 155)
    }
    
    func setDataCount(_ count: Int, range: UInt32) {
        let values = (0..<count).map { (i) -> ChartDataEntry in
            let val = Double(arc4random_uniform(range) + 3)
            return ChartDataEntry(x: Double(i), y: val)
//            return ChartDataEntry(x: Double(i), y: val, icon: #imageLiteral(resourceName: "icon"))
        }
        
        let set1 = LineChartDataSet(values: values, label: "DataSet 1")
        set1.drawIconsEnabled = false
        
//
//        set1.lineDashLengths = [5, 2.5]
//        set1.highlightLineDashLengths = [5, 2.5]
        set1.setColor(.black)
        set1.setCircleColor(.black)
        set1.lineWidth = 1
        set1.circleRadius = 3
        set1.drawCircleHoleEnabled = false
        set1.valueFont = .systemFont(ofSize: 9)
        set1.formLineDashLengths = [5, 2.5]
        set1.formLineWidth = 1
        set1.formSize = 15
        
        let gradientColors = [ChartColorTemplates.colorFromString("#00ff0000").cgColor,
                              ChartColorTemplates.colorFromString("#ffff0000").cgColor]
        let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
        
        set1.fillAlpha = 1
        set1.fill = Fill(linearGradient: gradient, angle: 90) //.linearGradient(gradient, angle: 90)
        set1.drawFilledEnabled = true
        
        let data = LineChartData(dataSet: set1)
        
        chartView.data = data
    }
    
    
    func loadData() {
        
        var dbStartDate: Date!
        var dbEndDate: Date!
        
        let currentDate = Date()
        let formattedCurrentDate = dateFormatterInitial.string(from: currentDate)
        let formattedStartDate = dateFormatterInitial.string(from: Calendar.current.date(byAdding: .day, value: -7, to: currentDate)!)
        
        
        dbEndDate = dateFormatterUser.date(from: formattedCurrentDate)
        dbStartDate = dateFormatterUser.date(from: formattedStartDate)
        
        let predicate = NSPredicate(format: "date >= %@ && date <= %@", dbStartDate as! NSDate, dbEndDate as! NSDate)
        
        rawData = realm.objects(DailyData.self).filter(predicate)
        
        //        print("\(predicate) \(dbStartDate) \(dbEndDate)")
                print("\(rawData)")
        
    }
    
    func dataPrepared() {
        
        loadData()
        
        for date in rawData {
            let newWeightOfDate = WeightAndDate(date: date.date, weight: date.weight)
            data.append(newWeightOfDate)
        }
        
        print(data)
        
    }


}
