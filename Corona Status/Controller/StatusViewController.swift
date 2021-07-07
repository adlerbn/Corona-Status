//
//  StatusViewController.swift
//  Corona Status
//
//  Created by Yahya Bn on 7/7/21.
//

import UIKit
import Charts
import CountryKit
import CoreLocation

class StatusViewController: UIViewController {
    
    @IBOutlet var titleBlurViews: [UIView]!
    
    @IBOutlet weak var myScrollView: UIScrollView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pieChartView: PieChartView?
    @IBOutlet var BottomViews: [UIView]!
    @IBOutlet weak var currentLocation: UISegmentedControl!
    
    @IBOutlet weak var confirmedCountLabel: UILabel!
    @IBOutlet weak var deathCountLabel: UILabel!
    @IBOutlet weak var curedCountLabel: UILabel!
    @IBOutlet weak var activeCountLabel: UILabel!
    @IBOutlet weak var criticalCountLabel: UILabel!
    
    var data: ScatterChartData?
    var apiManager: ApiManager?
    
    var latestReport: LatestReport?
    var topCountries: [Country]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialize()
        loadingRequests()
    }
    @IBAction func stateChanged(_ sender: Any) {
        switch currentLocation.selectedSegmentIndex {
        case 0:
            print("Global")
        case 1:
            print("Your Current location")
        default:
            print("Error: Segmented Control")
        }
    }
}

//MARK: - Api Delegate
extension StatusViewController: ApiManagerDelegateStatus {
    func didUpdateLatestReport(with report: LatestReport, apiType: ApiType) {
        latestReport = report
        topCountries = addTopCountries(with: report)
        reloadData()
    }
    
    func loadingRequests() {
        requestLatestReport()
        
        let alarm = UIAlertController(title: "Loading Data", message: nil, preferredStyle: .alert)
        present(alarm, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            alarm.dismiss(animated: true)
        }
    }
    
    func requestLatestReport() {
        apiManager = ApiManager(type: .getLatestReport, httpMethod: .GET)
        apiManager?.getLatestTotals()
        apiManager?.delegateStatus = self
    }
    
    func reloadData() {
        DispatchQueue.main.async { [self] in
            collectionView.reloadData()
            if let summary = latestReport?.data.summary {
                confirmedCountLabel.text = Standard.fixedIntegerStandard(number: summary.tested)
                deathCountLabel.text = Standard.fixedIntegerStandard(number: summary.deaths)
                curedCountLabel.text = Standard.fixedIntegerStandard(number: summary.recovered)
                activeCountLabel.text = Standard.fixedIntegerStandard(number: summary.active_cases)
                criticalCountLabel.text = Standard.fixedIntegerStandard(number: summary.critical)
            } else {
                print("status is nil")
            }
        }
    }
}

//MARK: - Help Method
extension StatusViewController {
    
    func initialize() {
        setChart()
        setCornerAndShadow()
        configureRefreshControl()
    }
    
    func configureRefreshControl () {
        // Add the refresh control to your UIScrollView object.
        let refresh = UIRefreshControl()
        myScrollView.refreshControl = refresh
        myScrollView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
    }
    
    @objc func handleRefreshControl() {
        // Update your content…
        
        collectionView.reloadData()
        // Dismiss the refresh control.
        DispatchQueue.main.async {
            self.run(after: 2) {
                self.myScrollView.refreshControl?.endRefreshing()
            }
        }
    }
    
    func addTopCountries(with report: LatestReport) -> [Country] {
        let regions = report.data.regions
        let countries: [Country] = [
            regions.iran,
            regions.germany,
            regions.italy,
            regions.uk,
            regions.usa
        ]
        
        return countries
    }
    
    func run(after wait: TimeInterval, closure: @escaping () -> Void) {
        let queue = DispatchQueue.main
        queue.asyncAfter(deadline: DispatchTime.now() + wait, execute: closure)
    }
    
    func playAnimateButton(_ item: AnyObject) {
        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        bounceAnimation.values = [1.0, 1.1, 1.2, 1.1, 1.2, 1.1, 1.0]
        bounceAnimation.duration = TimeInterval(0.5)
        bounceAnimation.calculationMode = CAAnimationCalculationMode.cubic
        
        item.layer.add(bounceAnimation, forKey: "bounceAnimation")
    }
    
    func setCornerAndShadow() {
        for view in BottomViews {
            view.layer.shadowColor = UIColor.black.cgColor
            view.layer.shadowOpacity = 0.1
            view.layer.shadowOffset = .zero
            view.layer.shadowRadius = 6
        }
        
        for item in titleBlurViews {
            item.layer.cornerRadius = 10
        }
    }
    
    func setChart() {
        
        let Death = PieChartDataEntry(value: 30, label: "Death")
        let Cured = PieChartDataEntry(value: 70, label: "Cured")
        
        var dataEntries = [PieChartDataEntry]()
        
        dataEntries = [Death, Cured]
        
        updateChart(dataEntries)
    }
    
    func updateChart(_ data: [PieChartDataEntry]) {
        
        let chartDataSet = PieChartDataSet(entries: data)
        let pieChartData = PieChartData(dataSet: chartDataSet)
        
        let format = NumberFormatter()
        format.numberStyle = .percent
        format.maximumFractionDigits = 1
        format.multiplier = 1.0
        let formatter = DefaultValueFormatter(formatter: format)
        
        pieChartData.setValueFormatter(formatter)
        
        let colors = [UIColor(named: "Death"), UIColor(named: "Cured")]
        
        chartDataSet.colors = colors as! [NSUIColor]
        
        pieChartView?.data = pieChartData
        pieChartView?.drawEntryLabelsEnabled = false
        pieChartView?.drawSlicesUnderHoleEnabled = false
        pieChartView?.showsLargeContentViewer = true
        pieChartView?.centerText = "Chart"
        pieChartView?.isUserInteractionEnabled = false
        
        pieChartView?.centerText = "Pie Chart"
        pieChartView?.holeColor = .none
        
        pieChartView?.entryLabelColor = UIColor.black
        pieChartData.setValueTextColor(UIColor.black)
    }
    
    
}

//MARK: - UICollectionViewDataSource

extension StatusViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        topCountries?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopCountry", for: indexPath) as! TopCountryCell
        
        if let country = topCountries?[indexPath.row]{
            cell.countryNameLabel.text = country.name
            cell.deathCountLabel.text = Standard.fixedIntegerStandard(number: country.deaths)
            cell.curedCountLabel.text = Standard.fixedIntegerStandard(number: country.recovered)
            cell.changeLabel.text = Standard.fixedIntegerStandard(number: country.change.total_cases)
            cell.countryFlagImageView.image = CountryKitManager.getFlagImage(name: country.name)
        }
        
        DispatchQueue.main.async {
            cell.layer.transform = CATransform3DMakeScale(0.1,0.1,1)
            UIView.animate(withDuration: 0.15, animations: {
                cell.layer.transform = CATransform3DMakeScale(1,1,1)
            })
        }
        
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 0.1
        cell.layer.shadowOffset = .zero
        cell.layer.shadowRadius = 6
        return cell
    }
}

extension StatusViewController: UICollectionViewDelegate {
    
}
