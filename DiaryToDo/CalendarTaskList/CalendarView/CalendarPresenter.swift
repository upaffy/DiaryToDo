//
//  CalendarPresenter.swift
//  DiaryToDo
//
//  Created by Pavlentiy on 14.02.2022.
//

import Foundation

struct CalendarViewDataStore {
    let days: [CalendarDay]
    let baseDate: Date
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
        let calendarSectionVM = CalendarSectionViewModel()
        dataStore.days.forEach { calendarSectionVM.cells.append(CalendarCellViewModel(calendarDay: $0))}
        
        let currentDateString = convertToShortString(date: dataStore.baseDate)
        let selectedDateString = convertToLongString(date: dataStore.selectedDate)
        
        view.reloadCalendar(
            for: calendarSectionVM,
            selectedDate: dataStore.selectedDate,
            currentDateTitle: currentDateString,
            selectedDateTitle: selectedDateString
        )
    }
}

// MARK: - Private Methods
extension CalendarPresenter {
    private func convertToLongString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM y"
        
        return dateFormatter.string(from: date)
    }
    
    private func convertToShortString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM y"
        
        return dateFormatter.string(from: date)
    }
}
