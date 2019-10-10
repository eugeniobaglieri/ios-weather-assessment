//
//  MainViewControllerView.swift
//  weather-assessment
//
//  Created by Eugenio Baglieri on 09/10/2019.
//  Copyright © 2019 PED. All rights reserved.
//

import UIKit

protocol MainViewDelegate: class {
    func userDidStartSearching(for text: String)
}

class MainView: UIView {
    
    @IBOutlet private(set) weak var searchBar: UISearchBar! {
        willSet { newValue.delegate = self }
    }
    
    @IBOutlet private(set) weak var tableView: UITableView!
    
    weak var delegate: MainViewDelegate?
    
}

extension MainView: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        delegate?.userDidStartSearching(for: text)
    }
    
}
