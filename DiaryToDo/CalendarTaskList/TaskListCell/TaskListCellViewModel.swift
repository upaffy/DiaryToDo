//
//  TaskListCellViewModel.swift
//  DiaryToDo
//
//  Created by Pavlentiy on 10.02.2022.
//
import Foundation

protocol TaskListCellViewModelProtocol {
    static var reuseIdentifier: String { get }
    var name: String { get }
    var description: String { get }
    var timeStart: TimeInterval { get }
    var timeFinish: TimeInterval { get }
    
    init(task: TLTask)
}

protocol TaskListSectionViewModelProtocol {
    var sectionName: String { get }
    var tasks: [TaskListCellViewModelProtocol] { get }
}

class TaskListCellViewModel: TaskListCellViewModelProtocol {
    static var reuseIdentifier = String(describing: CalendarCellViewModel.self)
    
    var name: String {
        task.name
    }
    
    var description: String {
        task.description
    }
    
    var timeStart: TimeInterval {
        task.dateStart
    }
    
    var timeFinish: TimeInterval {
        task.dateFinish
    }
    
    private let task: TLTask
    
    required init(task: TLTask) {
        self.task = task
    }
}

class TaskListSectionViewModel: TaskListSectionViewModelProtocol {
    var sectionName = ""
    var tasks: [TaskListCellViewModelProtocol] = []
}
