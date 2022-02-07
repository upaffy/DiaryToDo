//
//  CalendarCellViewModel.swift
//  DiaryToDo
//
//  Created by Pavlentiy on 07.02.2022.
//

protocol CalendarCellViewModelProtocol {
    var reuseIdentifier: String { get }
    var dayOfMonth: String { get }
    var dayType: CalendarDay.DayType { get }
    
    init(calendarDay: CalendarDay)
}

protocol CalendarSectionViewModelProtocol {
    var cells: [CalendarCellViewModelProtocol] { get }
}

class CalendarCellViewModel: CalendarCellViewModelProtocol {
    var reuseIdentifier = String(describing: CalendarCellViewModel.self)
    
    var dayOfMonth: String {
        calendarDay.day
    }
    
    var dayType: CalendarDay.DayType {
        calendarDay.type
    }
    
    private let calendarDay: CalendarDay
    
    required init(calendarDay: CalendarDay) {
        self.calendarDay = calendarDay
    }
}

class CalendarSectionViewModel: CalendarSectionViewModelProtocol {
    var cells: [CalendarCellViewModelProtocol] = []
}
