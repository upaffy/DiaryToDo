//
//  CalendarConfigurator.swift
//  DiaryToDo
//
//  Created by Pavlentiy on 14.02.2022.
//

protocol CalendarConfiguratorInputProtocol {
    func configure(with view: CalendarView)
}

class CalendarConfigurator: CalendarConfiguratorInputProtocol {
    func configure(with view: CalendarView) {
        let presenter = CalendarPresenter(view: view)
        let interactor = CalendarInteractor(presenter: presenter)
        
        view.presenter = presenter
        presenter.interactor = interactor
    }
}

