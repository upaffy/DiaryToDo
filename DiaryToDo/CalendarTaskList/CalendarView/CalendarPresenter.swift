//
//  CalendarPresenter.swift
//  DiaryToDo
//
//  Created by Pavlentiy on 14.02.2022.
//

import Foundation

struct CalendarViewDataStore {
    let days: [CalendarDay]
    let displayedMonth: String
    let displayedYear: String
    let selectedDate: Date
}

class CalendarPresenter: CalendarViewOutputProtocol {
    unowned let view: CalendarViewInputProtocol
    var interactor: CalendarInteractorInputProtocol!
    
    required init(view: CalendarViewInputProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        interactor.fetchDays(for: .currentMonth, and: nil)
    }
    
    func getPreviousMonth() {
        interactor.fetchDays(for: .previousMonth, and: nil)
    }

    func getNextMonth() {
        interactor.fetchDays(for: .nextMonth, and: nil)
    }
    
    func collectionViewCellDidSelect(at indexPath: IndexPath) {
        interactor.fetchDays(for: .currentMonth, and: indexPath.item)
    }
}

// MARK: - CalendarInteractorOutputProtocol
extension CalendarPresenter: CalendarInteractorOutputProtocol {
    func daysDidReceive(with dataStore: CalendarViewDataStore) {
        let navItemTitle = dataStore.displayedMonth + " " + dataStore.displayedYear
        let calendarSectionVM = CalendarSectionViewModel()
        
        dataStore.days.forEach { calendarSectionVM.cells.append(CalendarCellViewModel(calendarDay: $0))}

        view.reloadCalendar(for: calendarSectionVM, with: navItemTitle, and: dataStore.selectedDate)
    }
}
