//
//  ViewController.swift
//  DiaryToDo
//
//  Created by Pavlentiy on 01.02.2022.
//

import UIKit

protocol CalendarTaskListViewOutputProtocol {
    init(view: CalendarTaskListViewInputProtocol)
    
    func selectedDateChanged(to date: Date)
    func addButtonPressed()
    func taskAdditionVCDidDisapear()
    func taskListCellSelected(with task: TLTask)
}

protocol CalendarTaskListViewInputProtocol: AnyObject {
    func updateTaskList(for selectedDate: Date)
}

class CalendarTaskListViewController: UIViewController {
    var presenter: CalendarTaskListViewOutputProtocol!
    private let configurator: CalendarTaskListConfiguratorInputProtocol = CalendarTaskListConfigurator()
        
    private lazy var leftButton: UIButton = {
        let button = ArrowButton(buttonSize: 50)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(showPreviousMonth), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var rightButton: UIButton = {
        let button = ArrowButton(buttonSize: 50, isMirrored: true)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(showNextMonth), for: .touchUpInside)

        return button
    }()
    
    private lazy var divider: UIView = {
        let divider = UIView()
        divider.translatesAutoresizingMaskIntoConstraints = false
        
        divider.backgroundColor = .lightGray
        
        return divider
    }()
    
    private lazy var selectedDayLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false

        label.textAlignment = .center
        label.text = "12 February"
        label.font = UIFont.preferredFont(forTextStyle: .body)
        
        return label
    }()
    
    private lazy var calendarView: CalendarView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let collectionView = CalendarView(frame: .zero, collectionViewLayout: layout)
        let configurator: CalendarConfiguratorInputProtocol = CalendarConfigurator()
        
        configurator.configure(with: collectionView)
        collectionView.calendarDelegate = self
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    private lazy var taskList: TaskListView = {
        let tableView = TaskListView()
        let configurator: TaskListConfiguratorInputProtocol = TaskListConfigurator()
        
        configurator.configure(with: tableView, and: Date())
        tableView.taskListDelegate = self
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(with: self)
        
        addSubviews(
            leftButton,
            calendarView,
            rightButton,
            divider,
            selectedDayLabel,
            taskList
        )

        setupConstraints()
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        presenter.addButtonPressed()
    }
}

// MARK: - Navigation
extension CalendarTaskListViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if let taskDetailsVC = segue.destination as? TaskDetailsViewController {
            let configurator: TaskDetailsConfiguratorInputProtocol = TaskDetailsConfigurator()
            guard let task = sender as? TLTask else { return }

            configurator.configure(with: taskDetailsVC, and: task)

        } else {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let taskAdditionVC = navigationController.children.first as? TaskAdditionViewController
            else {
                return
            }

            let configurator: TaskAdditionConfiguratorInputProtocol = TaskAdditionConfigurator()
            guard let selectedDate = sender as? Date else { return }

            configurator.configure(with: taskAdditionVC, and: selectedDate)
        }
    }

    @IBAction func unwind(for segue: UIStoryboardSegue) {
        guard segue.source as? TaskAdditionViewController != nil else { return }
        presenter.taskAdditionVCDidDisapear()
    }
}

// MARK: - Private Functions
extension CalendarTaskListViewController {
    private func setupConstraints() {
        let constraints = [
            leftButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            leftButton.centerYAnchor.constraint(equalTo: calendarView.centerYAnchor),
            leftButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.08),
            
            rightButton.centerYAnchor.constraint(equalTo: calendarView.centerYAnchor),
            rightButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            rightButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.08),

            calendarView.leadingAnchor.constraint(equalTo: leftButton.trailingAnchor),
            calendarView.trailingAnchor.constraint(equalTo: rightButton.leadingAnchor),
            calendarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            calendarView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),
            
            divider.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: 10),
            divider.heightAnchor.constraint(equalToConstant: 1),
            divider.widthAnchor.constraint(equalTo: view.widthAnchor),
            divider.bottomAnchor.constraint(equalTo: selectedDayLabel.topAnchor, constant: -10),
            
            selectedDayLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            selectedDayLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            taskList.topAnchor.constraint(equalTo: selectedDayLabel.bottomAnchor),
            taskList.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            taskList.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            taskList.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc private func showPreviousMonth(_ sender: Any) {
        calendarView.showPreviousMonth()
    }

    @objc private func showNextMonth(_ sender: Any) {
        calendarView.showNextMonth()
    }
    
    private func addSubviews(_ views: UIView...) {
        views.forEach { subview in
            view.addSubview(subview)
        }
    }
}

// MARK: - CalendarTaskListViewInputProtocol
extension CalendarTaskListViewController: CalendarTaskListViewInputProtocol {
    func updateTaskList(for selectedDate: Date) {
        taskList.updateTaskList(for: selectedDate)
    }
}

// MARK: - CalendarViewDelegate
extension CalendarTaskListViewController: CalendarViewDelegate {
    func calendarDidChange(selectedDate: Date, currentDateTitle: String, selectedDateTitle: String) {
        navigationItem.title = currentDateTitle
        selectedDayLabel.text = selectedDateTitle
        
        presenter.selectedDateChanged(to: selectedDate)
    }
}

// MARK: - TaskListDelegate
extension CalendarTaskListViewController: TaskListDelegate {
    func didTapCell(with task: TLTask) {
        presenter.taskListCellSelected(with: task)
    }
}
