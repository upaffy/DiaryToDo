//
//  CalendarCell.swift
//  DiaryToDo
//
//  Created by Pavlentiy on 06.02.2022.
//

import UIKit

protocol CellViewModelRepresentable {
    var viewModel: CalendarCellViewModelProtocol? { get }
}

class CalendarCell: UICollectionViewCell, CellViewModelRepresentable {
    var viewModel: CalendarCellViewModelProtocol? {
        didSet {
            updateView()
        }
    }
    
    private lazy var dayOfMonth: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        
        return label
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(dayOfMonth)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func updateView() {
        guard let viewModel = viewModel as? CalendarCellViewModel else { return }
        
        dayOfMonth.text = viewModel.dayOfMonth
        
        if viewModel.dayType == .current {
            dayOfMonth.textColor = .black
        } else if viewModel.dayType == .weekday {
            dayOfMonth.textColor = .red
        } else {
            dayOfMonth.textColor = .gray
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        NSLayoutConstraint.activate([
          dayOfMonth.centerYAnchor.constraint(equalTo: centerYAnchor),
          dayOfMonth.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}
