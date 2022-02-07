//
//  CalendarTaskListPresenter.swift
//  DiaryToDo
//
//  Created by Pavlentiy on 07.02.2022.
//

import Foundation

struct CalendarTaskListDataStore {
    let days: [CalendarDay]
    let displayedMonth: String
    let displayedYear: String
}

class CalendarTaskListPresenter: CalendarTaskListViewOutputProtocol {
    unowned let view: CalendarTaskListViewInputProtocol
    var interactor: CalendarTaskListInteractorInputProtocol!
    
    private var dataStore: CalendarTaskListDataStore?
    
    required init(view: CalendarTaskListViewInputProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        interactor.fetchDays(for: .currentMonth)
    }
    
    func leftButtonPressed() {
        interactor.fetchDays(for: .previousMonth)
    }
    
    func rightButtonPressed() {
        interactor.fetchDays(for: .nextMonth)
    }
}

extension CalendarTaskListPresenter: CalendarTaskListInteractorOutputProtocol {
    func daysDidReceive(with dataStore: CalendarTaskListDataStore) {
        self.dataStore = dataStore
        
        let navItemTitle = dataStore.displayedMonth + " " + dataStore.displayedYear
        let section = CalendarSectionViewModel()
        
        dataStore.days.forEach { section.cells.append(CalendarCellViewModel(calendarDay: $0))}

        view.reloadCalendar(for: section, with: navItemTitle)
    }
}
