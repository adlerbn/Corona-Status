//
//  SearchViewController.swift
//  Corona Status
//
//  Created by Yahya Bn on 7/7/21.
//

import UIKit
import CountryKit

class SearchCountryViewController: UIViewController {
    
    @IBOutlet var titleBlurViews: [UIView]!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var apiManager: ApiManager?
    var countries:[CountryData]?
    var textSearch: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addGesture()
        
        for item in titleBlurViews {
            item.layer.cornerRadius = 10
        }
    }
}

//MARK: - Api Delegate
extension SearchCountryViewController: ApiManagerDelegateCountry {
    func didUpdateReportByRegion(with country: CountryData, apiType: ApiType) {
        countries = [country]
        reloadData()
    }
    
    func loadingRequests(with name: String) {
        requestCountryByRegion(with: name)
        
        let alarm = UIAlertController(title: "Loading Data", message: nil, preferredStyle: .alert)
        present(alarm, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            alarm.dismiss(animated: true)
        }
    }
    
    func requestCountryByRegion(with name: String) {
        apiManager = ApiManager(type: .getReportByRegion, httpMethod: .GET)
        apiManager?.getDailyReportByCountryNames(name)
        apiManager?.delegateCountry = self
    }
    
    func reloadData() {
        DispatchQueue.main.async { [self] in
            tableView.reloadData()
        }
    }
}

//MARK: - Help Method
extension SearchCountryViewController {
    
}

//MARK: - TableViewDelegate
extension SearchCountryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        countries?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell", for: indexPath) as! CountryCell
        
        if let summary = countries?[0].data.summary,
           let name = textSearch {
            
            cell.countryNameLabel.text  = name
            cell.deathCountLabel.text = Standard.fixedIntegerStandard(number: summary.deaths)
            cell.curedCountLabel.text = Standard.fixedIntegerStandard(number: summary.recovered)
            cell.confirmedCountLabel.text = Standard.fixedIntegerStandard(number: summary.tested)
            cell.countryFlagImageView.image = CountryKitManager.getFlagImage(name: name)
        }
        
        DispatchQueue.main.async {
            cell.layer.transform = CATransform3DMakeScale(0.1,0.1,1)
            UIView.animate(withDuration: 0.15, animations: {
                cell.layer.transform = CATransform3DMakeScale(1,1,1)
            })
        }
        
        cell.backgroundCell.layer.cornerRadius = 10
        cell.backgroundCell.layer.shadowColor = UIColor.black.cgColor
        cell.backgroundCell.layer.shadowOpacity = 0.1
        cell.backgroundCell.layer.shadowOffset = .zero
        
        return cell
    }
}

//MARK: - UISearchBarDelegate
extension SearchCountryViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            textSearch = text.capitalizingFirstLetter()
            loadingRequests(with: textSearch!)
        }
    }
}
