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
    static let priceFormatter: NSNumberFormatter = {
        let formatter = NSNumberFormatter()
        
        formatter.formatterBehavior = .Behavior10_4
        formatter.numberStyle = .CurrencyStyle
        
        return formatter
    }()
    
    var buyButtonHandler: ((product: SKProduct) -> ())?
    
    var product: SKProduct? {
        didSet {
            guard let product = product else { return }
            
            textLabel?.text = product.localizedTitle

            if IAPHelper.canMakePayments() {
                accessoryType = .None
                accessoryView = self.newBuyButton()

                if let price = ProductCell.priceFormatter.stringFromNumber(product.price) {
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
        let button = UIButton(type: .System)
        button.setTitleColor(tintColor, forState: .Normal)
        button.setTitle("Buy", forState: .Normal)
        button.addTarget(self, action: #selector(ProductCell.buyButtonTapped(_:)), forControlEvents: .TouchUpInside)
        button.sizeToFit()
        
        return button
    }
    
    func buyButtonTapped(sender: AnyObject) {
        buyButtonHandler?(product: product!)
    }
}