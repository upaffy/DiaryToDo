//
//  ViewController.swift
//  DiaryToDo
//
//  Created by Pavlentiy on 01.02.2022.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var calendar: CalendarSelectorViewController = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0

        return CalendarSelectorViewController(frame: .zero, collectionViewLayout: layout)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        
        view.addSubview(calendar)
        
        NSLayoutConstraint.activate([
            calendar.leadingAnchor.constraint(
              equalTo: view.readableContentGuide.leadingAnchor),
            calendar.trailingAnchor.constraint(
              equalTo: view.readableContentGuide.trailingAnchor),
            calendar.centerYAnchor.constraint(
              equalTo: view.centerYAnchor,
              constant: 10),
            calendar.heightAnchor.constraint(
              equalTo: view.heightAnchor,
              multiplier: 0.5)
        ])
    }

}
