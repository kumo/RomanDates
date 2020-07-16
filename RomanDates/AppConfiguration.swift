//
//  AppConfiguration.swift
//  RomanDates
//
//  Created by Robert Clarke on 22/05/2016.
//
//

import Foundation

public enum SeparatorSymbol: Int {
    case dot, dash, slash, space

    var character: String {
        get {
            switch self {
            case .dot: return "·"
            case .dash: return "−"
            case .slash: return "/"
            case .space: return " "
            }
        }
    }
}

open class AppConfiguration {
    fileprivate struct Defaults {
        static let firstLaunchKey = "AppConfiguration.Defaults.firstLaunchKey"
        static let showYearKey = "AppConfiguration.Defaults.showYearKey"
        static let showFullYearKey = "AppConfiguration.Defaults.showFullYearKey"
        static let automaticDateFormatKey = "AppConfiguration.Defaults.automaticDateFormatKey"
        static let dateFormatKey = "AppConfiguration.Defaults.dateFormatKey"
        static let usePasteboardKey = "AppConfiguration.Defaults.usePasteboardKey"
        static let pasteboardChangeCountKey = "AppConfiguration.Defaults.pasteboardChangeCountKey"
        static let separatorSymbolKey = "AppConfiguration.Defaults.separatorSymbolKey"
    }
    
    open class var sharedConfiguration: AppConfiguration {
        struct Singleton {
            static let sharedAppConfiguration = AppConfiguration()
        }
        
        return Singleton.sharedAppConfiguration
    }
    
    open func runHandlerOnFirstLaunch(_ firstLaunchHandler: () -> Void) {
        let defaults = UserDefaults.standard
        
        let defaultOptions: [String: AnyObject] = [
            Defaults.firstLaunchKey: true as AnyObject,
            Defaults.showYearKey: true as AnyObject,
            Defaults.showFullYearKey: true as AnyObject,
            Defaults.automaticDateFormatKey: true as AnyObject,
            Defaults.dateFormatKey: 0 as AnyObject,
            Defaults.usePasteboardKey: true as AnyObject,
            Defaults.pasteboardChangeCountKey: 0 as AnyObject, // not so sure about this logic
            Defaults.separatorSymbolKey: 0 as AnyObject,
        ]
        
        defaults.register(defaults: defaultOptions)
        
        if defaults.bool(forKey: Defaults.firstLaunchKey) {
            defaults.set(false, forKey: Defaults.firstLaunchKey)
            
            firstLaunchHandler()
        }
    }
    
    open var showYear: Bool {
        get {
            let value = UserDefaults.standard.bool(forKey: Defaults.showYearKey)
            
            return value
        }

        set {
            UserDefaults.standard.set(newValue, forKey: Defaults.showYearKey)
        }
    }

    open var showFullYear: Bool {
        get {
            let value = UserDefaults.standard.bool(forKey: Defaults.showFullYearKey)
            
            return value
        }

        set {
            UserDefaults.standard.set(newValue, forKey: Defaults.showFullYearKey)
        }
    }

    open var automaticDateFormat: Bool {
        get {
            let value = UserDefaults.standard.bool(forKey: Defaults.automaticDateFormatKey)

            return value
        }

        set {
            UserDefaults.standard.set(newValue, forKey: Defaults.automaticDateFormatKey)
        }
    }
    
    open var dateFormat: DateOrder {
        get {
            let value = UserDefaults.standard.integer(forKey: Defaults.dateFormatKey)

            guard let dateOrder = DateOrder(rawValue: value) else {
                return DateOrder.dayFirst
            }

            return dateOrder
        }

        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: Defaults.dateFormatKey)
        }
    }

    open var usePasteboard: Bool {
        get {
            let value = UserDefaults.standard.bool(forKey: Defaults.usePasteboardKey)
            
            return value
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: Defaults.usePasteboardKey)
        }
    }

    open var pasteboardChangeCount: Int {
        get {
            let value = UserDefaults.standard.integer(forKey: Defaults.pasteboardChangeCountKey)

            return value
        }

        set {
            UserDefaults.standard.set(newValue, forKey: Defaults.pasteboardChangeCountKey)
        }
    }

    open var separatorSymbol: SeparatorSymbol {
        get {
            let value = UserDefaults.standard.integer(forKey: Defaults.separatorSymbolKey)

            guard let symbol = SeparatorSymbol(rawValue: value) else {
                return SeparatorSymbol.dot
            }

            return symbol
        }

        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: Defaults.separatorSymbolKey)
        }
    }

}
