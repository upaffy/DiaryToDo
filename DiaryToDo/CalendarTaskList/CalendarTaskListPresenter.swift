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
    let sections: [TaskListSection]
}

class CalendarTaskListPresenter: CalendarTaskListViewOutputProtocol {
    unowned let view: CalendarTaskListViewInputProtocol
    var interactor: CalendarTaskListInteractorInputProtocol!
    
    private var calendarDataStore: CalendarDataStore?
    private var taskListDataStore: TaskListDataStore?
    
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
        self.calendarDataStore = dataStore
        
        let navItemTitle = dataStore.displayedMonth + " " + dataStore.displayedYear
        let calendarSectionVM = CalendarSectionViewModel()
        
        dataStore.days.forEach { calendarSectionVM.cells.append(CalendarCellViewModel(calendarDay: $0))}

        view.reloadCalendar(for: calendarSectionVM, with: navItemTitle)
    }
    
    func tasksDidReceive(with dataStore: TaskListDataStore) {
        self.taskListDataStore = dataStore
        
        var taskListSections = [TaskListSectionViewModel]()
        dataStore.sections.forEach { section in
            let taskListSectionVM = TaskListSectionViewModel()
            
            taskListSectionVM.sectionName = section.sectionName
            section.tasks.forEach { taskListSectionVM.tasks.append(TaskListCellViewModel(task: $0)) }
            
            taskListSections.append(taskListSectionVM)
        }
        
        view.reloadTaskList(for: taskListSections)
    }
}
