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
    
    let calendar = Calendar.current
    private var selectedDate = Date()
    private var days = [CalendarDay]()
    
    let weekdays = [
        CalendarDay(day: "Mon", type: .weekday),
        CalendarDay(day: "Tue", type: .weekday),
        CalendarDay(day: "Wed", type: .weekday),
        CalendarDay(day: "Thu", type: .weekday),
        CalendarDay(day: "Fri", type: .weekday),
        CalendarDay(day: "Sat", type: .weekday),
        CalendarDay(day: "Sun", type: .weekday)
    ]
    
    required init(presenter: CalendarTaskListInteractorOutputProtocol) {
        self.presenter = presenter
    }
    
    func fetchDays(for monthType: MonthType) {
        defineSelectedDate(by: monthType)
        
        days = weekdays
        
        let daysInMonth = countDaysInMonth(date: selectedDate)
        let firstDayOfMonth = fetchFirstMonthDay(from: selectedDate)
        let startingSpaces = fetchWeekDay(from: firstDayOfMonth)
        
        let prevMonth = subtractMonth(from: selectedDate)
        let daysInPrevMonth = countDaysInMonth(date: prevMonth)
        
        let elementsCountInCollectionView = 49
        
        var day = firstDayOfMonth
        for count in 1...elementsCountInCollectionView {
            let calendarDay: CalendarDay
            
            if count <= startingSpaces {
                let prevMonthDay = daysInPrevMonth - startingSpaces + count
                calendarDay = CalendarDay(day: "\(prevMonthDay)", type: .previous)
            } else if count - startingSpaces > daysInMonth {
                calendarDay = CalendarDay(day: "\(count - daysInMonth - startingSpaces)", type: .next)
            } else {
                calendarDay = CalendarDay(
                    day: "\(count - startingSpaces)",
                    type: .current,
                    isSelected: calendar.isDateInToday(day)
                )
                
                day = calendar.date(byAdding: .day, value: 1, to: day) ?? Date()
            }
            
            days.append(calendarDay)
        }
        
        let month = fetchMonthString(from: selectedDate)
        let year = fetchYearString(from: selectedDate)
        
        let dataStore = CalendarTaskListDataStore(days: days, displayedMonth: month, displayedYear: year)
        
        presenter.daysDidReceive(with: dataStore)
    }
}

// MARK: - Private functions
extension CalendarTaskListInteractor {
    private func defineSelectedDate(by monthType: MonthType) {
        switch monthType {
        case .previousMonth:
            selectedDate = subtractMonth(from: selectedDate)
        case .currentMonth:
            selectedDate = Date()
        case .nextMonth:
            selectedDate = addMonth(to: selectedDate)
        }
    }
    
    private func countDaysInMonth(date: Date) -> Int {
        let range = calendar.range(of: .day, in: .month, for: date)
        return range?.count ?? 0
    }
    
    private func fetchFirstMonthDay(from date: Date) -> Date {
        let components = calendar.dateComponents([.year, .month, .hour], from: date)

        return calendar.date(from: components) ?? Date()
    }
    
    private func fetchWeekDay(from date: Date) -> Int {
        let components = calendar.dateComponents([.weekday], from: date)
        
        // to make it look like Monday is first day of the week
        return (5 + (components.weekday ?? 1)) % 7
    }
    
    private func subtractMonth(from date: Date) -> Date {
        calendar.date(byAdding: .month, value: -1, to: date) ?? Date()
    }
    
    private func addMonth(to date: Date) -> Date {
        return calendar.date(byAdding: .month, value: 1, to: date) ?? Date()
    }
    
    private func fetchMonthString(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        return dateFormatter.string(from: date)
    }
    
    private func fetchYearString(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: date)
    }
}
