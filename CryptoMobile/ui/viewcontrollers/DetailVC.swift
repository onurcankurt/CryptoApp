//
//  DetailVC.swift
//  CryptoMobile
//
//  Created by onur on 24.07.2024.
//

import UIKit
import DGCharts
import Charts

class DetailVC: UIViewController {
    
    private var lineChartView: LineChartView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var highLabel_24h: UILabel!
    @IBOutlet weak var lowLabel_24h: UILabel!
    @IBOutlet weak var totalVolumeLabel: UILabel!
    @IBOutlet weak var totalSupplyLabel: UILabel!
    @IBOutlet weak var priceChangeLabel: UILabel!
    @IBOutlet weak var priceChangePercentageLabel: UILabel!
    
    @IBOutlet weak var arrowUpImage: UIImageView!
    @IBOutlet weak var arrowDownImage: UIImageView!
    
    var detailCurrency: CurrencyElement?
    var prices_24h = [Double]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let c = detailCurrency {
            prices_24h = c.sparkline_in_7d!.price!
            priceLabel.text = "\(c.current_price!.formatted(.currency(code: "USD")))"
            highLabel_24h.text = "\(c.high_24h!.formatted(.currency(code: "USD")))"
            lowLabel_24h.text = "\(c.low_24h!.formatted(.currency(code: "USD")))"
            totalVolumeLabel.text = "\(c.total_volume!.formatted(.currency(code: "USD")))"
            totalSupplyLabel.text = "\(c.total_supply?.formatted(.number) ?? "0.0") \(c.symbol!.uppercased())"
            priceChangeLabel.text = "\(c.price_change_24h!.formatted(.currency(code: "USD")))"
            priceChangePercentageLabel.text = "\(c.price_change_percentage_24h!.formatted(.number))%"
            
            if c.price_change_24h! < 0 {
                priceChangeLabel.textColor = .red
                priceChangePercentageLabel.textColor = .red
                priceLabel.textColor = .red
                arrowUpImage.isHidden = true
            } else if c.price_change_24h! > 0 {
                priceChangeLabel.textColor = .systemGreen
                priceChangePercentageLabel.textColor = .systemGreen
                arrowDownImage.isHidden = true
                priceLabel.textColor = .systemGreen
            } else {
                priceChangeLabel.textColor = .black
                priceChangePercentageLabel.textColor = .black
                priceLabel.textColor = .black
                arrowUpImage.isHidden = true
                arrowDownImage.isHidden = true
            }
        }
        
        setupChart()
        updateChartData()
    }
    
    private func setupChart() {
        // create the LineChartView
        lineChartView = LineChartView()
        lineChartView.frame = CGRect(x: 0, y: 220, width: view.frame.size.width, height: 300)
        //lineChartView.center = view.center
        
        // Adjust graphic settings
        lineChartView.xAxis.labelPosition = .bottom
        lineChartView.xAxis.setLabelCount(8, force: true)
        lineChartView.xAxis.granularity = 1
        lineChartView.xAxis.valueFormatter = DateValueFormatter()
        lineChartView.rightAxis.enabled = true
        lineChartView.leftAxis.enabled = false
        lineChartView.legend.enabled = false
        
        
        view.addSubview(lineChartView)
    }
    
    private func updateChartData() {
        // Sparkline datas
        let prices: [Double] = prices_24h
        
        var dataEntries: [ChartDataEntry] = []
        for (index, price) in prices.enumerated() {
            let dataEntry = ChartDataEntry(x: Double(index), y: price)
            dataEntries.append(dataEntry)
        }
        
        let dataSet = LineChartDataSet(entries: dataEntries, label: "Price")
        dataSet.colors = [NSUIColor.blue]
        dataSet.valueColors = [NSUIColor.black]
        dataSet.drawCirclesEnabled = false // Hides dots
        dataSet.lineWidth = 2.0 // Adjusts line thickness
        dataSet.drawFilledEnabled = true
        dataSet.fillColor = NSUIColor.blue
        dataSet.fillAlpha = 0.5
        
        let lineChartData = LineChartData(dataSet: dataSet)
        lineChartView.data = lineChartData
        
    }
}

class DateValueFormatter: NSObject, AxisValueFormatter {
    private let dateFormatter: DateFormatter
    
    override init() {
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd"
        super.init()
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let now = Date()
        let fromDate = Calendar.current.date(byAdding: .day, value: -7, to: now)
        let calendar = Calendar.current
        let hoursAgo = Int(value)
        let date = calendar.date(byAdding: .hour, value: hoursAgo, to: fromDate!)!
        return dateFormatter.string(from: date)
    }
}
