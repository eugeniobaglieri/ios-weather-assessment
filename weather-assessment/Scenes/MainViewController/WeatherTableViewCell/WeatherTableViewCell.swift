//
//  WeatherTableViewCell.swift
//  weather-assessment
//
//  Created by Eugenio Baglieri on 09/10/2019.
//  Copyright © 2019 PED. All rights reserved.
//

import UIKit

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
            
        }
    }
    
    @IBOutlet private var expandedContent: ExpandedLayoutView! {
        willSet {
            newValue.removeFromSuperview()
        }
    }
    
    private(set) var viewModel: WeatherCellViewModel!
    
    var layout: LayoutType = .compact {
        didSet {
           updateLayout()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let content: UIView
        if compactContent.superview != nil {
            content = compactContent
        } else {
            content = expandedContent
        }
        content.frame = contentView.bounds
    }
    
    private func updateLayout() {
        guard let viewModel = viewModel else { return }
        switch layout {
        case .compact:
            compactContent.configure(with: viewModel)
            contentView.addSubview(compactContent)
            expandedContent.removeFromSuperview()
            expandedContent.clean()
        case .expanded:
            expandedContent.configure(with: viewModel)
            contentView.addSubview(expandedContent)
            compactContent.removeFromSuperview()
            compactContent.clean()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        clean()
    }
    
}

extension WeatherTableViewCell: WeatherViewable {
    
    func configure(with cellModel: WeatherCellViewModel) {
        viewModel = cellModel
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
    }
    
    func clean() {
        weatherImageView.image = nil
        cityNameLabel.text = nil
        temperatureLabel.text = nil
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
    }
    
    func clean() {
        weatherImageView.image = nil
        cityNameLabel.text = nil
        weatherDescriptionLabel.text = nil
        temperatureLabel.text = nil
        pressureLabel.text = nil
        humidityLabel.text = nil
    }
}
