//
//  TaskListConfigurator.swift
//  DiaryToDo
//
//  Created by Pavlentiy on 14.02.2022.
//

import Foundation

protocol TaskListConfiguratorInputProtocol {
    func configure(with view: TaskListView, and selectedDate: Date)
}

class TaskListConfigurator: TaskListConfiguratorInputProtocol {
    func configure(with view: TaskListView, and selectedDate: Date) {
        let presenter = TaskListPresenter(view: view)
        let interactor = TaskListInteractor(presenter: presenter, selectedDate: selectedDate)
        
        view.presenter = presenter
        presenter.interactor = interactor
    }
}
