//
//  ViewController.swift
//  weather-assessment
//
//  Created by Eugenio Baglieri on 04/10/2019.
//  Copyright © 2019 PED. All rights reserved.
//

import UIKit
import CoreData

class MainViewController: UIViewController {
    
    private struct Constants {
        static let CellIdentifier = "Cell"
        static let CompactCellHeight: CGFloat = 80
        static let ExpandedCellHeight: CGFloat = 210
    }
    
    lazy var dataProvider: WeatherDataProvider = WeatherDataProvider(persistentContainer: CoreDataManager.default.persistentContainer)
    
    var searchHistory: [WeatherCellViewModel] = []
    
    var frc: NSFetchedResultsController<CachedWeather>!
    
    private var tableDataSource: ArrayTableViewDataSource<WeatherCellViewModel>!
    
    private var mainView: MainView { return view as! MainView }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.delegate = self
        navigationItem.titleView = mainView.searchBar
        
        let tableView = mainView.tableView!
        let cellNib = UINib(nibName: "WeatherTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "Cell")
        tableView.tableFooterView = UIView()
        tableDataSource = createTableViewDataSource()
        tableView.dataSource = tableDataSource
        tableView.delegate = self
    
    }
    
    private func searchWeather(for city: String) {
        let searchBar = mainView.searchBar
        searchBar?.isLoading = true
        dataProvider.fetchWeatherForCityWithName(city) { [weak self] result in
            guard let strongSelf = self else { return }
            searchBar?.isLoading = false
            switch result {
            case .success(let weatherInfo):
                print(weatherInfo)
                let cellViewModel = WeatherCellViewModel(weatherInfo: weatherInfo)
                strongSelf.searchHistory.insert(cellViewModel, at: 0)
                strongSelf.tableDataSource.items = strongSelf.searchHistory
                let tableview = strongSelf.mainView.tableView!
                tableview.beginUpdates()
                tableview.insertRows(at: [IndexPath(row: 0, section: 0)], with: .top)
                tableview.endUpdates()
                strongSelf.mainView.searchBar.text = nil
            case .failure(let error):
                switch error {
                case WeatherRequestError.cityNotFound:
                    strongSelf.displayCityNotFoundAlert()
                default: return
                }
            }
        }
    }
    
    private func displayCityNotFoundAlert() {
        let alert = UIAlertController(title: nil, message: "La città inserita non è corretta", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    private func createTableViewDataSource() -> ArrayTableViewDataSource<WeatherCellViewModel> {
        let ds = ArrayTableViewDataSource<WeatherCellViewModel>(tableView: mainView.tableView!) { (tableView, indexPath, cellModel) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifier, for: indexPath) as! WeatherTableViewCell
            let colorsCount = UIColor.MaterialColors.allCases.count
            if cellModel.backgroundColor == nil {
                 cellModel.backgroundColor = UIColor.MaterialColors.allCases[self.searchHistory.count % colorsCount]
            }
            cell.configure(with: cellModel)
            cell.selectionStyle = .none
            return cell
        }
        ds.emptyMessageLabel.textColor = UIColor(named: "WeatherTableViewCellTextColor")
        ds.emptyMessage = "La cronologia è vuota."
        return ds
    }

}

extension MainViewController: MainViewDelegate {
    
    func userDidStartSearching(for text: String) {
        searchWeather(for: text)
    }
    
}

extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellModel = searchHistory[indexPath.row]
        return (cellModel.isContentExpanded) ? Constants.ExpandedCellHeight : Constants.CompactCellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? WeatherTableViewCell else { return }
        cell.layout = cell.layout.toggle()
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
}
