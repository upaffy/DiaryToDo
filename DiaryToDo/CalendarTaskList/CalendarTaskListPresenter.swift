//
//  CalendarTaskListPresenter.swift
//  DiaryToDo
//
//  Created by Pavlentiy on 07.02.2022.
//

import Foundation

struct CalendarDataStore {
    let days: [CalendarDay]
    let displayedMonth: String
    let displayedYear: String
}

struct TaskListDataStore {
    let sections: [TaskListSectionViewModel]
    let displayedDay: String
    let displayedMonth: String
    let displayedYear: String
}

class CalendarTaskListPresenter: CalendarTaskListViewOutputProtocol {
    unowned let view: CalendarTaskListViewInputProtocol
    var interactor: CalendarTaskListInteractorInputProtocol!
    var router: CalendarTaskListRouterInputProtocol!
    
    required init(view: CalendarTaskListViewInputProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        interactor.fetchDays(for: .currentMonth, and: nil)
        interactor.fetchTasksForSelectedDay()
    }
    
    func leftButtonPressed() {
        interactor.fetchDays(for: .previousMonth, and: nil)
    }
    
    func rightButtonPressed() {
        interactor.fetchDays(for: .nextMonth, and: nil)
    }
    
    func collectionViewCellDidSelect(at indexPath: IndexPath) {
        interactor.fetchDays(for: .currentMonth, and: indexPath.item)
        interactor.fetchTasksForSelectedDay()
    }
}

// MARK: - CalendarTaskListInteractorOutputProtocol
extension CalendarTaskListPresenter: CalendarTaskListInteractorOutputProtocol {
    func daysDidReceive(with dataStore: CalendarDataStore) {
        let navItemTitle = dataStore.displayedMonth + " " + dataStore.displayedYear
        let calendarSectionVM = CalendarSectionViewModel()
        
        dataStore.days.forEach { calendarSectionVM.cells.append(CalendarCellViewModel(calendarDay: $0))}

        view.reloadCalendar(for: calendarSectionVM, with: navItemTitle)
    }
    
    func tasksDidReceive(with dataStore: TaskListDataStore) {
        let dayTitle = dataStore.displayedMonth + " " + dataStore.displayedDay + ", " + dataStore.displayedYear
        view.reloadTaskList(for: dataStore.sections, with: dayTitle)
    }
}
