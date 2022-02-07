//
//  CalendarCell.swift
//  DiaryToDo
//
//  Created by Pavlentiy on 06.02.2022.
//

import UIKit

class CalendarCell: UICollectionViewCell {
    var dayOfMonth: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        return label
    }()
    
    static let reuseIdentifier = String(describing: CalendarCell.self)
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(dayOfMonth)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        NSLayoutConstraint.activate([
          dayOfMonth.centerYAnchor.constraint(equalTo: centerYAnchor),
          dayOfMonth.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}
