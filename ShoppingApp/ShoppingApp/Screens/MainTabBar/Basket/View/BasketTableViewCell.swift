//
//  BasketTableViewCell.swift
//  ShoppingApp
//
//  Created by Abdullah Genc on 6.11.2022.
//

import UIKit

protocol BasketTableViewCellDelegate: AnyObject {
    func updateBasket(for cell: BasketTableViewCell, with sender: UIStepper!)
}

final class BasketTableViewCell: UITableViewCell {
    
    weak var delegate: BasketTableViewCellDelegate?
    
    var image: UIImage? {
        didSet {
            productImageView.image = image
        }
    }
    
    var title: String? {
        didSet {
            productNameLabel.text = title
        }
    }
    
    var count: Int? {
        didSet {
            basketStepper.value = Double(count ?? .zero)
            stepperValueLabel.text = String(count ?? .zero)
        }
    }
    
    var price: Double? {
        didSet {
            var result = (price ?? .zero) * basketStepper.value
            result = round(result * 100)/100.0
            priceLabel.text = "$\(result)"
        }
    }
    
    var stepperValue = Int()
    
    var isRemoveConfirmed = false
    
    private(set) lazy var productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8.0
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 0.5
        imageView.layer.borderColor = UIColor.black.cgColor
        return imageView
    }()
    
    private lazy var productNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = .zero
        label.textColor = .red
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var productInfoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [productNameLabel, priceLabel])
        stackView.axis = .vertical
        stackView.spacing = 8.0
        stackView.layer.masksToBounds = true
        stackView.layer.cornerRadius = 8.0
        stackView.backgroundColor = .systemGray6
        return stackView
    }()
    
    private lazy var stepperValueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .center
//        label.text = "0"
        return label
    }()
    
    private lazy var basketStepper: UIStepper = {
        let stepper = UIStepper()
        stepper.minimumValue = .zero
        stepper.maximumValue = 15.0
        stepper.stepValue = 1.0
        stepper.addTarget(self, action: #selector(stepperValueChanged), for: .valueChanged)
        return stepper
    }()
    
    private lazy var stepperStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [stepperValueLabel, basketStepper])
        stackView.axis = .vertical
        stackView.spacing = .zero
        stackView.distribution = .fillEqually
        stackView.layer.masksToBounds = true
        stackView.layer.cornerRadius = 8.0
        stackView.backgroundColor = .systemGray5
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(productImageView)
        contentView.addSubview(productInfoStackView)
        contentView.addSubview(stepperStackView)
        
        productImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8.0)
            make.bottom.equalToSuperview().offset(-8.0)
            make.leading.equalToSuperview().offset(8.0)
            make.width.equalTo(UIScreen.main.bounds.width * 0.25)
            make.height.equalTo(UIScreen.main.bounds.width * 0.25).priority(.high)
        }
        
        productInfoStackView.snp.makeConstraints { make in
            make.centerY.equalTo(productImageView.snp.centerY)
            make.leading.equalTo(productImageView.snp.trailing).offset(8.0)
        }
        
        stepperStackView.snp.makeConstraints { make in
            make.centerY.equalTo(productImageView.snp.centerY)
            make.width.equalTo(UIScreen.main.bounds.width * 0.24)
            make.leading.equalTo(productInfoStackView.snp.trailing).offset(8.0)
            make.trailing.equalToSuperview().offset(-8.0)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func stepperValueChanged(_ sender: UIStepper!) {
        stepperValue = Int(sender.value)
        self.delegate?.updateBasket(for: self, with: sender)
        if !isRemoveConfirmed {
            stepperValueLabel.text = "\(stepperValue)"
            var result = (price ?? .zero) * Double(stepperValue)
            result = round(result * 100)/100.0
            priceLabel.text = "$\(result)"
        }
    }
}
