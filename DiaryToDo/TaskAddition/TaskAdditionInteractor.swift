//
//  TaskAdditionInteractor.swift
//  DiaryToDo
//
//  Created by Pavlentiy on 12.02.2022.
//

import Foundation

protocol TaskAdditionInteractorOutputProtocol: AnyObject {
    func receiveSelectedDate(_ dataStore: TaskAdditionDataStore)
    func receiveRequest(_ dataStore: RequestDataStore)
}

protocol TaskAdditionInteractorInputProtocol {
    init(presenter: TaskAdditionInteractorOutputProtocol, selectedDate: Date)
    func fetchSelectedDate()
    func saveTask(task: TLTask)
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
    
    func saveTask(task: TLTask) {
        let realmTask = convertToRealmTask(task)
        let success = StorageManager.shared.save(realmTask)
        
        presenter.receiveRequest(RequestDataStore(success: success))
    }
}

// MARK: - Private methods
extension TaskAdditionInteractor {
    private func convertToRealmTask(_ task: TLTask) -> TaskRealm {
        let realmTask = TaskRealm()
        realmTask.id = defineID()
        realmTask.dateStart = task.dateStart.timeIntervalSince1970
        realmTask.dateFinish = task.dateFinish.timeIntervalSince1970
        realmTask.name = task.name
        realmTask.taskDescription = task.description
        
        return realmTask
    }
    
    private func defineID() -> Int {
        let tasks = StorageManager.shared.fetchTasks()
        let maxID = tasks.max(ofProperty: "id") as Int? ?? 0
        
        return maxID + 1
    }
}
