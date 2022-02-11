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

class TaskListCell: UITableViewCell, TaskListCellViewModelRepresentable {
    var viewModel: TaskListCellViewModelProtocol? {
        didSet {
            updateView()
        }
    }
    
    private lazy var mainText: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        
        return label
    }()
    
    private lazy var secondaryText: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        
        return label
    }()
    
    private func updateView() {
        guard let viewModel = viewModel as? TaskListCellViewModel else { return }
        
        mainText.text = viewModel.name
        secondaryText.text = viewModel.description
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(mainText)
        addSubview(secondaryText)
        
        NSLayoutConstraint.activate([
            mainText.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            mainText.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            mainText.bottomAnchor.constraint(equalTo: secondaryText.topAnchor, constant: 2),
            
            secondaryText.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            secondaryText.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 5)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
