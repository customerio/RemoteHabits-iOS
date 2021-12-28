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
        
        let habitInfo_hydration = HabitDetail(id: 1, isHabitEnabled: false, frequency: 8, startTime: "9:00 AM", endTime: "5:00 PM", description: "Drinking enough water each day is crucial for many reasons: to regulate body temperature, keep joints lubricated, prevent infections, deliver nutrients to cells, and keep organs functioning properly. Being well-hydrated also improves sleep quality, cognition, and mood.", actionButtonValue: nil, actionType: nil)
        
        let habitInfo_focus = HabitDetail(id: 1,isHabitEnabled: false, frequency: 2, startTime: "9:00 AM", endTime: "5:00 PM", description: "Having scheduled, uninterrupted time to focus on deep work provides employees an opportunity to complete difficult tasks, produce high quality output, and generate new ideas. Time to focus increases productivity, improves decision making, and boosts creativity.", actionButtonValue: nil, actionType: nil)
        
        let habitInfo_break = HabitDetail(id: 1,isHabitEnabled: false, frequency: 5, startTime: "9:00 AM", endTime: "5:00 PM", description: "Taking a break improves focus and concentration and provides the opportunity for an employee's mental reset. After a break, work can resume with more energy and motivation. Working without taking one or more breaks only leads to mental and physical fatigue. It can even lead to burnout in the long run.", actionButtonValue: nil, actionType: nil)
        
        let habitData = [HabitData(icon: "coffee", title: "Hydration", subTitle: "Set reminders to drink water", type: .toggleSwitch, habitDetail: habitInfo_hydration),
                         HabitData(icon: "timer", title: "Taking Breaks", subTitle: "Set reminders to take breaks", type: .toggleSwitch, habitDetail: habitInfo_break),
                         HabitData(icon: "brain", title: "Focus Time", subTitle: "Set reminders to focus", type: .toggleSwitch, habitDetail: habitInfo_focus)]
        
        let habitInfo_1 = HabitDetail(id: 1,isHabitEnabled: true, frequency: nil, startTime: nil, endTime: nil, description: nil, actionButtonValue: "Log out", actionType : .logout)
        let habitInfo_2 = HabitDetail(id: 1,isHabitEnabled: true, frequency: nil, startTime: nil, endTime: nil, description: nil, actionButtonValue: "Switch", actionType : .switchWorkspace)
        let anonymousHabitInfo = HabitDetail(id: 1,isHabitEnabled: true, frequency: nil, startTime: nil, endTime: nil, description: nil, actionButtonValue: "Log In", actionType : .login)
        let anonymousUser = HabitData(icon: "guest", title: "Guest", subTitle: "Anonymous", type: .button, habitDetail: anonymousHabitInfo)
        let cioUser = HabitData(icon: "ciouser", title: userManager.userName, subTitle: userManager.email, type: .button, habitDetail: habitInfo_1)
        
        let habitDetail = [isLoggedIn ? cioUser : anonymousUser,
                           HabitData(icon: "ciologo", title: "Site Id", subTitle: userManager.workspaceID, type: .button, habitDetail: habitInfo_2),
                           HabitData(icon: "phone", title: "SDK", subTitle: "Customer.io iOS Client/1.0.0-alpha.18 (iPhone13,2; iOS 15.1) Remote Habits/pr.28", type: nil, habitDetail: nil)]
        
        
        // Sections
//        let title = isLoggedIn ? userManager.userName : "Guest"
//        let section1 = HabitHeadersInfo(headerTitle: "\(title ?? "Your")'s Habits", titleFontSize: 34, titleFontName: "SFProDisplay-Bold")
//        let section2 = HabitHeadersInfo(headerTitle: "Details", titleFontSize: 17, titleFontName: "SFProDisplay-Bold")
//        dashboardData.append([section1 : habitData])
//        dashboardData.append([section2 : habitDetail])
        return dashboardData
    }
}


class RemoteHabitsData {
    
    let userManager = DI.shared.userManager
    
    func getHabitHeaders() -> [HabitHeadersInfo] {
        
        let isLoggedIn = !(userManager.isGuestLogin ?? true)
        print("Get logged in point # 1 is \(isLoggedIn)")
        let title = isLoggedIn ? userManager.userName : "Guest"
        let section_first = HabitHeadersInfo(headerTitle: "\(title ?? "Your")'s Habits", titleFontSize: 34, titleFontName: "SFProDisplay-Bold", ids: [1,2,3])
        let section_second = HabitHeadersInfo(headerTitle: "Details", titleFontSize: 17, titleFontName: "SFProDisplay-Bold", ids: [4,5,6])
       
        return [section_first, section_second]
    }
    
