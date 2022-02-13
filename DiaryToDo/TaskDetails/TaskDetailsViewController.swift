//
//  TaskDetailsViewController.swift
//  DiaryToDo
//
//  Created by Pavlentiy on 13.02.2022.
//

import UIKit

protocol TaskDetailsViewOutputProtocol {
    init(view: TaskDetailsViewInputProtocol)
    func prepareDetails()
}

protocol TaskDetailsViewInputProtocol: AnyObject {
    func displayName(with name: String)
    func displayDateStart(with title: String)
    func displayDateFinish(with title: String)
    func displayDescription(with description: String)
}

class TaskDetailsViewController: UIViewController, TaskDetailsViewInputProtocol {
    @IBOutlet var dateStartLabel: UILabel!
    @IBOutlet var dateFinishLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
        
    var presenter: TaskDetailsViewOutputProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.prepareDetails()
    }
    
    func displayName(with name: String) {
        title = name
    }
    
    func displayDateStart(with title: String) {
        dateStartLabel.text = title
    }
    
    func displayDateFinish(with title: String) {
        dateFinishLabel.text = title
    }
    
    func displayDescription(with description: String) {
        descriptionLabel.text = description
    }
}
