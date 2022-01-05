//
//  RHStubData.swift
//  Remote Habits Mobile App
//
//  Created by Amandeep Kaur on 01/12/21.
//

import Foundation

class RemoteHabitsData {
    
    let userManager = DI.shared.userManager
    private var isLoggedIn: Bool {
        return userManager.isLoggedIn
    }
    func getHabitHeaders() -> [HabitHeadersInfo] {
        
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
                                     startTime: nil,
                                     endTime: nil,
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
                                        startTime: nil,
                                        endTime: nil,
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
                                        startTime: nil,
                                        endTime: nil,
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
