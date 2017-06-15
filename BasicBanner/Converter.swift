//
//  Converter.swift
//  RomanDates
//
//  Created by Robert Clarke on 29/10/2015.
//
//

import Foundation
import UIKit

public enum DateOrder: Int {
    case dayFirst, monthFirst, yearFirst
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

extension Date {
    func dateInRoman() -> (day:String, month:String, year:String, shortYear:String?) {
        
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components([.year, .month, .day], from: self)
        
        let month = components.month
        let day = components.day
        let year = components.year
        let shortYear = year! % 100

        return (day!.toRoman()!, month!.toRoman()!, year!.toRoman()!, shortYear.toRoman())
    }

    var dayAfter:Date {
        let calendar =  Calendar.current
        return (calendar as NSCalendar).date(byAdding: NSCalendar.Unit.day, value: 1, to: self, options: [])!

    }
    var dayBefore:Date {
        //let calendar =  NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let calendar =  Calendar.current
        return (calendar as NSCalendar).date(byAdding: NSCalendar.Unit.day, value: -1, to: self, options: [])!
    }

    func pasteboardDate() -> Date? {

        guard let currentPasteboardContents = UIPasteboard.general.string else {
            return nil
        }

        let types: NSTextCheckingResult.CheckingType = [.date]
        let detector = try? NSDataDetector(types: types.rawValue)
        var dates: [Date] = []

        detector?.enumerateMatches(in: currentPasteboardContents, options: [], range: NSMakeRange(0, currentPasteboardContents.characters.count)) { (result, flags, _) in

            if let date = result?.date {
                dates.append(date)
            }
        }

        guard let firstDate = dates.first else {
            return nil
        }

        return firstDate
    }

}

public extension Locale {
    
    func dateOrder() -> DateOrder {
        guard let formatter = DateFormatter.dateFormat(fromTemplate: "MMMMdY", options: 0, locale: self) else {
            return .dayFirst
        }
        
        if formatter.hasPrefix("Y") {
            return .yearFirst
        }
        
        if formatter.hasPrefix("M") {
            return .monthFirst
        }
        
        return .dayFirst
    }
}
