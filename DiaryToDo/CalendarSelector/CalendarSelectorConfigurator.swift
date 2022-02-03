//
//  CalendarSelectorConfigurator.swift
//  DiaryToDo
//
//  Created by Pavlentiy on 03.02.2022.
//

protocol CalendarSelectorConfiguratorInputProtocol {
    func configure(withView view: CalendarSelectorViewController)
}

class CalendarSelectorConfigurator: CalendarSelectorConfiguratorInputProtocol {
    func configure(withView view: CalendarSelectorViewController) {
        let presenter = CalendarSelectorPresenter(view: view)
        let interactor = CalendarSelectorInteractor(presenter: presenter)
        
        view.presenter = presenter
        presenter.interactor = interactor
    }
}
