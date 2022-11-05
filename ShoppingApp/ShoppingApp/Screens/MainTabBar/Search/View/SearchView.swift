//
//  SearchView.swift
//  ShoppingApp
//
//  Created by Abdullah Genc on 2.11.2022.
//

import UIKit

class SearchView: UIView {

    private lazy var tableView = UITableView()

    // MARK: - Init
    init() {
        super.init(frame: .zero)
        backgroundColor = .white
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: "cell")
        
        addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    func setTableViewDelegate(_ delegate: UITableViewDelegate,
                                   andDataSource dataSource: UITableViewDataSource) {
        tableView.delegate = delegate
        tableView.dataSource = dataSource
    }
    
    func refresh() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
