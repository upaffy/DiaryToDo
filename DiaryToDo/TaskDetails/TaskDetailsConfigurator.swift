//
//  TaskDetailsConfigurator.swift
//  DiaryToDo
//
//  Created by Pavlentiy on 13.02.2022.
//

protocol TaskDetailsConfiguratorInputProtocol {
    func configure(with view: TaskDetailsViewController, and task: TLTask)
}

class TaskDetailsConfigurator: TaskDetailsConfiguratorInputProtocol {
    func configure(with view: TaskDetailsViewController, and task: TLTask) {
        let presenter = TaskDetailsPresenter(view: view)
        let interactor = TaskDetailsInteractor(presenter: presenter, task: task)
        
        view.presenter = presenter
        presenter.interactor = interactor
    }
}
