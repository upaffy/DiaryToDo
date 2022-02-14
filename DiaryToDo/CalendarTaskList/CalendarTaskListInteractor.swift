//
//  CalendarTaskListInteractor.swift
//  DiaryToDo
//
//  Created by Pavlentiy on 07.02.2022.
//

import Foundation

protocol CalendarTaskListInteractorOutputProtocol: AnyObject {
    func selectedDateDidReceive(with dataStore: CalendarTaskListDataStore)
}

protocol CalendarTaskListInteractorInputProtocol {
    init(presenter: CalendarTaskListInteractorOutputProtocol)
    
    func updateSelectedDate(to date: Date)
    func getSelectedDate() -> CalendarTaskListDataStore
}

class CalendarTaskListInteractor: CalendarTaskListInteractorInputProtocol {
    unowned let presenter: CalendarTaskListInteractorOutputProtocol
    
    var selectedDate = Date()
    
    required init(presenter: CalendarTaskListInteractorOutputProtocol) {
        self.presenter = presenter
    }
    
    func updateSelectedDate(to date: Date) {
        selectedDate = date
        presenter.selectedDateDidReceive(with: CalendarTaskListDataStore(date: date))
    }
    
    func getSelectedDate() -> CalendarTaskListDataStore {
        CalendarTaskListDataStore(date: selectedDate)
    }
}
