//
//  CalendarTaskListInteractor.swift
//  DiaryToDo
//
//  Created by Pavlentiy on 07.02.2022.
//

import Foundation

protocol CalendarTaskListInteractorOutputProtocol: AnyObject {
    func daysDidReceive(with dataStore: CalendarTaskListDataStore)
}

protocol CalendarTaskListInteractorInputProtocol {
    init(presenter: CalendarTaskListInteractorOutputProtocol)
    func fetchDays(for monthType: MonthType)
}

class CalendarTaskListInteractor: CalendarTaskListInteractorInputProtocol {
    unowned let presenter: CalendarTaskListInteractorOutputProtocol
    
    private var selectedDate = Date()
    private var days = [CalendarDay]()
    
    let weekdays = [
        CalendarDay(day: "Sun", type: .weekday),
        CalendarDay(day: "Mon", type: .weekday),
        CalendarDay(day: "Tue", type: .weekday),
        CalendarDay(day: "Wed", type: .weekday),
        CalendarDay(day: "Thu", type: .weekday),
        CalendarDay(day: "Fri", type: .weekday),
        CalendarDay(day: "Sat", type: .weekday)
    ]
    
    required init(presenter: CalendarTaskListInteractorOutputProtocol) {
        self.presenter = presenter
    }
    
    func fetchDays(for monthType: MonthType) {
        switch monthType {
        case .previousMonth:
            selectedDate = CalendarHelper().minusMonth(date: selectedDate)
        case .currentMonth:
            selectedDate = Date()
        case .nextMonth:
            selectedDate = CalendarHelper().plusMonth(date: selectedDate)
        }
        
        days = weekdays
        
        let daysInMonth = CalendarHelper().daysInMonth(date: selectedDate)
        let firstDayOfMonth = CalendarHelper().firstOfMonth(date: selectedDate)
        let startingSpaces = CalendarHelper().weekDay(date: firstDayOfMonth)
        
        let prevMonth = CalendarHelper().minusMonth(date: selectedDate)
        let daysInPrevMonth = CalendarHelper().daysInMonth(date: prevMonth)
        
        let elementsCountInCollectionView = 49
        
        var count: Int = 1
        
        while count <= elementsCountInCollectionView {
            let calendarDay: CalendarDay
            
            if count <= startingSpaces {
                let prevMonthDay = daysInPrevMonth - startingSpaces + count
                calendarDay = CalendarDay(day: "\(prevMonthDay)", type: .previous)
            } else if count - startingSpaces > daysInMonth {
                calendarDay = CalendarDay(day: "\(count - daysInMonth - startingSpaces)", type: .next)
            } else {
                calendarDay = CalendarDay(day: "\(count - startingSpaces)", type: .current)
            }
            
            days.append(calendarDay)
            count += 1
        }
        
        let month = CalendarHelper().monthString(date: selectedDate)
        let year = CalendarHelper().yearString(date: selectedDate)
        
        let dataStore = CalendarTaskListDataStore(days: days, displayedMonth: month, displayedYear: year)
        
        presenter.daysDidReceive(with: dataStore)
    }
}
