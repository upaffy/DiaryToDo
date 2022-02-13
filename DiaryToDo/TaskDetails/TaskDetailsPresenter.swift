//
//  TaskDetailsPresenter.swift
//  DiaryToDo
//
//  Created by Pavlentiy on 13.02.2022.
//

import Foundation

struct TaskDetailsDataStore {
    let name: String
    let description: String
    let dateStart: Date
    let dateFinish: Date
}

class TaskDetailsPresenter: TaskDetailsViewOutputProtocol {
    unowned let view: TaskDetailsViewInputProtocol
    var interactor: TaskDetailsInteractorInputProtocol!
    
    required init(view: TaskDetailsViewInputProtocol) {
        self.view = view
    }
    
    func prepareDetails() {
        interactor.provideTaskDetails()
    }
}

extension TaskDetailsPresenter: TaskDetailsInteractorOutputProtocol {
    func receiveTaskDetails(with dataStore: TaskDetailsDataStore) {
        view.displayName(with: dataStore.name)
        view.displayDescription(with: dataStore.description)
        
        let dateStartString = convertToString(date: dataStore.dateStart)
        view.displayDateStart(with: "Date Start: \(dateStartString)")
        
        let dateFinishString = convertToString(date: dataStore.dateFinish)
        view.displayDateFinish(with: "Date Finish: \(dateFinishString)")
    }
    
    private func convertToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm, dd MMMM y"

        return dateFormatter.string(from: date)
    }
}
