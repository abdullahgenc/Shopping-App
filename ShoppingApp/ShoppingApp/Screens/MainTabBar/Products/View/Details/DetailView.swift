//
//  DetailView.swift
//  ShoppingApp
//
//  Created by Abdullah Genc on 31.10.2022.
//

import UIKit

protocol DetailViewDelegate: AnyObject {
    func addToBasket(_ view: DetailView)
    func addToFavorite(_ view: DetailView)
}

final class DetailView: UIView {
    
    weak var delegate: DetailViewDelegate?
    
    var id: Int? {
        didSet {
            idKeyLabel.text = "Product ID:    "
            idKeyLabel.font = .boldSystemFont(ofSize: 17.0)
            idLabel.text = id?.description ?? "0"
        }
    }
    
    var price: Double? {
        didSet {
            priceKeyLabel.text = "Price:    "
            priceKeyLabel.font = .boldSystemFont(ofSize: 17.0)
            priceLabel.text = "$\(price?.description ?? "0.0")"
        }
    }
    
    var category: String? {
        didSet {
            categoryKeyLabel.text = "Category:    "
            categoryKeyLabel.font = .boldSystemFont(ofSize: 17.0)
            categoryLabel.text = category ?? "-"
        }
    }
    
    var rate: Double? {
        didSet {
            rateKeyLabel.text = "Rate:    "
            rateKeyLabel.font = .boldSystemFont(ofSize: 17.0)
            rateLabel.text = "\(rate?.description ?? "0.0") / 5.0"
        }
    }
    
    var count: Int? {
        didSet {
            countKeyLabel.text = "Rate Count:    "
            countKeyLabel.font = .boldSystemFont(ofSize: 17.0)
            countLabel.text = count?.description ?? "0"
        }
    }
    
    var desc: String? {
        didSet {
            descKeyLabel.text = "Description:    "
            descKeyLabel.font = .boldSystemFont(ofSize: 17.0)
            descLabel.text = desc ?? "-"
        }
    }
    
    var stepperValue = Int()
    
    private(set) var imageView = UIImageView()
    
    private let idKeyLabel = UILabel()
    private let idLabel = UILabel()
    private lazy var idStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [idKeyLabel, UIView(), idLabel])
        stackView.axis = .horizontal
        return stackView
    }()
    
    private var priceKeyLabel = UILabel()
    private var priceLabel = UILabel()
    private lazy var priceStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [priceKeyLabel, UIView(), priceLabel])
        stackView.axis = .horizontal
        return stackView
    }()
    
    private var categoryKeyLabel = UILabel()
    private var categoryLabel = UILabel()
    private lazy var categoryStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [categoryKeyLabel, UIView(), categoryLabel])
        stackView.axis = .horizontal
        return stackView
    }()
    
    private var rateKeyLabel = UILabel()
    private var rateLabel = UILabel()
    private lazy var rateStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [rateKeyLabel, UIView(), rateLabel])
        stackView.axis = .horizontal
        return stackView
    }()
    
    private var countKeyLabel = UILabel()
    private var countLabel = UILabel()
    private lazy var countStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [countKeyLabel, UIView(), countLabel])
        stackView.axis = .horizontal
        return stackView
    }()
    
    private var descKeyLabel = UILabel()
    private var descLabel = UILabel()
    private lazy var descStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [descKeyLabel, UIView(), descLabel])
        stackView.axis = .horizontal
        return stackView
    }()
    
    private lazy var favoriteButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(didTapLikeButton), for: .touchUpInside)
        button.startAnimatingPressActions()
        button.layer.masksToBounds = true
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.red.cgColor
        button.layer.cornerRadius = 5.0
        button.backgroundColor = .white
        button.setImage(UIImage(named: "favorite"), for: .normal)
        button.tintColor = .red
        return button
    }()
    
    private lazy var addToBasketButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
        button.startAnimatingPressActions()
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 5.0
        button.backgroundColor = .orange
        button.titleLabel?.textColor = .white
        return button
    }()
    
    private lazy var basketStepper: UIStepper = {
        let stepper = UIStepper()
        stepper.addTarget(self, action: #selector(stepperValueChanged), for: .valueChanged)
        return stepper
    }()
    
    private lazy var piecesStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [addToBasketButton, basketStepper])
        stackView.axis = .horizontal
        stackView.spacing = 4.0
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        imageView.contentMode = .scaleAspectFit
        
        idLabel.numberOfLines = .zero
        priceLabel.numberOfLines = .zero
        categoryLabel.numberOfLines = .zero
        rateLabel.numberOfLines = .zero
        countLabel.numberOfLines = .zero
        descLabel.numberOfLines = .zero
        
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .systemGray2
        scrollView.layer.cornerRadius = 10.0
        
        let contentView = UIView()
        
        let productInfoStackView = UIStackView(arrangedSubviews: [idStackView, priceStackView,
                                                                  categoryStackView, rateStackView,
                                                                  countStackView, descStackView])
        productInfoStackView.axis = .vertical
        productInfoStackView.spacing = 8.0
        
        addToBasketButton.setTitle("Add to Basket (1 piece)", for: [])
        
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(8.0)
            make.width.height.equalTo(UIScreen.main.bounds.width * 0.8)
            make.centerX.equalToSuperview()
        }
        
        addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(safeAreaLayoutGuide.snp.width)
            make.top.equalTo(imageView.snp.bottom).offset(8.0)
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.centerX.equalTo(scrollView.snp.centerX)
            make.width.equalTo(scrollView.snp.width)
            make.top.equalTo(scrollView.snp.top).offset(32.0)
            make.bottom.equalTo(scrollView.snp.bottom).offset(-16.0)
        }
        
        contentView.addSubview(productInfoStackView)
        productInfoStackView.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.leading).offset(12.0)
            make.top.equalTo(contentView.snp.top)
            make.trailing.equalTo(contentView.snp.trailing).offset(-12.0)
            make.bottom.equalTo(contentView.snp.bottom)
        }
        
        addSubview(favoriteButton)
        favoriteButton.snp.makeConstraints { make in
            make.leading.equalTo(safeAreaLayoutGuide.snp.leading).offset(12.0)
            make.top.equalTo(scrollView.snp.bottom).offset(8.0)
            make.height.equalTo(favoriteButton.snp.width)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-16.0)
        }
        
        addSubview(piecesStackView)
        piecesStackView.snp.makeConstraints { make in
            make.leading.equalTo(favoriteButton.snp.trailing).offset(4.0)
            make.height.equalTo(favoriteButton.snp.height)
            make.trailing.equalTo(safeAreaLayoutGuide.snp.trailing).offset(-12.0)
            make.centerY.equalTo(favoriteButton.snp.centerY)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didTapLikeButton(_ sender: UIButton!) {
        sender.setImage(UIImage(named: "favorite-fill"), for: .normal)
        delegate?.addToFavorite(self)
    }
    
    @objc func didTapAddButton(_ sender: UIButton!) {
        delegate?.addToBasket(self)
    }
    
    @objc func stepperValueChanged(_ sender: UIStepper!) {
        stepperValue = Int(sender.value)
        if stepperValue == .zero {
            addToBasketButton.setTitle("Add to Basket (1 piece)", for: [])
        } else {
            addToBasketButton.setTitle("Add to Basket (\(Int(sender.value) + 1) pieces)", for: [])
        }
    }
}

