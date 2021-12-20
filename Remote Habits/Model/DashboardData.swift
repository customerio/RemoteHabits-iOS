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
    var habitDetail : HabitDetail?
}

struct HabitDetail {
    var isHabitEnabled : Bool?
    var frequency : Int?
    var startTime : String?
    var endTime : String?
    var description : String?
    var actionButtonValue : String?
    var actionType : HabitActionType?
}


struct HabitHeadersInfo : Hashable {
    let headerTitle : String?
    let titleFontSize : Int?
    let titleFontName : String?
}

struct SelectedHabitData : Encodable {
    let title : String?
    let frequency : Int?
    let startTime : String?
    let endTime : String?
}
