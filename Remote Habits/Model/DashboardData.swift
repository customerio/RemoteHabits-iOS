//
//  DashboardData.swift
//  Remote Habits Mobile App
//
//  Created by Amandeep Kaur on 30/11/21.
//

import Foundation

enum HabitElementType {
    case toggleSwitch
    case button
}

enum HabitActionType {
    case logout
    case login
    case switchWorkspace
    case toggleSwitch
}

struct HabitData {
    let icon : String?
    let title : String?
    let subTitle : String?
    let type : HabitElementType?
    let habitDetail : HabitDetail?
}

struct HabitDetail {
    let isHabitEnabled : Bool?
    let actionButtonValue : String?
    let actionType : HabitActionType?
}


struct HabitHeadersInfo : Hashable {
    let headerTitle : String?
    let titleFontSize : Int?
    let titleFontName : String?
}
