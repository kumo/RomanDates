//
//  RomanDatesProducts.swift
//  RomanDates
//
//  Created by Robert Clarke on 20/05/2016.
//  Copyright © 2016 Robert Clarke. All rights reserved.
//

import Foundation

public struct RomanDatesProducts {
    
    fileprivate static let Prefix = "it.kumo.RomanDates."
    
    public static let NiceTip = Prefix + "tip1"
    public static let GreatTip = Prefix + "tip2"
    public static let MassiveTip = Prefix + "tip5"
    
    fileprivate static let productIdentifiers: Set<ProductIdentifier> = [RomanDatesProducts.NiceTip,
                                                                     RomanDatesProducts.GreatTip,
                                                                     RomanDatesProducts.MassiveTip]
    
    public static let store = IAPHelper(productIds: RomanDatesProducts.productIdentifiers)
}

func resourceNameForProductIdentifier(_ productIdentifier: String) -> String? {
    return productIdentifier.components(separatedBy: ".").last
}
