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
        interactor.fetchDays(for: .currentMonth, and: nil)
    }
    
    func leftButtonPressed() {
        interactor.fetchDays(for: .previousMonth, and: nil)
    }
    
    func rightButtonPressed() {
        interactor.fetchDays(for: .nextMonth, and: nil)
    }
    
    func collectionViewCellDidSelect(at indexPath: IndexPath) {
        interactor.fetchDays(for: .currentMonth, and: indexPath.item)
    }
}

// MARK: - CalendarTaskListInteractorOutputProtocol
extension CalendarTaskListPresenter: CalendarTaskListInteractorOutputProtocol {
    func daysDidReceive(with dataStore: CalendarTaskListDataStore) {
        self.dataStore = dataStore
        
        let navItemTitle = dataStore.displayedMonth + " " + dataStore.displayedYear
        let section = CalendarSectionViewModel()
        
        dataStore.days.forEach { section.cells.append(CalendarCellViewModel(calendarDay: $0))}

        view.reloadCalendar(for: section, with: navItemTitle)
    }
}
