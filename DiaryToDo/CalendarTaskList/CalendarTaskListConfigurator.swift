//
//  CalendarTaskListConfigurator.swift
//  DiaryToDo
//
//  Created by Pavlentiy on 07.02.2022.
//

protocol CalendarTaskListConfiguratorInputProtocol {
    func configure(with viewController: CalendarTaskListViewController)
}

class CalendarTaskListConfigurator: CalendarTaskListConfiguratorInputProtocol {
    func configure(with viewController: CalendarTaskListViewController) {
        let presenter = CalendarTaskListPresenter(view: viewController)
        let interactor = CalendarTaskListInteractor(presenter: presenter)
        let router = CalendarTaskListRouter(viewController: viewController)
        
        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
    }
}
