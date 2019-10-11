//
//  WeatherTableViewCell.swift
//  weather-assessment
//
//  Created by Eugenio Baglieri on 09/10/2019.
//  Copyright © 2019 PED. All rights reserved.
//

import UIKit
import Kingfisher

protocol WeatherViewable {
    func configure(with cellModel: WeatherCellViewModel)
    func clean()
}

enum LayoutType {
    case compact
    case expanded
    
    func toggle() -> LayoutType {
        switch self {
        case .compact: return .expanded
        case .expanded: return .compact
        }
    }
}

class WeatherTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var containerView: UIView!
    
    @IBOutlet private var compactContent: CompactLayoutView! {
        willSet {
            newValue.removeFromSuperview()
            newValue.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    @IBOutlet private var expandedContent: ExpandedLayoutView! {
        willSet {
            newValue.removeFromSuperview()
            newValue.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private(set) var viewModel: WeatherCellViewModel!
    
    var layout: LayoutType = .compact {
        didSet {
           updateLayout()
        }
    }
    
    private func updateLayout() {
        guard let viewModel = viewModel else { return }
        switch layout {
        case .compact:
            viewModel.isContentExpanded = false
            compactContent.configure(with: viewModel)
            attachView(compactContent)
            expandedContent.removeFromSuperview()
            expandedContent.clean()
        case .expanded:
            viewModel.isContentExpanded = true
            expandedContent.configure(with: viewModel)
            attachView(expandedContent)
            compactContent.removeFromSuperview()
            compactContent.clean()
        }
        
    }
    
    private func attachView(_ view: UIView) {
        containerView.addSubview(view)
        view.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        layout = .compact
        clean()
    }
    
}

extension WeatherTableViewCell: WeatherViewable {
    
    func configure(with cellModel: WeatherCellViewModel) {
        viewModel = cellModel
        containerView.backgroundColor = viewModel.backgroundColor
        backgroundColor = viewModel.backgroundColor
        updateLayout()
    }
    
    func clean() {
        compactContent.clean()
        expandedContent.clean()
        viewModel = nil
    }
    
}

class CompactLayoutView: UIView {
    @IBOutlet private weak var weatherImageView: UIImageView!
    @IBOutlet private weak var cityNameLabel: UILabel!
    @IBOutlet private weak var temperatureLabel: UILabel!
}

extension CompactLayoutView: WeatherViewable {
    
    func configure(with cellModel: WeatherCellViewModel) {
        cityNameLabel.text = cellModel.cityName
        temperatureLabel.text = cellModel.temperature
        if let iconUrl = cellModel.weatherIconUrl {
            weatherImageView.kf.setImage(with: iconUrl, placeholder: UIImage(named: "unknown-weather-icon"))
        }
    }
    
    func clean() {
        weatherImageView.image = nil
        cityNameLabel.text = nil
        temperatureLabel.text = nil
        weatherImageView.kf.cancelDownloadTask()
        weatherImageView.image = nil
    }
}

class ExpandedLayoutView: UIView {
    @IBOutlet private weak var weatherImageView: UIImageView!
    @IBOutlet private weak var weatherDescriptionLabel: UILabel!
    @IBOutlet private weak var cityNameLabel: UILabel!
    @IBOutlet private weak var temperatureLabel: UILabel!
    @IBOutlet private weak var humidityLabel: UILabel!
    @IBOutlet private weak var pressureLabel: UILabel!
}

extension ExpandedLayoutView: WeatherViewable {
    
    func configure(with cellModel: WeatherCellViewModel) {
        cityNameLabel.text = cellModel.cityName
        weatherDescriptionLabel.text = cellModel.weatherDescription
        temperatureLabel.text = cellModel.temperature
        pressureLabel.text = cellModel.pressure
        humidityLabel.text = cellModel.humidity
        if let iconUrl = cellModel.weatherIconUrl {
            weatherImageView.kf.setImage(with: iconUrl, placeholder: UIImage(named: "unknown-weather-icon"))
        }
    }
    
    func clean() {
        weatherImageView.image = nil
        cityNameLabel.text = nil
        weatherDescriptionLabel.text = nil
        temperatureLabel.text = nil
        pressureLabel.text = nil
        humidityLabel.text = nil
        weatherImageView.kf.cancelDownloadTask()
        weatherImageView.image = nil
    }
}
