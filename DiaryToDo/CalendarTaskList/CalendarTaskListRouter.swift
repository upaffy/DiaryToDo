//
//  CalendarTaskListRouter.swift
//  DiaryToDo
//
//  Created by Pavlentiy on 12.02.2022.
//

import Foundation

protocol CalendarTaskListRouterInputProtocol {
    init(viewController: CalendarTaskListViewController)
    func openTaskAdditionViewController(with selectedDate: Date)
}

class CalendarTaskListRouter: CalendarTaskListRouterInputProtocol {
    unowned let viewController: CalendarTaskListViewController
    
    required init(viewController: CalendarTaskListViewController) {
        self.viewController = viewController
    }
    
    func openTaskAdditionViewController(with selectedDate: Date) {
        viewController.performSegue(withIdentifier: "OpenAdditionController", sender: selectedDate)
    }
}
