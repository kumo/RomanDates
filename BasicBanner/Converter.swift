//
//  Converter.swift
//  RomanDates
//
//  Created by Robert Clarke on 29/10/2015.
//
//

import Foundation

extension Int {
    func toRoman() -> String? {
        var number = self
        
        if (number < 1) {
            return nil
        }
        
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
    func dateInRoman() -> (day:String, month:String, year:String) {
        
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Year, .Month, .Day], fromDate: self)
        
        let month = components.month
        let day = components.day
        let year = components.year
        
        print("Date is \(day.toRoman()) - \(month.toRoman())")
        
        return (day.toRoman()!, month.toRoman()!, year.toRoman()!)
    }
}

public extension NSLocale {
    enum DateOrder {
        case DayFirst, MonthFirst, YearFirst
    }
    
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