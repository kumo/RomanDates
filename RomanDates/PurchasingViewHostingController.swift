//
//  PurchasingViewHostingController.swift
//  RomanDates
//
//  Created by Robert Clarke on 14/06/21.
//

import Foundation

import SwiftUI

//Create a UIHostingController class that hosts your SwiftUI view
class PurchasingViewHostingController: UIHostingController<PurchasingView> {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder, rootView: PurchasingView())
    }
}
