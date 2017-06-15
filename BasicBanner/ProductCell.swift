//
//  ProductCell.swift
//  RomanDates
//
//  Created by Robert Clarke on 20/05/2016.
//  Copyright © 2016 Robert Clarke. All rights reserved.
//

import UIKit
import StoreKit

class ProductCell: UITableViewCell {
    static let priceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        
        formatter.formatterBehavior = .behavior10_4
        formatter.numberStyle = .currency
        
        return formatter
    }()
    
    var buyButtonHandler: ((_ product: SKProduct) -> ())?
    
    var product: SKProduct? {
        didSet {
            guard let product = product else { return }
            
            textLabel?.text = product.localizedTitle

            if IAPHelper.canMakePayments() {
                accessoryType = .none
                accessoryView = self.newBuyButton()

                if let price = ProductCell.priceFormatter.string(from: product.price) {
                    if RomanDatesProducts.store.isProductPurchased(product.productIdentifier) {
                        detailTextLabel?.text = price + " ✓"
                    } else {
                        detailTextLabel?.text = price
                    }
                } else {
                    detailTextLabel?.text = "Unknown"
                }
            } else {
                detailTextLabel?.text = "Not available"
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        textLabel?.text = ""
        detailTextLabel?.text = ""
        accessoryView = nil
    }
    
    func newBuyButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitleColor(tintColor, for: UIControlState())
        button.setTitle("Buy", for: UIControlState())
        button.addTarget(self, action: #selector(ProductCell.buyButtonTapped(_:)), for: .touchUpInside)
        button.sizeToFit()
        
        return button
    }
    
    func buyButtonTapped(_ sender: AnyObject) {
        buyButtonHandler?(product!)
    }
}
