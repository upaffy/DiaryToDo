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
    func fetchDays(for monthType: MonthType?, and dayIndex: Int?)
}

class CalendarTaskListInteractor: CalendarTaskListInteractorInputProtocol {
    unowned let presenter: CalendarTaskListInteractorOutputProtocol
    
    let calendar = Calendar.current
    private var baseDate = Date()
    private var selectedDate = Date()
    private var days = [CalendarDay]()
    
    private let weekdays = [
        CalendarDay(day: "Mon", type: .weekday),
        CalendarDay(day: "Tue", type: .weekday),
        CalendarDay(day: "Wed", type: .weekday),
        CalendarDay(day: "Thu", type: .weekday),
        CalendarDay(day: "Fri", type: .weekday),
        CalendarDay(day: "Sat", type: .weekday),
        CalendarDay(day: "Sun", type: .weekday)
    ]
    
    private let elementsCountInCollectionView = 49
    
    private var daysInMonth: Int {
        countDaysInMonth(date: baseDate)
    }
    private var firstDayOfMonth: Date {
        fetchFirstMonthDay(from: baseDate)
    }
    private var startingSpaces: Int {
        fetchWeekDay(from: firstDayOfMonth)
    }
    
    private var prevMonth: Date {
        subtractMonth(from: baseDate)
    }
    private var daysInPrevMonth: Int {
        countDaysInMonth(date: prevMonth)
    }
    
    required init(presenter: CalendarTaskListInteractorOutputProtocol) {
        self.presenter = presenter
    }
    
    func fetchDays(for monthType: MonthType?, and dayIndex: Int?) {
        defineBaseDate(by: monthType, and: dayIndex)
        fetchDays()
    }
}

// MARK: - Private methods
extension CalendarTaskListInteractor {
    private func fetchDays() {
        days = weekdays
        
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
                    isSelected: calendar.isDate(day, equalTo: selectedDate, toGranularity: .day),
                    isCurrent: calendar.isDateInToday(day)
                )
                
                day = calendar.date(byAdding: .day, value: 1, to: day) ?? Date()
            }
            
            days.append(calendarDay)
        }
        
        let month = fetchMonthString(from: baseDate)
        let year = fetchYearString(from: baseDate)
        
        let dataStore = CalendarTaskListDataStore(days: days, displayedMonth: month, displayedYear: year)
        
        presenter.daysDidReceive(with: dataStore)
    }
    
    private func defineBaseDate(by monthType: MonthType?, and index: Int?) {
        guard let index = index else {
            defineBaseDate(by: monthType ?? .currentMonth)
            return
        }
        
        defineSelectedDate(by: index)
        baseDate = selectedDate
    }
    
    private func defineBaseDate(by monthType: MonthType) {
        switch monthType {
        case .previousMonth:
            baseDate = fetchFirstMonthDay(from: subtractMonth(from: baseDate))
        case .currentMonth:
            baseDate = Date()
        case .nextMonth:
            baseDate = fetchFirstMonthDay(from: addMonth(to: baseDate))
        }
    }
    
    private func defineSelectedDate(by index: Int) {
        let selectedDay = Int(days[index].day) ?? 1
        
        if index < startingSpaces + weekdays.count {
            // use old variable value to determine month user is currently on
            selectedDate = subtractMonth(from: baseDate)
        } else if index < daysInMonth + startingSpaces + weekdays.count {
            selectedDate = baseDate
        } else {
            // use old variable value to determine month user is currently on
            selectedDate = addMonth(to: baseDate)
        }
        
        var components = calendar.dateComponents([.year, .month], from: selectedDate)
        components.setValue(selectedDay, for: .day)
        
        selectedDate = calendar.date(from: components) ?? Date()
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
