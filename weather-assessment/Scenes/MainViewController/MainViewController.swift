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
    
    lazy var dataProvider: WeatherDataProvider = WeatherDataProvider(persistentContainer: CoreDataManager.default.persistentContainer)
    
    var searchHistory: [WeatherInformation] = []
    
    var frc: NSFetchedResultsController<CachedWeather>!
    
    private var mainView: MainView { return view as! MainView }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.delegate = self
        navigationItem.titleView = mainView.searchBar
        mainView.tableView.register(UINib(nibName: "WeatherTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        mainView.tableView.dataSource = self
        mainView.tableView.delegate = self
    }
    
    private func searchWeather(for city: String) {
        dataProvider.fetchWeatherForCityWithName(city) { result in
            switch result {
            case .success(let weatherInfo):
                print(weatherInfo)
                self.searchHistory.insert(weatherInfo, at: 0)
                self.mainView.tableView.reloadData()
            case .failure(let error):
                if case WeatherRequestError.cancelled = error {
                    return
                }
            }
        }
    }

}

extension MainViewController: MainViewDelegate {
    
    func userDidStartSearching(for text: String) {
        searchWeather(for: text)
    }
    
}


extension MainViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! WeatherTableViewCell
        let cellModel = WeatherCellViewModel(weatherInfo: searchHistory[indexPath.row])
        cell.configure(with: cellModel)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let cell = tableView.cellForRow(at: indexPath) as? WeatherTableViewCell else { return 80}
        switch cell.layout {
        case .compact: return 80
        case .expanded: return 229
        }
    }
    
}

extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? WeatherTableViewCell else { return }
        cell.layout = cell.layout.toggle()
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
}
