//
//  SwiftUIViewHostingController.swift
//  RomanDates
//
//  Created by Robert Clarke on 21/11/2020.
//

import Foundation
import SwiftUI

//Create a UIHostingController class that hosts your SwiftUI view
class SwiftUIViewHostingController: UIHostingController<NewConverterSettingsView> {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder, rootView: NewConverterSettingsView())
    }
}
