//
//  HorizontalBarChartViewController.swift
//  Prototype Wireframe
//
//  Created by MAC on 12/16/18.
//  Copyright © 2018 Jaime Lai. All rights reserved.
//

import Foundation
import Charts
import RealmSwift

class HorizontalBarChartViewController: BaseChartsViewController {
    
    let realm = try! Realm()
    @IBOutlet weak var horizontalBarChartView: HorizontalBarChartView!
    var data = [String: Int]()
    
    let dateFormatterDB: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .none
        return df
    }()
    
    let dateFormatterPredicate: DateFormatter = {
       let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        return df
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup after loading view.
        self.options = [.toggleValues,
                        .toggleIcons,
                        .toggleHighlight,
                        .animateX,
                        .animateXY,
                        .saveToGallery,
                        .togglePinchZoom,
                        .toggleAutoScaleMinMax,
                        .toggleData,
                        .toggleBarBorders]
        
        self.setup(barLineChartView: horizontalBarChartView)
        
        horizontalBarChartView.delegate = self
        
        horizontalBarChartView.drawBarShadowEnabled = false
        horizontalBarChartView.drawValueAboveBarEnabled = true
        horizontalBarChartView.isUserInteractionEnabled = false
        
        horizontalBarChartView.maxVisibleCount = 100
        
        let xAxis = horizontalBarChartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 10)
        xAxis.granularity = 10
        
        let leftAxis = horizontalBarChartView.leftAxis
        leftAxis.labelFont = .systemFont(ofSize: 10)
        leftAxis.drawAxisLineEnabled = true
        leftAxis.drawGridLinesEnabled = true
        leftAxis.axisMinimum = 0
        
        let l = horizontalBarChartView.legend
        l.horizontalAlignment = .left
        l.verticalAlignment = .bottom
        l.orientation = .horizontal
        l.drawInside = false
        l.form = .square
        l.formSize = 8
        l.font = UIFont(name: "HelveticaNeue-Light", size: 11)!
        l.xEntrySpace = 4
//        horizontalBarChartView.legend = 1
        
        horizontalBarChartView.fitBars = true
        
        updateChartData()
        dataPrepared()
    
    }
    
    override func updateChartData() {
        if self.shouldHideData {
            horizontalBarChartView.data = nil
            return
        }
        
        self.setDataCount(12, range: 31)
    }
    
    func setDataCount(_ count: Int, range: UInt32) {
        let barWidth = 9.0
        let spaceForBar = 10.0
        
        let yVals = (0..<count).map { (i) -> BarChartDataEntry in
            let mult = range + 1
            let val = Double(arc4random_uniform(mult))
//            return BarChartDataEntry(x: Double(i)*spaceForBar, y: val, icon: #imageLiteral(resourceName: "icon"))
            return BarChartDataEntry(x: Double(i)*spaceForBar, y: val)
        }
        
        let set1 = BarChartDataSet(values: yVals, label: "DataSet")
        set1.drawIconsEnabled = false
        
        let data = BarChartData(dataSet: set1)
        data.setValueFont(UIFont(name:"HelveticaNeue-Light", size:10)!)
        data.barWidth = barWidth
        
        horizontalBarChartView.data = data
    }
    
    func loadData() {
        
        

        var rawData: Results<DailyData>!
        
        let currentDate = Date()
        
        var dbStartDate: String
        var dbEndDate: String

        dbEndDate = dateFormatterDB.string(from: currentDate)
        dbStartDate = dateFormatterDB.string(from: Calendar.current.date(byAdding: .day, value: -7, to: currentDate)!)
        
        var predicateStartDate = dateFormatterPredicate.string(from: dateFormatterDB.date(from: dbStartDate)!)
        var predicateEndDate = dateFormatterPredicate.string(from: dateFormatterDB.date(from: dbEndDate)!)
        
        
//        switch option {
//        case .goalStart:
//            startDate =
//            endDate = dateFormat.string(from: currentDate)
//        case .week:
//            startDate = dateFormat.string(from: currentDate)
//            endDate = dateFormat.string(from: currentDate)
//        case .month:
//            startDate =
//            endDate = dateFormat.string(from: currentDate)
//        default:
//            print("not working")
//        }

        let predicate = NSPredicate(format: "date > %@ && date < %@", predicateStartDate, predicateEndDate)

        rawData = realm.objects(DailyData.self).filter(predicate)
//        print("\(String(describing: rawData))")
        print("\(predicate)")
        print("\(predicate) \(dbStartDate) \(dbEndDate) \(predicateStartDate) \(predicateEndDate)")


    }

    func dataPrepared() {
        loadData()
    }
    
}
