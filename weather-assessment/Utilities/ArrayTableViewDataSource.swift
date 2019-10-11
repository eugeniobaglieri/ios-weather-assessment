//
//  ArrayTableViewDataSource.swift
//  weather-assessment
//
//  Created by Eugenio Baglieri on 10/10/2019.
//  Copyright © 2019 PED. All rights reserved.
//

import UIKit

class ArrayTableViewDataSource<Item>: NSObject, UITableViewDataSource {
    
    typealias CellProvider = (UITableView, IndexPath, Item) -> UITableViewCell
    typealias HeightProvider = (UITableView, IndexPath, Item) -> CGFloat
    
    private weak var tableView: UITableView?
    
    var cellProvider: CellProvider
    
    private(set) lazy var emptyMessageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    var items = [Item]()
    
    var emptyMessage: String? {
        didSet {
            emptyMessageLabel.text = emptyMessage
            emptyMessageLabel.sizeToFit()
        }
    }
    
    init(tableView: UITableView, cellProvider: @escaping CellProvider) {
        self.tableView = tableView
        self.cellProvider = cellProvider
    }
    
    func item(for indexPath: IndexPath) -> Item? {
        return items[indexPath.row]
    }
    
    private func showEmptyMessage(_ show: Bool) {
        if show {
            if let _ = emptyMessage {
                tableView?.addSubview(emptyMessageLabel)
                emptyMessageLabel.center = tableView?.center ?? .zero
            }
        } else {
            if emptyMessageLabel.superview != nil {
                emptyMessageLabel.removeFromSuperview()
            }
        }
    }
    
    // MARK: - ArrayTableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = items.count
        showEmptyMessage(count == 0)
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellProvider(tableView, indexPath, items[indexPath.row])
    }
    
}
