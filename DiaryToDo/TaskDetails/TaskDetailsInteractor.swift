//
//  TaskDetailsInteractor.swift
//  DiaryToDo
//
//  Created by Pavlentiy on 13.02.2022.
//

protocol TaskDetailsInteractorOutputProtocol: AnyObject {
    func receiveTaskDetails(with dataStore: TaskDetailsDataStore)
}

protocol TaskDetailsInteractorInputProtocol {
    init(presenter: TaskDetailsInteractorOutputProtocol, task: TLTask)
    func provideTaskDetails()
}

class TaskDetailsInteractor: TaskDetailsInteractorInputProtocol {
    unowned let presenter: TaskDetailsInteractorOutputProtocol
    let task: TLTask
    
    required init(presenter: TaskDetailsInteractorOutputProtocol, task: TLTask) {
        self.presenter = presenter
        self.task = task
    }
    
    func provideTaskDetails() {
        let dataStore = TaskDetailsDataStore(
            name: task.name,
            description: task.description,
            dateStart: task.dateStart,
            dateFinish: task.dateFinish
        )
        
        presenter.receiveTaskDetails(with: dataStore)
    }
}
