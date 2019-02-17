//
//  PieChartViewController.swift
//  Prototype Wireframe
//
//  Created by MAC on 12/27/18.
//  Copyright © 2018 Jaime Lai. All rights reserved.
//

import UIKit
import Charts
import RealmSwift

class PieChartViewController: BaseChartsViewController {
    
    
    let realm = try! Realm()
    
    var rawData: Results<DailyData>!
    
    var fatsPercent: Double = 0.0
    var carbsPercent: Double = 0.0
    var proteinPercent: Double = 0.0
    
    var macros = ["Fats": 0.0, "Carbs": 0.0, "Protein": 0.0]
    
    
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
    

    @IBOutlet weak var chartView: PieChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.options = [.toggleValues,
                        .toggleXValues,
                        .togglePercent,
                        .toggleHole,
                        .toggleIcons,
                        .animateX,
                        .animateY,
                        .animateXY,
                        .spin,
                        .drawCenter,
                        .saveToGallery,
                        .toggleData]
        
        self.setup(pieChartView: chartView)
        
        chartView.delegate = self
        chartView.isUserInteractionEnabled = false
        
        let l = chartView.legend
        l.horizontalAlignment = .left
        l.verticalAlignment = .top
        l.orientation = .vertical
        l.xEntrySpace = 7
        l.yEntrySpace = 0
        l.yOffset = 0
        //        chartView.legend = l
        
        // entry label styling
        chartView.entryLabelColor = .white
        chartView.entryLabelFont = .systemFont(ofSize: 18, weight: .light)
        
        chartView.centerText = "Macro\nBreadown"
        
        setUpChart()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        setUpChart()
    }
    
    override func updateChartData() {
        if self.shouldHideData {
            chartView.data = nil
            return
        }
        
        
        self.setDataCount(macros)
        
    }
    
    func setDataCount(_ macros: [String: Double]) {
//        let entries = (0..<count).map { (i) -> PieChartDataEntry in
//            // IMPORTANT: In a PieChart, no values (Entry) should have the same xIndex (even if from different DataSets), since no values can be drawn above each other.
//            return PieChartDataEntry(value: Double(arc4random_uniform(range) + range / 5),
//                                     label: parties[i % parties.count])
//
//
//        }
        var entries = [PieChartDataEntry]()
        
        for (key, value) in macros {
            let entry = PieChartDataEntry(value: value, label: key)
            entries.append(entry)
        }
        
        let set = PieChartDataSet(values: entries, label: "Macros")
        set.drawIconsEnabled = false
        set.sliceSpace = 2
        
        
        set.colors = ChartColorTemplates.vordiplom()
            + ChartColorTemplates.joyful()
            + ChartColorTemplates.colorful()
            + ChartColorTemplates.liberty()
            + ChartColorTemplates.pastel()
            + [UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)]
        
        let data = PieChartData(dataSet: set)
        
        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .percent
        pFormatter.maximumFractionDigits = 1
        pFormatter.multiplier = 1
        pFormatter.percentSymbol = " %"
        data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
        
        data.setValueFont(.systemFont(ofSize: 13, weight: .regular))
        data.setValueTextColor(.black)
        
        chartView.data = data
        chartView.highlightValues(nil)
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
        
        print("\(rawData)")
        
    }
    
    func dataPrepared() {
        
        var fats: Double = 0.0
        var carbs: Double = 0.0
        var protein: Double = 0.0
        var totalMacros: Double = 0.0
        
        loadData()
        
        for date in rawData {
            for food in date.data {
                fats += food.fats
                carbs += food.carbs
                protein += food.protein
            }
        }
        
        totalMacros = fats + carbs + protein
        
        fatsPercent = fats / totalMacros
        carbsPercent = carbs / totalMacros
        proteinPercent = protein / totalMacros
        
        macros["Fats"] = fatsPercent
        macros["Carbs"] = carbsPercent
        macros["Protein"] = proteinPercent
        
//        print("\(fats) \(carbs) \(protein) \(totalMacros)")
//        print("\(fatsPercent) \(carbsPercent) \(proteinPercent)")
        print("\(macros)")
        
        
        
    }
    
    func setUpChart() {
        dataPrepared()
        updateChartData()
    }
    
}
