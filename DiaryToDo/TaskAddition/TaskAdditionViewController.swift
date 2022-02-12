//
//  TaskAdditionViewController.swift
//  DiaryToDo
//
//  Created by Pavlentiy on 12.02.2022.
//

import UIKit

protocol TaskAdditionViewOutputProtocol {
    init(view: TaskAdditionViewInputProtocol)
    func viewDidLoad()
}

protocol TaskAdditionViewInputProtocol: AnyObject {
    func displaySelectedDate(_ date: Date)
}

class TaskAdditionViewController: UITableViewController, TaskAdditionViewInputProtocol {
    var presenter: TaskAdditionViewOutputProtocol!
    
    @IBOutlet var saveButton: UIBarButtonItem!
    
    @IBOutlet var dayPicker: UIDatePicker!
    @IBOutlet var startHourPicker: UIDatePicker!
    @IBOutlet var endHourPicker: UIDatePicker!
    @IBOutlet var taskNameTF: UITextField!
    @IBOutlet var descriptionTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
    }
    
    func displaySelectedDate(_ date: Date) {
        dayPicker.setDate(date, animated: false)
    }
}
