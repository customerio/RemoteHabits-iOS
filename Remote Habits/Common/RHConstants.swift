//
//  RHConstants.swift
//  Remote Habits Mobile App
//
//  Created by Amandeep Kaur on 25/11/21.
//

import Foundation

struct RHConstants {
    // Strings
    static let kBackground = "background"
    static let errorMessageLoginScreenEmailNotValid = "Invalid Email"
    static let kEmptyValue = ""
    static let kBabyBradley = "Baby Bradley"
    static let kCIO = "Customer.io"
    static let kValue = "Value"
    static let kInvalid = "Invalid"
    static let kHabitsUpdatedIdentifier = "HabitUpdatedIdentifier"
    
    
    // Storyboard / Xib
    static let kStoryboardMain = "Main"
    static let kDashboardViewController = "RHDashboardViewController"
    static let kHabitTableViewCell = "HabitTableViewCell"
    static let kHabitDetailViewController = "RHHabitDetailViewController"
    static let kSwitchWorkspaceViewController = "RHSwitchWorkspaceViewController"
    static let kHabitReminderTableViewCell = "HabitReminderTableViewCell"
    static let kHabitDetailToggleTableViewCell = "HabitDetailToggleTableViewCell"
    static let kHabitAddInfoTableViewCell = "HabitAddInfoTableViewCell"
    static let kLoginViewController = "RHLoginViewController"
    
    // Images / Assets
    static let kLogo = "logo"
    static let kBack = "back"
    
    // Login
    static let kRandomEId = EmailAddress.randomEmail
    static let kDefaultPassword = "123"
    static let kRandomUsername = String.random
    
    // Habits Tracking
    static let kHabitClicked = "clicked_habit"
    static let kHabitEnabled = "habit_enabled"
    static let kHabitDisabled = "habit_disabled"
}
