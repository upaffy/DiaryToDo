//
//  CalendarSelectorPresenter.swift
//  DiaryToDo
//
//  Created by Pavlentiy on 03.02.2022.
//

struct CalendarData {
    
}

class CalendarSelectorPresenter: CalendarSelectorViewOutputProtocol, CalendarSelectorInteractorOutputProtocol {
    unowned var view: CalendarSelectorViewInputProtocol!
    var interactor: CalendarSelectorInteractorInputProtocol!
    
    required init(view: CalendarSelectorViewInputProtocol) {
        self.view = view
    }
}
