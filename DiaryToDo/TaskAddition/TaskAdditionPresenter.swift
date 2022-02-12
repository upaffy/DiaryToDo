//
//  TaskAdditionPresenter.swift
//  DiaryToDo
//
//  Created by Pavlentiy on 12.02.2022.
//

struct TaskAdditionDataStore {
    
}

class TaskAdditionPresenter: TaskAdditionViewOutputProtocol {
    unowned let view: TaskAdditionViewInputProtocol
    var interactor: TaskAdditionInteractorInputProtocol!
    
    required init(view: TaskAdditionViewInputProtocol) {
        self.view = view
    }
}

// MARK: - TaskAdditionInteractorOutputProtocol
extension TaskAdditionPresenter: TaskAdditionInteractorOutputProtocol {
    
}
