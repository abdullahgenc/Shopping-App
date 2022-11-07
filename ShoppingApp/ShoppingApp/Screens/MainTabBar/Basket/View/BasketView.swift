//
//  BasketView.swift
//  ShoppingApp
//
//  Created by Abdullah Genc on 6.11.2022.
//

import UIKit

protocol BasketViewDelegate: AnyObject {
    func completeOrder(for view: BasketView, with sender: UIButton!)
}

final class BasketView: UIView {

    weak var delegate: BasketViewDelegate?
    
    private lazy var tableView = UITableView()

    var price: Double? {
        didSet {
            totalPriceButton.setTitle("$\(price ?? .zero)", for: [])
        }
    }
    
    private lazy var completeOrderButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(didTapOrderButton), for: .touchUpInside)
        button.startAnimatingPressActions()
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 8.0
        button.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        button.setTitle("Complete Order", for: [])
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.titleLabel?.textColor = .white
        button.backgroundColor = .orange
        button.titleLabel?.textAlignment = .center
        return button
    }()
    
    private lazy var totalPriceButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(didTapOrderButton), for: .touchUpInside)
        button.startAnimatingPressActions()
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 8.0
        button.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        button.setTitle("$0.0", for: [])
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.titleLabel?.textColor = .white
        button.backgroundColor = .purple
        button.titleLabel?.textAlignment = .center
        return button
    }()
    
    // MARK: - Init
    init() {
        super.init(frame: .zero)
        backgroundColor = .white
        tableView.register(BasketTableViewCell.self, forCellReuseIdentifier: "cell")
        
        addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(24.0)
        }
        
        addSubview(completeOrderButton)
        completeOrderButton.snp.makeConstraints { make in
            make.leading.equalTo(safeAreaLayoutGuide.snp.leading).offset(8.0)
            make.top.equalTo(tableView.snp.bottom).offset(24.0)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-24.0)
            make.height.equalTo(48.0)
        }
        
        addSubview(totalPriceButton)
        totalPriceButton.snp.makeConstraints { make in
            make.leading.equalTo(completeOrderButton.snp.trailing)
            make.trailing.equalTo(safeAreaLayoutGuide.snp.trailing).offset(-8.0)
            make.height.equalTo(completeOrderButton.snp.height)
            make.centerY.equalTo(completeOrderButton.snp.centerY)
            make.width.equalTo(completeOrderButton.snp.width).multipliedBy(0.3)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    @objc func didTapOrderButton(_ sender: UIButton!) {
        self.delegate?.completeOrder(for: self, with: sender)
    }
    
    func setTableViewDelegate(_ delegate: UITableViewDelegate,
                                   andDataSource dataSource: UITableViewDataSource) {
        tableView.delegate = delegate
        tableView.dataSource = dataSource
    }
    
    func deleteRows(indexPath: [IndexPath]) {
        tableView.deleteRows(at: indexPath, with: .automatic)
    }
    
    func refresh() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
