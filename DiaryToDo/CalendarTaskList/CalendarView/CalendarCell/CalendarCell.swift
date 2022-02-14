//
//  CalendarCell.swift
//  DiaryToDo
//
//  Created by Pavlentiy on 06.02.2022.
//

import UIKit

protocol CalendarCellViewModelRepresentable {
    var viewModel: CalendarCellViewModelProtocol? { get }
}

class CalendarCell: UICollectionViewCell, CalendarCellViewModelRepresentable {
    var viewModel: CalendarCellViewModelProtocol? {
        didSet {
            updateView()
        }
    }
    
    private lazy var selectionBackgroundView: UIView = {
      let view = UIView()
      view.translatesAutoresizingMaskIntoConstraints = false
      view.clipsToBounds = true
      view.backgroundColor = .systemRed
      return view
    }()
    
    private lazy var dayOfMonth: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        
        return label
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
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
        
        if viewModel.isSelected {
            applySelectedStyle()
        } else {
            applyDefaultStyle(isDayCurrent: viewModel.isCurrent)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.addSubview(selectionBackgroundView)
        contentView.addSubview(dayOfMonth)
        
        let minSide = min(frame.width, frame.height)
        let size = minSide - 0.15 * minSide
        
        NSLayoutConstraint.activate([
            dayOfMonth.centerYAnchor.constraint(equalTo: centerYAnchor),
            dayOfMonth.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            selectionBackgroundView.centerYAnchor.constraint(equalTo: dayOfMonth.centerYAnchor),
            selectionBackgroundView.centerXAnchor.constraint(equalTo: dayOfMonth.centerXAnchor),
            selectionBackgroundView.widthAnchor.constraint(equalToConstant: size),
            selectionBackgroundView.heightAnchor.constraint(equalTo: selectionBackgroundView.widthAnchor)
        ])
        
        selectionBackgroundView.layer.cornerRadius = size / 2
    }
    
    private func applySelectedStyle() {
        dayOfMonth.textColor = .white
        selectionBackgroundView.isHidden = false
    }
    
    private func applyDefaultStyle(isDayCurrent: Bool) {
        selectionBackgroundView.isHidden = true
        
        if isDayCurrent {
            dayOfMonth.textColor = .red
        }
    }
}
