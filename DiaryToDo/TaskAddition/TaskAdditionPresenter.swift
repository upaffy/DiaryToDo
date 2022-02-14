//
//  TaskAdditionPresenter.swift
//  DiaryToDo
//
//  Created by Pavlentiy on 12.02.2022.
//

import Foundation

struct TaskAdditionDataStore {
    let selectedDate: Date
}

struct RequestDataStore {
    let success: Bool
}

class TaskAdditionPresenter: TaskAdditionViewOutputProtocol {
    unowned let view: TaskAdditionViewInputProtocol
    
    var interactor: TaskAdditionInteractorInputProtocol!
    
    required init(view: TaskAdditionViewInputProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        interactor.fetchSelectedDate()
    }
    
    func saveButtonPressed(day: Date, timeStart: Date, timeEnd: Date, name: String, description: String) {
        let (startDate, endDate) = defineStartAndEndDates(day: day, timeStart: timeStart, timeEnd: timeEnd)
        
        let tlTask = TLTask(
            dateStart: startDate,
            dateFinish: endDate,
            name: name,
            description: description
        )
        
        interactor.saveTask(task: tlTask)
    }
}

// MARK: - TaskAdditionInteractorOutputProtocol
extension TaskAdditionPresenter: TaskAdditionInteractorOutputProtocol {
    func receiveSelectedDate(_ dataStore: TaskAdditionDataStore) {
        view.displaySelectedDate(dataStore.selectedDate)
    }
    
    func receiveRequest(_ dataStore: RequestDataStore) {
        view.handleSaveResult(success: dataStore.success)
    }
}

// MARK: - Private methods
extension TaskAdditionPresenter {
    private func defineStartAndEndDates(day: Date, timeStart: Date, timeEnd: Date) -> (Date, Date) {
        let calendar = Calendar.current
        
        let dayComponents = calendar.dateComponents([.year, .month, .day], from: day)
        let startTimeComponents = calendar.dateComponents([.hour, .minute], from: timeStart)
        let endTimeComponents = calendar.dateComponents([.hour, .minute], from: timeEnd)
        
        let startDateComponents = DateComponents(
            year: dayComponents.year,
            month: dayComponents.month,
            day: dayComponents.day,
            hour: startTimeComponents.hour,
            minute: startTimeComponents.minute
        )
        
        let endDateComponents = DateComponents(
            year: dayComponents.year,
            month: dayComponents.month,
            day: dayComponents.day,
            hour: endTimeComponents.hour,
            minute: endTimeComponents.minute
        )
        
        let startDate = calendar.date(from: startDateComponents) ?? Date()
        let endDate = calendar.date(from: endDateComponents) ?? Date()
        
        return (startDate, endDate)
    }
}
