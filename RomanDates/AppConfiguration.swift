//
//  AppConfiguration.swift
//  RomanDates
//
//  Created by Robert Clarke on 22/05/2016.
//
//

import Foundation

public enum SeparatorSymbol: Int {
    case Dot, Dash, Slash, Space

    var character: String {
        get {
            switch self {
            case .Dot: return "·"
            case .Dash: return "−"
            case .Slash: return "/"
            case .Space: return " "
            }
        }
    }
}

public class AppConfiguration {
    private struct Defaults {
        static let firstLaunchKey = "AppConfiguration.Defaults.firstLaunchKey"
        static let showYearKey = "AppConfiguration.Defaults.showYearKey"
        static let showFullYearKey = "AppConfiguration.Defaults.showFullYearKey"
        static let automaticDateFormatKey = "AppConfiguration.Defaults.automaticDateFormatKey"
        static let dateFormatKey = "AppConfiguration.Defaults.dateFormatKey"
        static let usePasteboardKey = "AppConfiguration.Defaults.usePasteboardKey"
        static let separatorSymbolKey = "AppConfiguration.Defaults.separatorSymbolKey"
    }
    
    public class var sharedConfiguration: AppConfiguration {
        struct Singleton {
            static let sharedAppConfiguration = AppConfiguration()
        }
        
        return Singleton.sharedAppConfiguration
    }
    
    public func runHandlerOnFirstLaunch(firstLaunchHandler: Void -> Void) {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        let defaultOptions: [String: AnyObject] = [
            Defaults.firstLaunchKey: true,
            Defaults.showYearKey: true,
            Defaults.showFullYearKey: true,
            Defaults.automaticDateFormatKey: true,
            Defaults.dateFormatKey: 0,
            Defaults.usePasteboardKey: true,
            Defaults.separatorSymbolKey: 0
        ]
        
        defaults.registerDefaults(defaultOptions)
        
        if defaults.boolForKey(Defaults.firstLaunchKey) {
            defaults.setBool(false, forKey: Defaults.firstLaunchKey)
            
            firstLaunchHandler()
        }
    }
    
    public var showYear: Bool {
        get {
            let value = NSUserDefaults.standardUserDefaults().boolForKey(Defaults.showYearKey)
            
            return value
        }

        set {
            NSUserDefaults.standardUserDefaults().setBool(newValue, forKey: Defaults.showYearKey)
        }
    }

    public var showFullYear: Bool {
        get {
            let value = NSUserDefaults.standardUserDefaults().boolForKey(Defaults.showFullYearKey)
            
            return value
        }

        set {
            NSUserDefaults.standardUserDefaults().setBool(newValue, forKey: Defaults.showFullYearKey)
        }
    }

    public var automaticDateFormat: Bool {
        get {
            let value = NSUserDefaults.standardUserDefaults().boolForKey(Defaults.automaticDateFormatKey)

            return value
        }

        set {
            NSUserDefaults.standardUserDefaults().setBool(newValue, forKey: Defaults.automaticDateFormatKey)
        }
    }
    
    public var dateFormat: DateOrder {
        get {
            let value = NSUserDefaults.standardUserDefaults().integerForKey(Defaults.dateFormatKey)

            guard let dateOrder = DateOrder(rawValue: value) else {
                return DateOrder.DayFirst
            }

            return dateOrder
        }

        set {
            NSUserDefaults.standardUserDefaults().setObject(newValue.rawValue, forKey: Defaults.dateFormatKey)
        }
    }

    public var usePasteboard: Bool {
        get {
            let value = NSUserDefaults.standardUserDefaults().boolForKey(Defaults.usePasteboardKey)
            
            return value
        }
        
        set {
            NSUserDefaults.standardUserDefaults().setBool(newValue, forKey: Defaults.usePasteboardKey)
        }
    }

    public var separatorSymbol: SeparatorSymbol {
        get {
            let value = NSUserDefaults.standardUserDefaults().integerForKey(Defaults.separatorSymbolKey)

            guard let symbol = SeparatorSymbol(rawValue: value) else {
                return SeparatorSymbol.Dot
            }

            return symbol
        }

        set {
            NSUserDefaults.standardUserDefaults().setObject(newValue.rawValue, forKey: Defaults.separatorSymbolKey)
        }
    }

}