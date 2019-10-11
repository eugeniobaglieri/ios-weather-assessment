//
//  LoadingSearchBar.swift
//  weather-assessment
//
//  Created by Eugenio Baglieri on 11/10/2019.
//  Copyright © 2019 PED. All rights reserved.
//

import UIKit

class LoadingSearchBar: UISearchBar {

    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .white)
        indicator.hidesWhenStopped = true
        indicator.stopAnimating()
        return indicator
    }()
    
    var isLoading: Bool {
        get { return activityIndicator.isAnimating }
        set {
            if newValue == true {
                activityIndicator.isUserInteractionEnabled = false
                activityIndicator.startAnimating()
            } else {
                activityIndicator.stopAnimating()
                activityIndicator.isUserInteractionEnabled = true
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(activityIndicator)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addSubview(activityIndicator)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let indicatorSize = CGSize(width: bounds.height - 3, height: bounds.height - 3)
        activityIndicator.frame = CGRect(origin: .zero, size: indicatorSize)
        activityIndicator.center = center
    }
    
}
