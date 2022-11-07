//
//  BasketViewController.swift
//  ShoppingApp
//
//  Created by Abdullah Genc on 6.11.2022.
//

import UIKit
import Kingfisher

final class BasketViewController: SAViewController {
    
    // MARK: - Properties
    private let mainView = BasketView()
    private var viewModel: BasketViewModel
    private var basketArray = [(String, Int)]()

    init(viewModel: BasketViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.delegate = self
        view = mainView
        mainView.setTableViewDelegate(self, andDataSource: self)
        title = "Basket"
        
        viewModel.changeHandler = {change in
            switch change {
            case .didErrorOccurred(let error):
                self.showError(error)
            }
        }
        viewModel.productIdAndCount() { error in
            if let error = error {
                self.showError(error)
            } else {
                self.basketArray = self.viewModel.tupleArray
                self.viewModel.fetchByIDs(idList: self.basketArray.map { $0.0 }) { error in
                    if let error = error {
                        self.showError(error)
                    } else {
                        self.mainView.price = self.viewModel.totalPriceOfProducts(idAndCounts: self.basketArray)
                    }
                    self.mainView.refresh()
                }
            }
        }
    }
}

// MARK: - UITableViewDelegate
extension BasketViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("ITEM-\(indexPath.row) TAPPED")
    }
}

// MARK: - UITableViewDataSource
extension BasketViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfItems
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! BasketTableViewCell
        
        let product = viewModel.productForIndexPath(indexPath)
        let countForID = basketArray.filter({ $0.0 == String((product?.id)!) })
        let initialCount = countForID[.zero].1
        
        cell.delegate = self
        cell.selectionStyle = .none
        cell.tag = (product?.id)!
        cell.productImageView.kf.setImage(with: URL(string: (product?.image)!))
        cell.title = product?.title
        cell.count = initialCount
        cell.price = product?.price
        return cell
    }
}

extension BasketViewController: BasketTableViewCellDelegate {
    func updateBasket(for cell: BasketTableViewCell, with sender: UIStepper!) {
        
        let productID = "\(cell.tag)"
        
        if sender.value == .zero {
            showAlert(title: "Warning", message: "Are you sure to remove item from basket?", cancelButtonTitle: "Cancel") { _ in
                print("ITEM REMOVED FROM BASKET")
                self.viewModel.deleteItemFromBasket(productID) { error in
                    if let error = error {
                        self.showError(error)
                    } else {
                        cell.isRemoveConfirmed = true
                        UIView.transition(with: self.view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
                          cell.removeFromSuperview()
                        }, completion: nil)
                        if let index = self.basketArray.firstIndex(where: { $0.0 == productID }) {
                            self.basketArray.remove(at: index)
                        }
                        self.mainView.price = self.viewModel.totalPriceOfProducts(idAndCounts: self.basketArray)
                        self.mainView.refresh()
                    }
                }
            }
            if cell.isRemoveConfirmed == false {
                sender.value += 1.0
                cell.stepperValue = Int(sender.value)
            }
        } else {
            var updateData = [String: Int]()
            updateData[productID] = cell.stepperValue
            viewModel.updateBasket(updateData) { error in
                if let error = error {
                    self.showError(error)
                } else {
                    if let index = self.basketArray.firstIndex(where: { $0.0 == productID }) {
                        self.basketArray[index].1 = updateData[productID]!
                    }
                    self.mainView.price = self.viewModel.totalPriceOfProducts(idAndCounts: self.basketArray)
                    self.mainView.refresh()
                }
            }
        }
    }
}

extension BasketViewController: BasketViewDelegate {
    func completeOrder(for view: BasketView, with sender: UIButton!) {
        let numberOfItems = viewModel.numberOfItems
        showAlert(title: "Warning", message: "Are you sure to complete order?", cancelButtonTitle: "Cancel") { _ in
            self.showAlert(title: "COMPLETE ORDER SUCCESSFUL!") { _ in
                self.viewModel.deleteAll() { error in
                    if let error = error {
                        self.showError(error)
                    } else {
                        if numberOfItems > 0 {
                            var indexArray = [IndexPath]()
                            for index in 0...numberOfItems - 1 {
                                indexArray.append(IndexPath(item: index, section: .zero))
                            }
                            self.basketArray = []
                            view.deleteRows(indexPath: indexArray)
                            self.mainView.price = self.viewModel.totalPriceOfProducts(idAndCounts: self.basketArray)
                            self.mainView.refresh()
                        }
                        self.dismiss(animated: true)
                    }
                }
            }
        }
    }
}
