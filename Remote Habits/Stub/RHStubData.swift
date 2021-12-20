//
//  RHStubData.swift
//  Remote Habits Mobile App
//
//  Created by Amandeep Kaur on 01/12/21.
//

import Foundation
import CioTracking

typealias UserHabit = [[HabitHeadersInfo : [HabitData]]]

class RHStubData {
    
    var dashboardData : UserHabit = UserHabit()
    let userManager = DI.shared.userManager
    
    func getStubData() -> [[HabitHeadersInfo : [HabitData]]]{
        let isLoggedIn = !(userManager.isGuestLogin ?? true)
        
        let habitInfo_hydration = HabitDetail(isHabitEnabled: false, frequency: 8, startTime: "9:00 AM", endTime: "5:00 PM", description: "Drinking enough water each day is crucial for many reasons: to regulate body temperature, keep joints lubricated, prevent infections, deliver nutrients to cells, and keep organs functioning properly. Being well-hydrated also improves sleep quality, cognition, and mood.", actionButtonValue: nil, actionType: nil)
        
        let habitInfo_focus = HabitDetail(isHabitEnabled: false, frequency: 2, startTime: "9:00 AM", endTime: "5:00 PM", description: "Having scheduled, uninterrupted time to focus on deep work provides employees an opportunity to complete difficult tasks, produce high quality output, and generate new ideas. Time to focus increases productivity, improves decision making, and boosts creativity.", actionButtonValue: nil, actionType: nil)
        
        let habitInfo_break = HabitDetail(isHabitEnabled: false, frequency: 5, startTime: "9:00 AM", endTime: "5:00 PM", description: "Taking a break improves focus and concentration and provides the opportunity for an employee's mental reset. After a break, work can resume with more energy and motivation. Working without taking one or more breaks only leads to mental and physical fatigue. It can even lead to burnout in the long run.", actionButtonValue: nil, actionType: nil)
        
        let habitData = [HabitData(icon: "coffee", title: "Hydration", subTitle: "Set reminders to drink water", type: .toggleSwitch, habitDetail: habitInfo_hydration),
                         HabitData(icon: "timer", title: "Taking Breaks", subTitle: "Set reminders to take breaks", type: .toggleSwitch, habitDetail: habitInfo_break),
                         HabitData(icon: "brain", title: "Focus Time", subTitle: "Set reminders to focus", type: .toggleSwitch, habitDetail: habitInfo_focus)]
        
        let habitInfo_1 = HabitDetail(isHabitEnabled: true, frequency: nil, startTime: nil, endTime: nil, description: nil, actionButtonValue: "Log out", actionType : .logout)
        let habitInfo_2 = HabitDetail(isHabitEnabled: true, frequency: nil, startTime: nil, endTime: nil, description: nil, actionButtonValue: "Switch", actionType : .switchWorkspace)
        let anonymousHabitInfo = HabitDetail(isHabitEnabled: true, frequency: nil, startTime: nil, endTime: nil, description: nil, actionButtonValue: "Log In", actionType : .login)
        let anonymousUser = HabitData(icon: "guest", title: "Guest", subTitle: "Anonymous", type: .button, habitDetail: anonymousHabitInfo)
        let cioUser = HabitData(icon: "ciouser", title: userManager.userName, subTitle: userManager.email, type: .button, habitDetail: habitInfo_1)
        
        let habitDetail = [isLoggedIn ? cioUser : anonymousUser,
                           HabitData(icon: "ciologo", title: "Site Id", subTitle: Env.customerIOSiteId, type: .button, habitDetail: habitInfo_2),
                           HabitData(icon: "phone", title: "SDK", subTitle: "Customer.io iOS Client/1.0.0-alpha.18 (iPhone13,2; iOS 15.1) Remote Habits/pr.28", type: nil, habitDetail: nil)]
        
        
        // Sections
        let title = isLoggedIn ? userManager.userName : "Guest"
        let section1 = HabitHeadersInfo(headerTitle: "\(title ?? "Your")'s Habit", titleFontSize: 34, titleFontName: "SFProDisplay-Bold")
        let section2 = HabitHeadersInfo(headerTitle: "Details", titleFontSize: 17, titleFontName: "SFProDisplay-Bold")
        dashboardData.append([section1 : habitData])
        dashboardData.append([section2 : habitDetail])
        return dashboardData
    }
}
