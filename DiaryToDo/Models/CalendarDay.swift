//
//  CalendarDay.swift
//  DiaryToDo
//
//  Created by Pavlentiy on 06.02.2022.
//

struct CalendarDay {
    var day: String
    var type: DayType
    var isSelected = false
    var isCurrent = false
    
    enum DayType {
        case previous
        case current
        case next
        case weekday
    }
}
