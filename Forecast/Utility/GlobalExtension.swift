//
//  Extension.swift
//  Forecast
//
//  Created by Alexandra on 02.03.2024.
//

import Foundation

extension Int{
    var dayDateMonth: String{
        let dateFormatter = DateFormatter ()
        dateFormatter.dateFormat = "EE, MMM d"
        return dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(self)))
    }
    
    func hourMiniteAmPm(_ offset: Int = 0) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.dateFormat = "h:mm f"
        return dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(self.advanced(by: offset))))
    }
}


extension Double{
    func roundedString(to digits: Int) -> String{
        String(format: "%.\(digits)f", self)
    }
}
