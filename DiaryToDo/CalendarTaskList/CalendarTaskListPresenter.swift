//
//  CalendarTaskListPresenter.swift
//  DiaryToDo
//
//  Created by Pavlentiy on 07.02.2022.
//

struct CalendarTaskListDataStore {
    
}

class CalendarTaskListPresenter: CalendarTaskListViewOutputProtocol {
    unowned let view: CalendarTaskListViewInputProtocol
    var interactor: CalendarTaskListInteractorInputProtocol!
    
    private var dataStore: CalendarTaskListDataStore?
    
    required init(view: CalendarTaskListViewInputProtocol) {
        self.view = view
    }
}

extension CalendarTaskListPresenter: CalendarTaskListInteractorOutputProtocol {
    
}
