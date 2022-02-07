//
//  CalendarDay.swift
//  DiaryToDo
//
//  Created by Pavlentiy on 06.02.2022.
//

struct CalendarDay {
    var day: String
    var type: DayType
    
    enum DayType {
        case previous
        case current
        case next
        case weekday
    }
}
