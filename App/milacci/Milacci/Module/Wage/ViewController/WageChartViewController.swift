//
//  WageViewController.swift
//  Milacci
//
//  Created by Michal Sousedik on 24/10/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import UIKit
import Charts
import RxSwift
import RxCocoa

class WageChartViewController: UIViewController, Storyboardable {

    @IBOutlet weak var graphView: BarChartView!
    @IBOutlet weak var monthWageLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var loadingActivityIndicator: UIActivityIndicatorView!

    private let visibleBarsTrashHold = 5
    private var viewModel: WageChartViewPresentable!
    var viewModelBuilder: WageChartViewPresentable.ViewModelBuilder!
    private let bag = DisposeBag()
    private let refresh = PublishRelay<Void>()

    var values: [Invoice] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = viewModelBuilder(
            (
                refresh: refresh.asDriver(onErrorDriveWith: .empty()),
                ()
            )
        )
        self.setupUI()
        self.setupBinding()
        self.refresh.accept(())
    }

}

extension WageChartViewController {
    func setupUI() {
        self.monthLabel.textColor = .clear
        self.monthWageLabel.textColor = .clear
        self.graphView.noDataText = ""
        self.loadingActivityIndicator.startAnimating()
    }

    func setupBinding() {
        self.viewModel.output.error.drive { [weak self] (error) in
            self?.handle(error, retryHandler: { [weak self] in
                self?.refresh.accept(())
            })
        }.disposed(by: bag)

        self.viewModel.output.isLoading.drive(onNext: { [weak self] isLoading in
            if isLoading {
                self?.loadingView.isHidden = false
            } else {
                self?.loadingView.isHidden = true
            }
        }).disposed(by: bag)

        self.viewModel.output.invoiceChartEntries.drive(onNext: { [weak self] in
            guard let self = self else {return}
            self.values = $0
            var dataEntries: [ChartDataEntry] = []
            if $0.count > 0 {
            for i in 0..<$0.count {
                guard
                    let stringValue = $0[i].value,
                    let value = Double(stringValue) else {return}
                let dataEntry = BarChartDataEntry(x: Double(i), y: value, data: $0[i])
                dataEntries.append(dataEntry)
            }
            let set1 = BarChartDataSet(entries: dataEntries)
            set1.colors = [Asset.Colors.chartBarDefault.color]
            set1.highlightColor = Asset.Colors.chartBarHighlighted.color
            let data = BarChartData(dataSets: [set1])
            data.setDrawValues(false)
            self.graphView.data = data
            self.setChart()
            self.animateChart()
            }
        }).disposed(by: bag)
    }
}

extension WageChartViewController: ChartViewDelegate {

    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {

        self.monthLabel.textColor = .label
        self.monthWageLabel.textColor = .label
        self.monthWageLabel.text = entry.y.toCzechCrowns
        guard let data = entry.data else {print("Data are nil"); return}
        guard
            let invoiceChartEntry = data as? Invoice
        else {fatalError("Data in chart entry are not of type Invoice")}
        self.monthLabel.text = invoiceChartEntry.overviewPeriodOfIssue
    }

    func chartValueNothingSelected(_ chartView: ChartViewBase) {

        self.monthLabel.text = "Select month"
        self.monthWageLabel.text = "- Kč"
    }

    func setChart() {
        graphView.delegate = self
        graphView.backgroundColor = .clear
        graphView.rightAxis.enabled = false
        graphView.leftAxis.enabled = false
        graphView.xAxis.drawAxisLineEnabled = false
        graphView.xAxis.labelPosition = .bottom
        graphView.animate(xAxisDuration: 1.5, yAxisDuration: 1.5, easingOption: .easeInQuad)
        graphView.doubleTapToZoomEnabled = false
        graphView.legend.enabled = false
        graphView.xAxis.drawGridLinesEnabled = false
        graphView.xAxis.granularity = 1
        graphView.xAxis.valueFormatter = self
        graphView.xAxis.labelFont = .systemFont(ofSize: 10, weight: .bold)
        graphView.xAxis.avoidFirstLastClippingEnabled = false
        graphView.leftAxis.axisMinimum = 0

    }

    func animateChart(){
        guard let barData = self.graphView?.barData else {return}
        let delayScaling = 1.5
        var delayHighlight = 3.0
        var val = Double(barData.entryCount) / Double(self.visibleBarsTrashHold)
        if val < 1.0 {
            val = 1.0
        }
        if val > 1.0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + delayScaling) { [weak self, val] in
                let scaleX = CGFloat(val)
                self?.graphView.zoomAndCenterViewAnimated(scaleX: scaleX, scaleY: 1, xValue: 0, yValue: 0, axis: YAxis.AxisDependency.left, duration: 1, easingOption: .easeInCubic)
            }
        } else {
            delayHighlight = 1.5
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + delayHighlight) { [weak self] in
            self?.graphView.highlightValue(x: 0, dataSetIndex: 0)
        }
    }
}

extension WageChartViewController: IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return self.values[Int(value)].chartPeriodOfIssue
    }

}
