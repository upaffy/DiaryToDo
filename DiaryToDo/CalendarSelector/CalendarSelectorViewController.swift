//
//  CalendarSelectorViewController.swift
//  DiaryToDo
//
//  Created by Pavlentiy on 03.02.2022.
//

import UIKit

protocol CalendarSelectorViewOutputProtocol {
    init(view: CalendarSelectorViewInputProtocol)
}

protocol CalendarSelectorViewInputProtocol: AnyObject {
}

class CalendarSelectorViewController: UIView, CalendarSelectorViewInputProtocol {
    
    var presenter: CalendarSelectorViewOutputProtocol!
    
    private let configurator: CalendarSelectorConfiguratorInputProtocol = CalendarSelectorConfigurator()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }
    
    private func configureView() {
        
    }
}
