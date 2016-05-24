//
//  Converter.swift
//  RomanDates
//
//  Created by Robert Clarke on 29/10/2015.
//
//

import Foundation

public enum DateOrder: Int {
    case DayFirst, MonthFirst, YearFirst
}

extension Int {
    func toRoman() -> String? {
        guard self > 0 else {
            return nil
        }

        var number = self
        
        let values = [("M", 1000), ("CM", 900), ("D", 500), ("CD", 400), ("C",100), ("XC", 90), ("L",50), ("XL",40), ("X",10), ("IX", 9), ("V",5),("IV",4), ("I",1)]
        
        var result = ""

        for (romanChar, arabicValue) in values {
            let count = number / arabicValue
            
            if count == 0 { continue }
            
            for _ in 1...count
            {
                result += romanChar
                number -= arabicValue
            }
        }
        
        return result
    }
}

extension NSDate {
    func dateInRoman() -> (day:String, month:String, year:String, shortYear:String?) {
        
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Year, .Month, .Day], fromDate: self)
        
        let month = components.month
        let day = components.day
        let year = components.year
        let shortYear = year % 100

        return (day.toRoman()!, month.toRoman()!, year.toRoman()!, shortYear.toRoman())
    }

    var dayAfter:NSDate {
        let calendar =  NSCalendar.currentCalendar()
        return calendar.dateByAddingUnit(NSCalendarUnit.Day, value: 1, toDate: self, options: [])!

    }
    var dayBefore:NSDate {
        //let calendar =  NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let calendar =  NSCalendar.currentCalendar()
        return calendar.dateByAddingUnit(NSCalendarUnit.Day, value: -1, toDate: self, options: [])!
    }

}

public extension NSLocale {
    
    func dateOrder() -> DateOrder {
        guard let formatter = NSDateFormatter.dateFormatFromTemplate("MMMMdY", options: 0, locale: self) else {
            return .DayFirst
        }
        
        if formatter.hasPrefix("Y") {
            return .YearFirst
        }
        
        if formatter.hasPrefix("M") {
            return .MonthFirst
        }
        
        return .DayFirst
    }
}