    func getHabitsData() -> [HabitsData] {
        let habitsHeaderRows = getHabitsHeaderRows()
        let detailHeaderRows = getDetailsHeaderRows()
        
        return habitsHeaderRows + detailHeaderRows
    }
    
    func getHabitsHeaderRows() -> [HabitsData] {
        let hydration = HabitsData(id: 1,
                                     icon: "coffee",
                                     title: "Hydration",
                                     subtitle: "Set reminders to drink water",
                                     type: .toggleSwitch,
                                     isEnabled: false,
                                     frequency: 8,
                                     startTime: Date(),
                                     endTime: Date(),
                                     habitDescription: "Drinking enough water each day is crucial for many reasons: to regulate body temperature, keep joints lubricated, prevent infections, deliver nutrients to cells, and keep organs functioning properly. Being well-hydrated also improves sleep quality, cognition, and mood.",
                                     actionName: nil,
                                     actionType: nil)
        
        let takingBreaks = HabitsData(id: 2,
                                        icon: "timer",
                                        title: "Taking Breaks",
                                        subtitle: "Set reminders to take breaks",
                                        type: .toggleSwitch,
                                        isEnabled: false,
                                        frequency: 5,
                                        startTime: Date(),
                                        endTime: Date(),
                                        habitDescription: "Taking a break improves focus and concentration and provides the opportunity for an employee's mental reset. After a break, work can resume with more energy and motivation. Working without taking one or more breaks only leads to mental and physical fatigue. It can even lead to burnout in the long run.",
                                        actionName: nil,
                                        actionType: nil)
        
        let focusTime   = HabitsData(id: 3,
                                        icon: "brain",
                                        title: "Focus Time",
                                        subtitle: "Set reminders to focus",
                                        type: .toggleSwitch,
                                        isEnabled: false,
                                        frequency: 2,
                                        startTime: Date(),
                                        endTime: Date(),
                                        habitDescription: "Having scheduled, uninterrupted time to focus on deep work provides employees an opportunity to complete difficult tasks, produce high quality output, and generate new ideas. Time to focus increases productivity, improves decision making, and boosts creativity.",
                                        actionName: nil,
                                        actionType: nil)
        
        return [hydration, takingBreaks, focusTime]
    }
    
    func getDetailsHeaderRows() -> [HabitsData] {
        let userData = getUserData()
        
        let workspaceData = HabitsData(id: 5,
                                         icon: "ciologo",
                                         title: "Site Id",
                                         subtitle: userManager.workspaceID,
                                         type: .button,
                                         isEnabled: true,
                                         frequency: nil,
                                         startTime: nil,
                                         endTime: nil,
                                         habitDescription: nil,
                                         actionName: "Switch",
                                         actionType: .switchWorkspace)
        
        let sdkData     = HabitsData(id: 6,
                                         icon: "phone",
                                         title: "SDK",
                                         subtitle: "Customer.io iOS Client/1.0.0-alpha.18 (iPhone13,2; iOS 15.1) Remote Habits/pr.28",
                                         type: ElementType.none,
                                         isEnabled: nil,
                                         frequency: nil,
                                         startTime: nil,
                                         endTime: nil,
                                         habitDescription: nil,
                                         actionName: nil,
                                         actionType: nil)
        
        return [userData, workspaceData, sdkData]
    }
    
    func getUserData() -> HabitsData {
        let isLoggedIn = !(userManager.isGuestLogin ?? true)
        print("Get logged in point # 2 is \(isLoggedIn)")
        return  HabitsData(id: 4,
                           icon: isLoggedIn ? "ciouser" : "guest",
                           title: isLoggedIn ? userManager.userName : "Guest",
                           subtitle: isLoggedIn ? userManager.email : "Anonymous",
                           type: .button,
                           isEnabled: true,
                           frequency: nil,
                           startTime: nil,
                           endTime: nil,
                           habitDescription: nil,
                           actionName: isLoggedIn ? "Log Out" : "Log In",
                           actionType: isLoggedIn ? .logout : .login)
    }
}
/**
 
 fresh login ->  
 */
