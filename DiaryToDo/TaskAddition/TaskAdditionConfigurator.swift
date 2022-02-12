//
//  TaskAdditionConfigurator.swift
//  DiaryToDo
//
//  Created by Pavlentiy on 12.02.2022.
//

import Foundation

protocol TaskAdditionConfiguratorInputProtocol {
    func configure(with view: TaskAdditionViewController, and selectedDate: Date)
}

class TaskAdditionConfigurator: TaskAdditionConfiguratorInputProtocol {
    func configure(with view: TaskAdditionViewController, and selectedDate: Date) {
        let presenter = TaskAdditionPresenter(view: view)
        let interactor = TaskAdditionInteractor(presenter: presenter, selectedDate: selectedDate)
        
        view.presenter = presenter
        presenter.interactor = interactor
    }
}
