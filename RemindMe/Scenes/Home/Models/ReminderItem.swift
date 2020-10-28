//
//  ReminderItem.swift
//  RemindMe
//
//  Created by Kevin Vu on 9/28/20.
//  Copyright © 2020 Kevin Vu. All rights reserved.
//

import Foundation
import Firebase

// MARK: ReminderType enum
enum ReminderType: String {
    case routineTask = "Routine Task",
         refillItem = "Refill item",
         generic = "Generic"
}

enum ReminderIntervalTimeType: String {
    case years = "years",
         months = "months",
         weeks = "weeks",
         days = "days",
         error = "Error getting interval type"
}

// MARK: ReminderItem struct
struct ReminderItem {
    
    // MARK: Constants
    private let nameOfReminderConstant = "nameOfReminder"
    private let addedByUserConstant = "addedByUser"
    private let reminderTypeConstant = "reminderType"
    private let dateAddedConstant = "dateAdded"
    private let currentIntervalStartDateConstant = "currentIntervalStartDate"
    private let reminderIntervalTimeTypeConstant = "reminderIntervalTimeTypeConstant"
    private let reminderIntervalTimeValueConstant = "reminderIntervalValueConstant"
    private let upcomingReminderTriggerDateConstant = "upcomingReminderTriggerDate"
    private let isOneTimeReminderConstant = "isOneTimeReminder"
    
    // MARK: Properties
    let ref: DatabaseReference?
    let key: String
    
    let nameOfReminder: String
    let addedByUser: String
    let reminderType: ReminderType
    let dateAdded: Date
    // current interval start date should update to the new date when the reminder is triggered
    let currentIntervalStartDate: Date
    
    let reminderIntervalTimeType: ReminderIntervalTimeType
    let reminderIntervalTimeValue: Int
    let upcomingReminderTriggerDate: Date
    
    // MARK: Default init
    init(nameOfReminder: String,
         addedByUser user: String,
         key: String = "",
         reminderType: ReminderType,
         dateAdded: Date = Date(),
         currentIntervalStartDate: Date,
         reminderIntervalTimeType: ReminderIntervalTimeType,
         reminderIntervalTimeValue: Int,
         upcomingReminderTriggerDate: Date) {
        
        self.ref = nil
        self.key = key
        self.nameOfReminder = nameOfReminder
        self.addedByUser = user
        self.reminderType = reminderType
        self.dateAdded = dateAdded
        self.currentIntervalStartDate = currentIntervalStartDate
        self.reminderIntervalTimeType = reminderIntervalTimeType
        self.reminderIntervalTimeValue = reminderIntervalTimeValue
        self.upcomingReminderTriggerDate = upcomingReminderTriggerDate
    }
    
    // MARK: Snapshot init
    // convenience initializer for reminders fetched from firebase as snapshots
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let nameOfReminder = value[nameOfReminderConstant] as? String,
            let addedByUser = value[addedByUserConstant] as? String,
            let reminderType = value[reminderTypeConstant] as? String,
            let dateAddedString = value[dateAddedConstant] as? String,
            let currentIntervalStartDateString = value[currentIntervalStartDateConstant] as? String,
            let reminderIntervalTimeTypeString = value[reminderIntervalTimeTypeConstant] as? String,
            let reminderIntervalTimeValue = value[reminderIntervalTimeValueConstant] as? Int,
            let upcomingReminderTriggerDateString = value[upcomingReminderTriggerDateConstant] as? String
        else {
            // handle errors in extracting data from snapshot
            return nil
        }
        
        self.ref = snapshot.ref
        self.key = snapshot.key
        self.nameOfReminder = nameOfReminder
        self.addedByUser = addedByUser
        
        switch reminderType {
        case ReminderType.routineTask.rawValue:
            self.reminderType = .routineTask
        case ReminderType.refillItem.rawValue:
            self.reminderType = .refillItem
        default:
            self.reminderType = .generic
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.setDateStyleAndTimeZone(dateStyle: .short, timeZone: .current)
        
        guard
            let dateAdded = dateFormatter.date(from: dateAddedString),
            let currentIntervalStartDate = dateFormatter.date(from: currentIntervalStartDateString),
            let upcomingReminderTriggerDate = dateFormatter.date(from: upcomingReminderTriggerDateString)
        else {
            // TODO: handle errors in formatting dates from string
            return nil
        }
        
        self.dateAdded = dateAdded
        self.currentIntervalStartDate = currentIntervalStartDate
        
        switch reminderIntervalTimeTypeString {
        case ReminderIntervalTimeType.years.rawValue:
            self.reminderIntervalTimeType = .years
        case ReminderIntervalTimeType.months.rawValue:
            self.reminderIntervalTimeType = .months
        case ReminderIntervalTimeType.weeks.rawValue:
            self.reminderIntervalTimeType = .weeks
        case ReminderIntervalTimeType.days.rawValue:
            self.reminderIntervalTimeType = .days
        default:
            self.reminderIntervalTimeType = .error
        }
        
        self.reminderIntervalTimeValue = reminderIntervalTimeValue
        self.upcomingReminderTriggerDate = upcomingReminderTriggerDate
    }
    
}


// MARK: Utility methods
extension ReminderItem {
    /*
     converts our ReminderItem struct into a dictionary for convenience
     when using the setValue(_:) method on a reference to save data to firebase
     (setValue(_:) expects a dictionary)
     */
    func toDict() -> Any {
        let dateAddedString = getStringDateFrom(date: dateAdded)
        let currentIntervalStartDateString = getStringDateFrom(date: currentIntervalStartDate)
        let upcomingReminderTriggerDateString = getStringDateFrom(date: upcomingReminderTriggerDate)
        
        return [
            nameOfReminderConstant: nameOfReminder,
            addedByUserConstant: addedByUser,
            reminderTypeConstant: reminderType.rawValue,
            dateAddedConstant: dateAddedString,
            currentIntervalStartDateConstant: currentIntervalStartDateString,
            reminderIntervalTimeTypeConstant: reminderIntervalTimeType.rawValue,
            reminderIntervalTimeValueConstant: reminderIntervalTimeValue,
            upcomingReminderTriggerDateConstant: upcomingReminderTriggerDateString
        ]
    }
    
    /**
     Returns a string formatted into MM/dd/yy for the current timezone.
     */
    private func getStringDateFrom(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.setDateStyleAndTimeZone(dateStyle: .short, timeZone: .current)
        
        // returns a date like MM/dd/yy
        return dateFormatter.string(from: date)
    }
}

