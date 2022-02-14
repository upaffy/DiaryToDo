//
//  CalendarTaskListPresenter.swift
//  DiaryToDo
//
//  Created by Pavlentiy on 07.02.2022.
//

import Foundation

struct CalendarTaskListDataStore {
    let date: Date
}

class CalendarTaskListPresenter: CalendarTaskListViewOutputProtocol {
    unowned let view: CalendarTaskListViewInputProtocol
    var interactor: CalendarTaskListInteractorInputProtocol!
    var router: CalendarTaskListRouterInputProtocol!
    
    required init(view: CalendarTaskListViewInputProtocol) {
        self.view = view
    }
    
    func selectedDateChanged(to date: Date) {
        interactor.updateSelectedDate(to: date)
    }
    
    func addButtonPressed() {
        let selectedDate = interactor.getSelectedDate().date
        router.openTaskAdditionViewController(with: selectedDate)
    }
    
    func taskListCellSelected(with task: TLTask) {
        router.openTaskDetailsViewController(with: task)
    }
    
    func taskAdditionVCDidDisapear() {
        let selectedDate = interactor.getSelectedDate().date
        view.updateTaskList(for: selectedDate)
    }
}

// MARK: - CalendarTaskListInteractorOutputProtocol
extension CalendarTaskListPresenter: CalendarTaskListInteractorOutputProtocol {
    func selectedDateDidReceive(with dataStore: CalendarTaskListDataStore) {
        view.updateTaskList(for: dataStore.date)
    }
}
