//
//  TaskListView.swift
//  DiaryToDo
//
//  Created by Pavlentiy on 14.02.2022.
//

import UIKit

protocol TaskListDelegate: AnyObject {
    func didTapCell(with task: TLTask)
}

protocol TaskListViewOutputProtocol: AnyObject {
    init(view: TaskListViewInputProtocol)
    func viewDidLoad()
    func selectedDayChanged(to date: Date)
    func tableViewCellDidSelect(at indexPath: IndexPath)
}

protocol TaskListViewInputProtocol: AnyObject {
    func reloadTaskList(for taskListSections: [TaskListSectionViewModel])
    func didTapCell(with task: TLTask)
}

class TaskListView: UITableView, TaskListViewInputProtocol {
    var presenter: TaskListViewOutputProtocol!
    
    var taskListDelegate: TaskListDelegate! {
        didSet {
            setupTableView()
        }
    }
    
    private var taskListSectionViewModels: [TaskListSectionViewModelProtocol] = []
    
    func reloadTaskList(for taskListSections: [TaskListSectionViewModel]) {
        taskListSectionViewModels = taskListSections
        
        reloadData()
    }
    
    func updateTaskList(for selectedDate: Date) {
        presenter.selectedDayChanged(to: selectedDate)
    }
    
    func didTapCell(with task: TLTask) {
        taskListDelegate.didTapCell(with: task)
    }
}

// MARK: - Private methods
extension TaskListView {
    private func setupTableView() {
        presenter.viewDidLoad()
        
        register(
            TaskListCell.self,
            forCellReuseIdentifier: TaskListCellViewModel.reuseIdentifier
        )
        
        delegate = self
        dataSource = self
    }
}

// MARK: - UITableViewDataSource
extension TaskListView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        taskListSectionViewModels[section].tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let taskListCellViewModel = taskListSectionViewModels[indexPath.section].tasks[indexPath.row]
        // swiftlint:disable force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskListCellViewModel.reuseIdentifier,
                                                 for: indexPath) as! TaskListCell
        // swiftlint:enable force_cast
        
        cell.viewModel = taskListCellViewModel
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        taskListSectionViewModels.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        taskListSectionViewModels[section].sectionName
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
}

// MARK: - UITableViewDelegate
extension TaskListView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.tableViewCellDidSelect(at: indexPath)
    }
}
