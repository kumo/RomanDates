//
//  UserSettings.swift
//  RomanDates
//
//  Created by Robert Clarke on 09/05/2020.
//  Copyright © 2020 Robert Clarke. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

class UserSettings: ObservableObject {
    
    @Published var useDeviceDateOrder: Bool {
        didSet {
            UserDefaults.standard.set(useDeviceDateOrder, forKey: "AppConfiguration.Defaults.automaticDateFormatKey")
        }
    }
    
    @Published var dateOrder: Int {
        didSet {
            UserDefaults.standard.set(dateOrder, forKey: "AppConfiguration.Defaults.dateFormatKey")
        }
    }
    
    @Published var showYear: Bool {
        didSet {
            UserDefaults.standard.set(showYear, forKey: "AppConfiguration.Defaults.showYearKey")
        }
    }
    
    @Published var showFullYear: Bool {
        didSet {
            UserDefaults.standard.set(showFullYear, forKey: "AppConfiguration.Defaults.showFullYearKey")
        }
    }
    
    @Published var symbolSeparator: Int {
        didSet {
            UserDefaults.standard.set(symbolSeparator, forKey: "AppConfiguration.Defaults.separatorSymbolKey")
        }
    }

    @Published var usePasteboard: Bool {
        didSet {
            UserDefaults.standard.set(usePasteboard, forKey: "AppConfiguration.Defaults.usePasteboardKey")
        }
    }

    // should be able to return a description of the date based on the locale and whatnot
    var dateFormatter: RomanDateFormatter {
        get {
            var result: RomanDateFormatter = .dayMonthYear

            if (self.useDeviceDateOrder) {
                result = Locale.current.newDateOrder()
            } else {
                result = RomanDateFormatter.init(rawValue: dateOrder) ?? .dayMonthYear
            }

            if self.showYear == false {
                result.removeYear()
            } else if self.showFullYear == false {
                result.useShortYear()
            }

            return result
        }
    }
    
    init() {
        /*
         static let firstLaunchKey = "AppConfiguration.Defaults.firstLaunchKey"
         static let showYearKey = "AppConfiguration.Defaults.showYearKey"
         static let showFullYearKey = "AppConfiguration.Defaults.showFullYearKey"
         static let automaticDateFormatKey = "AppConfiguration.Defaults.automaticDateFormatKey"
         static let dateFormatKey = "AppConfiguration.Defaults.dateFormatKey"
         static let usePasteboardKey = "AppConfiguration.Defaults.usePasteboardKey"
         static let pasteboardChangeCountKey = "AppConfiguration.Defaults.pasteboardChangeCountKey"
         static let separatorSymbolKey = "AppConfiguration.Defaults.separatorSymbolKey"
         */
        self.useDeviceDateOrder = UserDefaults.standard.object(forKey: "AppConfiguration.Defaults.automaticDateFormatKey") as? Bool ?? true
        self.dateOrder = UserDefaults.standard.object(forKey: "AppConfiguration.Defaults.dateFormatKey") as? Int ?? 0
        self.showYear = UserDefaults.standard.object(forKey: "AppConfiguration.Defaults.showYearKey") as? Bool ?? true
        self.showFullYear = UserDefaults.standard.object(forKey: "AppConfiguration.Defaults.showFullYearKey") as? Bool ?? true
        self.symbolSeparator = UserDefaults.standard.object(forKey: "AppConfiguration.Defaults.separatorSymbolKey") as? Int ?? 3
        self.usePasteboard = UserDefaults.standard.object(forKey: "AppConfiguration.Defaults.usePasteboardKey") as? Bool ?? true
    }
}
