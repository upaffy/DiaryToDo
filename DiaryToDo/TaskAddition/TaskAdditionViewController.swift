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
    func saveButtonPressed(day: Date, timeStart: Date, timeEnd: Date, name: String, description: String)
}

protocol TaskAdditionViewInputProtocol: AnyObject {
    func displaySelectedDate(_ date: Date)
    func handleSaveResult(success: Bool)
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
        
        endHourPicker.addTarget(self, action: #selector(endHourPickerDidChange), for: .valueChanged)
        startHourPicker.addTarget(self, action: #selector(startHourPickerDidChange), for: .valueChanged)
        
        presenter.viewDidLoad()
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        presenter.saveButtonPressed(
            day: dayPicker.date,
            timeStart: startHourPicker.date,
            timeEnd: endHourPicker.date,
            name: taskNameTF.text ?? "no Title",
            description: descriptionTextView.text
        )
    }
    
    func displaySelectedDate(_ date: Date) {
        dayPicker.setDate(date, animated: false)
    }
    
    func handleSaveResult(success: Bool) {
        if success {
            performSegue(withIdentifier: "unwindToTaskListVC", sender: nil)
        } else {
            showAlert(title: "Ooops", message: "Something went wrong")
        }
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
    
    @objc private func startHourPickerDidChange() {
        if endHourPicker.date < startHourPicker.date {
            endHourPicker.setDate(startHourPicker.date, animated: true)
        }
    }
    
    @objc private func endHourPickerDidChange() {
        if startHourPicker.date > endHourPicker.date {
            startHourPicker.setDate(endHourPicker.date, animated: true)
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) {_ in
            self.dismiss(animated: true)
        }
        alert.addAction(okAction)
        
        present(alert, animated: true)
    }
}
