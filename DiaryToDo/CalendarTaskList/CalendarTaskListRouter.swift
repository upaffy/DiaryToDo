//
//  CalendarTaskListRouter.swift
//  DiaryToDo
//
//  Created by Pavlentiy on 12.02.2022.
//

import Foundation

protocol CalendarTaskListRouterInputProtocol {
    init(viewController: CalendarTaskListViewController)
    func openAddTaskViewController(with selectedDate: Date)
}

class CalendarTaskListRouter: CalendarTaskListRouterInputProtocol {
    unowned let viewController: CalendarTaskListViewController
    
    required init(viewController: CalendarTaskListViewController) {
        self.viewController = viewController
    }
    
    func openAddTaskViewController(with selectedDate: Date) {
        viewController.performSegue(withIdentifier: "OpenAddController", sender: selectedDate)
    }
}
