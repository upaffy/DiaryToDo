//
//  TaskListCell.swift
//  DiaryToDo
//
//  Created by Pavlentiy on 10.02.2022.
//

import UIKit

protocol TaskListCellViewModelRepresentable {
    var viewModel: TaskListCellViewModelProtocol? { get }
}

class TaskListTableViewCell: UITableViewCell, TaskListCellViewModelRepresentable {
    var viewModel: TaskListCellViewModelProtocol? {
        didSet {
            updateView()
        }
    }
    
    private func updateView() {
        guard let viewModel = viewModel as? TaskListCellViewModel else { return }
    }
}
