//
//  HorizontalBarChartViewController.swift
//  Prototype Wireframe
//
//  Created by MAC on 12/16/18.
//  Copyright © 2018 Jaime Lai. All rights reserved.
//

import Foundation
import Charts

class HorizontalBarChartViewController: BaseChartsViewController {
    @IBOutlet weak var horizontalBarChartView: HorizontalBarChartView!
    
    
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
    
}
