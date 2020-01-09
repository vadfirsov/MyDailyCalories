//
//  DateManager.swift
//  MyDailyCalories
//
//  Created by VADIM FIRSOV on 22/11/2019.
//  Copyright © 2019 VADIM FIRSOV. All rights reserved.
//

import UIKit

class DateManager {
    
    static let shared = DateManager()
    private init() {}
    
    func stringFrom(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.locale = Locale(identifier: "en_GB")
        return dateFormatter.string(from: date)
    }
    
    func stringFromLocal(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: date)
    }
    
    func dateFrom(string : String) -> Date? {
        let index = string.index(string.startIndex, offsetBy: 19)
        let mySubstring = String(string[..<index])
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: mySubstring)?.addingTimeInterval(7200)

        return date
    }
}
