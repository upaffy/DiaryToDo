//
//  CalendarTaskListInteractor.swift
//  DiaryToDo
//
//  Created by Pavlentiy on 07.02.2022.
//

protocol CalendarTaskListInteractorOutputProtocol: AnyObject {

}

protocol CalendarTaskListInteractorInputProtocol {
    init(presenter: CalendarTaskListInteractorOutputProtocol)
}

class CalendarTaskListInteractor: CalendarTaskListInteractorInputProtocol {
    unowned let presenter: CalendarTaskListInteractorOutputProtocol
    
    required init(presenter: CalendarTaskListInteractorOutputProtocol) {
        self.presenter = presenter
    }
}
