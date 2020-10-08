//
//  DateComponents.swift
//  RemindMe
//
//  Created by Kevin Vu on 10/6/20.
//  Copyright © 2020 Kevin Vu. All rights reserved.
//

import Foundation

extension DateComponents {
    init?(calendar: Calendar?, timeZone: TimeZone, year: Int?, month: Int?, weekOfYear: Int?, day: Int?) {
        self.init()
        
        self.calendar = calendar
        self.timeZone = timeZone
        self.year = year
        self.month = month
        self.weekOfYear = weekOfYear
        self.day = day
    }
}

extension DateFormatter {
    func setDateStyleAndTimeZone(dateStyle: DateFormatter.Style, timeZone: TimeZone) {
        self.dateStyle = dateStyle
        self.timeZone = timeZone
    }
}
