//
//  TaskListPresenter.swift
//  DiaryToDo
//
//  Created by Pavlentiy on 14.02.2022.
//

import Foundation

struct TaskListDataStore {
    let sections: [TaskListSectionViewModel]
}

class TaskListPresenter: TaskListViewOutputProtocol {
    unowned let view: TaskListViewInputProtocol
    var interactor: TaskListInteractorInputProtocol!
    
    private var taskListDataStore: TaskListDataStore?
    
    required init(view: TaskListViewInputProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        interactor.fetchTasksForSelectedDay()
    }
    
    func selectedDayChanged(to date: Date) {
        interactor.updateSelectedDate(to: date)
    }
    
    func tableViewCellDidSelect(at indexPath: IndexPath) {
        guard let task = taskListDataStore?.sections[indexPath.section].tasks[indexPath.row] else {
            return
        }
        
        let tlTask = TLTask(
            dateStart: task.dateStart,
            dateFinish: task.dateFinish,
            name: task.name,
            description: task.description
        )
        
        view.didTapCell(with: tlTask)
    }
}

extension TaskListPresenter: TaskListInteractorOutputProtocol {
    func tasksDidReceive(with dataStore: TaskListDataStore) {
        taskListDataStore = dataStore

        view.reloadTaskList(for: dataStore.sections)
    }
}
