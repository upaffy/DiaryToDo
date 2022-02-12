//
//  TaskAdditionViewController.swift
//  DiaryToDo
//
//  Created by Pavlentiy on 12.02.2022.
//

import UIKit

protocol TaskAdditionViewOutputProtocol {
    init(view: TaskAdditionViewInputProtocol)
}

protocol TaskAdditionViewInputProtocol: AnyObject {
    
}

class TaskAdditionViewController: UITableViewController, TaskAdditionViewInputProtocol {
    var presenter: TaskAdditionViewOutputProtocol!
}
