//
//  RHHabitDashboardProtocolHandler.swift
//  Remote Habits Mobile App
//
//  Created by Amandeep Kaur on 01/12/21.
//

import Foundation

protocol RHDashboardActionHandler {
    
    func logoutUser()
    func loginUser()
    func switchWorkspace()
    func toggleHabit(toValue isEnabled: Bool, habitData : SelectedHabitData)
}


protocol RHDashboardDetailActionHandler {
    func toggleHabit(toValue isEnabled : Bool)
}

protocol RHDashboardDetailTimeHandler {
    func updateTime(with : SelectedHabitData)
}
