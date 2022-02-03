//
//  CalendarSelectorInteractor.swift
//  DiaryToDo
//
//  Created by Pavlentiy on 03.02.2022.
//

protocol CalendarSelectorInteractorOutputProtocol {
}

protocol CalendarSelectorInteractorInputProtocol {
    init(presenter: CalendarSelectorInteractorOutputProtocol)
}

class CalendarSelectorInteractor: CalendarSelectorInteractorInputProtocol {
    unowned var presenter: CalendarSelectorInteractorOutputProtocol!
    
    required init(presenter: CalendarSelectorInteractorOutputProtocol) {
        self.presenter = presenter
    }
}
