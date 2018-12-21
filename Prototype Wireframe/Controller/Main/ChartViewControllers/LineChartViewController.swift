//
//  LineChartViewController.swift
//  Prototype Wireframe
//
//  Created by MAC on 12/17/18.
//  Copyright © 2018 Jaime Lai. All rights reserved.
//

import UIKit
import Charts

class LineChartViewController: BaseChartsViewController {
    
    @IBOutlet weak var chartView: LineChartView!

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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
