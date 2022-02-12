//
//  TaskAdditionPresenter.swift
//  DiaryToDo
//
//  Created by Pavlentiy on 12.02.2022.
//

import Foundation

struct TaskAdditionDataStore {
    let selectedDate: Date
}

class TaskAdditionPresenter: TaskAdditionViewOutputProtocol {
    unowned let view: TaskAdditionViewInputProtocol
    var interactor: TaskAdditionInteractorInputProtocol!
    
    required init(view: TaskAdditionViewInputProtocol) {
        self.view = view
        
    }
    
    func viewDidLoad() {
        interactor.fetchSelectedDate()
    }
}

// MARK: - TaskAdditionInteractorOutputProtocol
extension TaskAdditionPresenter: TaskAdditionInteractorOutputProtocol {
    func receiveSelectedDate(_ dataStore: TaskAdditionDataStore) {
        view.displaySelectedDate(dataStore.selectedDate)
    }
}
