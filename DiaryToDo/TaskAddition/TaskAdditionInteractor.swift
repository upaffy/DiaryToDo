//
//  TaskAdditionInteractor.swift
//  DiaryToDo
//
//  Created by Pavlentiy on 12.02.2022.
//

import Foundation

protocol TaskAdditionInteractorOutputProtocol: AnyObject {
    
}

protocol TaskAdditionInteractorInputProtocol {
    init(presenter: TaskAdditionInteractorOutputProtocol, selectedDate: Date)
}

class TaskAdditionInteractor: TaskAdditionInteractorInputProtocol {
    unowned let presenter: TaskAdditionInteractorOutputProtocol
    
    private let selectedDate: Date
    
    required init(presenter: TaskAdditionInteractorOutputProtocol, selectedDate: Date) {
        self.presenter = presenter
        self.selectedDate = selectedDate
    }
}
