//
//  TaskAdditionInteractor.swift
//  DiaryToDo
//
//  Created by Pavlentiy on 12.02.2022.
//

import Foundation

protocol TaskAdditionInteractorOutputProtocol: AnyObject {
    func receiveSelectedDate(_ dataStore: TaskAdditionDataStore)
}

protocol TaskAdditionInteractorInputProtocol {
    init(presenter: TaskAdditionInteractorOutputProtocol, selectedDate: Date)
    func fetchSelectedDate()
}

class TaskAdditionInteractor: TaskAdditionInteractorInputProtocol {
    unowned let presenter: TaskAdditionInteractorOutputProtocol
    
    private let selectedDate: Date
    
    required init(presenter: TaskAdditionInteractorOutputProtocol, selectedDate: Date) {
        self.presenter = presenter
        self.selectedDate = selectedDate
    }
    
    func fetchSelectedDate() {
        let dataStore = TaskAdditionDataStore(selectedDate: selectedDate)
        presenter.receiveSelectedDate(dataStore)
    }
}
