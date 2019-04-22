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
        
//        dataPrepared()
//        updateChartData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        dataPrepared()
        updateChartData()
    }
    
    override func updateChartData() {
        if self.shouldHideData {
            chartView.data = nil
            return
        }
        
        self.setDataCount(data)
    }
    
    func setDataCount(_ dataSet: [WeightAndDate]) {
//        let values = (0..<count).map { (i) -> ChartDataEntry in
//            let val = Double(arc4random_uniform(range) + 3)
//            return ChartDataEntry(x: Double(i), y: val)
////            return ChartDataEntry(x: Double(i), y: val, icon: #imageLiteral(resourceName: "icon"))
//        }
        
        var referenceTimeInterval: TimeInterval = 0
        if let minTimeInterval = (dataSet.map { $0.date.timeIntervalSince1970}).min() {
            referenceTimeInterval = minTimeInterval
        }
        
//        Define chart xValues formatter
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        formatter.locale = Locale.current
        
        let xValuesNumberFormatter = ChartXAxisFormatter(referenceTimeInterval: referenceTimeInterval, dateFormatter: formatter)
        
        
        var entries = [ChartDataEntry]()

        for dataPoint in dataSet {
            let timeInterval = dataPoint.date.timeIntervalSince1970
            let xValue = (timeInterval - referenceTimeInterval) / (3600 * 24)
            
            let yValue = dataPoint.weight
            let entry = ChartDataEntry(x: xValue, y: yValue)
            entries.append(entry)
            
        
        }
        
        print("\(entries)")
        
        
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
//        xAxis.labelCount = entries.count
        xAxis.drawLabelsEnabled = true
        xAxis.drawLimitLinesBehindDataEnabled = true
        xAxis.avoidFirstLastClippingEnabled = true
        xAxis.valueFormatter = xValuesNumberFormatter
        
        let set1 = LineChartDataSet(values: entries, label: "Weight")
        set1.drawIconsEnabled = false
        

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
//                print("\(rawData)")
        
    }
    
    func dataPrepared() {
        
        loadData()
        
        for date in rawData {
            let newWeightOfDate = WeightAndDate(date: date.date, weight: date.weight)
            data.append(newWeightOfDate)
        }
        
        data.sort { $0.date < $1.date }
        

        print(data)
        
    }


}
