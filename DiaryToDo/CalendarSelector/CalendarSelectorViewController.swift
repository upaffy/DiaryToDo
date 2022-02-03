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

protocol CalendarSelectorViewInputProtocol {
}

class CalendarSelectorViewController: UIViewController, CalendarSelectorViewInputProtocol {
    
    var presenter: CalendarSelectorViewOutputProtocol!
    
    private let configurator: CalendarSelectorConfiguratorInputProtocol = CalendarSelectorConfigurator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(withView: self)
    }
}
