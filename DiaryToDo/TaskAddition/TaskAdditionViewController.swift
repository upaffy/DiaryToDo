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
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = true
        tableView.addGestureRecognizer(tapGesture)
        
        taskNameTF.delegate = self
        
        endHourPicker.addTarget(self, action: #selector(hourPickerDidChange), for: .valueChanged)
        startHourPicker.addTarget(self, action: #selector(hourPickerDidChange), for: .valueChanged)
        
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

// MARK: - UITextFieldDelegate
extension TaskAdditionViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.text?.count != 0 {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
}

// MARK: - Private methods
extension TaskAdditionViewController {
    @objc private func hideKeyboard() {
        tableView.endEditing(true)
    }
    
    @objc private func hourPickerDidChange() {
        if startHourPicker.date > endHourPicker.date {
            startHourPicker.setDate(endHourPicker.date, animated: true)
        }
    }
}
