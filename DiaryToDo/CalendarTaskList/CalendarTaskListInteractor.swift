//
//  CalendarTaskListInteractor.swift
//  DiaryToDo
//
//  Created by Pavlentiy on 07.02.2022.
//

import RealmSwift
import Foundation

protocol CalendarTaskListInteractorOutputProtocol: AnyObject {
    func daysDidReceive(with dataStore: CalendarDataStore)
    func tasksDidReceive(with dataStore: TaskListDataStore)
}

protocol CalendarTaskListInteractorInputProtocol {
    init(presenter: CalendarTaskListInteractorOutputProtocol)
    func fetchDays(for monthType: MonthType?, and dayIndex: Int?)
    func fetchTasksForSelectedDay()
    func getSelectedDate() -> Date
}

class CalendarTaskListInteractor: CalendarTaskListInteractorInputProtocol {
    unowned let presenter: CalendarTaskListInteractorOutputProtocol
    
    let calendar = Calendar.current
    let secondsInHour = TimeInterval(3600)
    
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
        if let dayIndex = dayIndex {
            defineBaseDate(by: dayIndex)
        } else {
            defineBaseDate(by: monthType ?? .currentMonth)
        }
        
        let days = fetchDays()
        
        let month = fetchMonthString(from: baseDate)
        let year = fetchYearString(from: baseDate)
        
        let dataStore = CalendarDataStore(days: days, displayedMonth: month, displayedYear: year)
        
        presenter.daysDidReceive(with: dataStore)
    }
    
    func fetchTasksForSelectedDay() {
        var sections: [TaskListSectionViewModel] = []
        StorageManager.shared.fetchTasks { [unowned self] tasks in
            sections = self.prepareSections(from: tasks)
        }
        
        let day = fetchDayString(from: selectedDate)
        let month = fetchMonthString(from: selectedDate)
        let year = fetchYearString(from: selectedDate)
        
        let dataStore = TaskListDataStore(
            sections: sections,
            displayedDay: day,
            displayedMonth: month,
            displayedYear: year
        )
        
        presenter.tasksDidReceive(with: dataStore)
    }
    
    func getSelectedDate() -> Date {
        selectedDate
    }
}

// MARK: - Private methods
extension CalendarTaskListInteractor {
    private func fetchDays() -> [CalendarDay] {
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
        
        return days
    }
    
    private func defineBaseDate(by index: Int) {
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
    
    private func fetchDayString(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        return dateFormatter.string(from: date)
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
    
    // swiftlint:disable:next line_length
    private func defineTasks(between lhs: TimeInterval, and rhs: TimeInterval, from tasks: Results<TaskRealm>) -> Results<TaskRealm> {
        let predicate = NSPredicate(
            format: "dateFinish > %@ AND dateStart <= %@",
            NSNumber(value: lhs),
            NSNumber(value: rhs)
        )
        
        return tasks.filter(predicate)
    }
    
    private func prepareSections(from realmTasks: Results<TaskRealm>) -> [TaskListSectionViewModel] {
        var sections: [TaskListSectionViewModel] = []
        
        let dayStart = calendar.dateInterval(of: .day, for: selectedDate)?.start ?? Date()
        let dayEnd = calendar.dateInterval(of: .day, for: selectedDate)?.end ?? Date()
        
        let startDayTimestamp = dayStart.timeIntervalSince1970
        let endDayTimestamp = dayEnd.timeIntervalSince1970
        
        let tasksInSelectedDay = defineTasks(between: startDayTimestamp, and: endDayTimestamp, from: realmTasks)
        
        var timeCounter = startDayTimestamp
        while timeCounter < endDayTimestamp {
            // moves through the day in 1-hour increments
            sections.append(prepareHourSection(startHour: timeCounter, with: tasksInSelectedDay))
            
            timeCounter += secondsInHour
        }
        
        return sections
    }
    
    private func prepareHourSection(startHour: TimeInterval, with tasks: Results<TaskRealm>) -> TaskListSectionViewModel {
        let taskListSectionViewModel = TaskListSectionViewModel()
        
        let endHour = startHour + secondsInHour
        
        let currentHourTasks = defineTasks(between: startHour, and: endHour, from: tasks)
        currentHourTasks.forEach { realmTask in
            let tlTask = convertDataToTLTask(from: realmTask)
            taskListSectionViewModel.tasks.append(TaskListCellViewModel(task: tlTask))
        }
        
        let sectionName = fetchHourStringFromTimestamp(startHour) + " - " + fetchHourStringFromTimestamp(endHour)
        
        taskListSectionViewModel.sectionName = sectionName
        
        return taskListSectionViewModel
    }
    
    private func convertDataToTLTask(from task: TaskRealm) -> TLTask {
        TLTask(
            id: task.id,
            dateStart: Date(timeIntervalSince1970: task.dateStart),
            dateFinish: Date(timeIntervalSince1970: task.dateFinish),
            name: task.name,
            description: task.taskDescription
        )
    }
    
    private func fetchHourStringFromTimestamp(_ timestamp: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH"
        
        return "\(dateFormatter.string(from: date)):00"
    }
}
