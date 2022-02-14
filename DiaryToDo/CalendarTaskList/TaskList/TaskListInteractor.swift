//
//  TaskListInteractor.swift
//  DiaryToDo
//
//  Created by Pavlentiy on 14.02.2022.
//

import RealmSwift

protocol TaskListInteractorOutputProtocol: AnyObject {
    func tasksDidReceive(with dataStore: TaskListDataStore)
}

protocol TaskListInteractorInputProtocol {
    init(presenter: TaskListInteractorOutputProtocol, selectedDate: Date)
    
    func fetchTasksForSelectedDay()
    func updateSelectedDate(to date: Date)
}

class TaskListInteractor: TaskListInteractorInputProtocol {
    unowned let presenter: TaskListInteractorOutputProtocol!
    
    let calendar = Calendar.current
    let secondsInHour = TimeInterval(3600)
    
    private var selectedDate: Date
    
    required init(presenter: TaskListInteractorOutputProtocol, selectedDate: Date) {
        self.presenter = presenter
        self.selectedDate = selectedDate
    }
    
    func fetchTasksForSelectedDay() {
        let realmTasks = StorageManager.shared.fetchTasks()
        let sections = prepareTableViewSections(from: realmTasks)
        
        let dataStore = TaskListDataStore(sections: sections)
        
        presenter.tasksDidReceive(with: dataStore)
    }
    
    func updateSelectedDate(to date: Date) {
        selectedDate = date
        fetchTasksForSelectedDay()
    }
}

// MARK: - Private Methods
extension TaskListInteractor {
    private func prepareTableViewSections(from realmTasks: Results<TaskRealm>) -> [TaskListSectionViewModel] {
        var sections: [TaskListSectionViewModel] = []
        
        let dayStart = calendar.dateInterval(of: .day, for: selectedDate)?.start ?? Date()
        let dayEnd = calendar.dateInterval(of: .day, for: selectedDate)?.end ?? Date()
        
        let startDayTimestamp = dayStart.timeIntervalSince1970
        let endDayTimestamp = dayEnd.timeIntervalSince1970
        
        let tasksInSelectedDay = defineTasks(between: startDayTimestamp, and: endDayTimestamp, from: realmTasks)
        
        var timeCounter = startDayTimestamp
        while timeCounter < endDayTimestamp {
            // moves through the day in 1-hour increments
            sections.append(prepareHourSection(startHour: timeCounter, with: tasksInSelectedDay))
            
            timeCounter += secondsInHour
        }
        
        return sections
    }
    
    private func prepareHourSection(startHour: TimeInterval, with tasks: Results<TaskRealm>) -> TaskListSectionViewModel {
        let taskListSectionViewModel = TaskListSectionViewModel()
        
        let endHour = startHour + secondsInHour
        
        let currentHourTasks = defineTasks(between: startHour, and: endHour, from: tasks)
        currentHourTasks.forEach { realmTask in
            let tlTask = convertDataToTLTask(from: realmTask)
            taskListSectionViewModel.tasks.append(TaskListCellViewModel(task: tlTask))
        }
        
        let sectionName = fetchHourStringFromTimestamp(startHour) + " - " + fetchHourStringFromTimestamp(endHour)
        
        taskListSectionViewModel.sectionName = sectionName
        
        return taskListSectionViewModel
    }
    
    // swiftlint:disable:next line_length
    private func defineTasks(between lhs: TimeInterval, and rhs: TimeInterval, from tasks: Results<TaskRealm>) -> Results<TaskRealm> {
        let predicate = NSPredicate(
            format: "dateFinish > %@ AND dateStart <= %@",
            NSNumber(value: lhs),
            NSNumber(value: rhs)
        )
        
        return tasks.filter(predicate)
    }
    
    private func convertDataToTLTask(from task: TaskRealm) -> TLTask {
        TLTask(
            id: task.id,
            dateStart: Date(timeIntervalSince1970: task.dateStart),
            dateFinish: Date(timeIntervalSince1970: task.dateFinish),
            name: task.name,
            description: task.taskDescription
        )
    }
    
    private func fetchHourStringFromTimestamp(_ timestamp: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH"
        
        return "\(dateFormatter.string(from: date)):00"
    }
}
