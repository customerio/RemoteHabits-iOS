//
//  RHStubData.swift
//  Remote Habits Mobile App
//
//  Created by Amandeep Kaur on 01/12/21.
//

import Foundation

typealias UserHabit = [[HabitHeadersInfo : [HabitData]]]

class RHStubData {
    
    var dashboardData : UserHabit = UserHabit()
    
    func getStubData(isLoggedIn : Bool) -> [[HabitHeadersInfo : [HabitData]]]{
        let habitInfo = HabitDetail(isHabitEnabled: false, actionButtonValue: nil, actionType: nil)
        let habitData = [HabitData(icon: "coffee", title: "Hydration", subTitle: "Set reminders to drink water", type: .toggleSwitch, habitDetail: habitInfo),
                         HabitData(icon: "timer", title: "Taking Breaks", subTitle: "Set reminders to take breaks", type: .toggleSwitch, habitDetail: habitInfo),
                         HabitData(icon: "brain", title: "Focus Time", subTitle: "Set reminders to focus", type: .toggleSwitch, habitDetail: habitInfo)]
        
        let habitInfo_1 = HabitDetail(isHabitEnabled: true, actionButtonValue: "Log out", actionType : .logout)
        let habitInfo_2 = HabitDetail(isHabitEnabled: true, actionButtonValue: "Switch", actionType : .switchWorkspace)
        let anonymousHabitInfo = HabitDetail(isHabitEnabled: true, actionButtonValue: "Log In", actionType : .login)
        let anonymousUser = HabitData(icon: "guest", title: "Guest", subTitle: "Anonymous", type: .button, habitDetail: anonymousHabitInfo)
        let cioUser = HabitData(icon: "ciouser", title: "Bradley", subTitle: "bradley@customer.io", type: .button, habitDetail: habitInfo_1)
        
        let habitDetail = [isLoggedIn ? cioUser : anonymousUser,
                           HabitData(icon: "ciologo", title: "Site Id", subTitle: "7a11864c75734d8cdb01", type: .button, habitDetail: habitInfo_2),
                           HabitData(icon: "phone", title: "SDK", subTitle: "Customer.io iOS Client/1.0.0-alpha.18 (iPhone13,2; iOS 15.1) Remote Habits/pr.28", type: nil, habitDetail: nil)]
        
        
        // Sections
        let section1 = HabitHeadersInfo(headerTitle: "Bradley's Habit", titleFontSize: 34, titleFontName: "SFProDisplay-Bold")
        let section2 = HabitHeadersInfo(headerTitle: "Details", titleFontSize: 17, titleFontName: "SFProDisplay-Bold")
        dashboardData.append([section1 : habitData])
        dashboardData.append([section2 : habitDetail])
        return dashboardData
    }
}
