//
//  ViewController.swift
//  DiaryToDo
//
//  Created by Pavlentiy on 01.02.2022.
//

import UIKit

protocol CalendarTaskListViewOutputProtocol {
    init(view: CalendarTaskListViewInputProtocol)
    
    func viewDidLoad()
    func leftButtonPressed()
    func rightButtonPressed()
    func collectionViewCellDidSelect(at indexPath: IndexPath)
}

protocol CalendarTaskListViewInputProtocol: AnyObject {
    func reloadCalendar(for section: CalendarSectionViewModel, with navItemTitle: String)
    func reloadTaskList(for sections: [TaskListSectionViewModel])
}

class CalendarTaskListViewController: UIViewController {
    var presenter: CalendarTaskListViewOutputProtocol!
    private let configurator: CalendarTaskListConfiguratorInputProtocol = CalendarTaskListConfigurator()
    
    private var calendarSectionViewModel: CalendarSectionViewModelProtocol = CalendarSectionViewModel()
    private var taskListSectionViewModels: [TaskListSectionViewModelProtocol] = []
    
    private lazy var collectionView: UICollectionView = {
        return setupCollectionView()
    }()
    
    private lazy var tableView: UITableView = {
        return setupTableView()
    }()
    
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
        
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(with: self)
        presenter.viewDidLoad()
        
        addSubviews(collectionView, leftButton, rightButton, tableView)
        setupConstraints()
    }
    
    @objc private func showPreviousMonth(_ sender: Any) {
        presenter.leftButtonPressed()
    }

    @objc private func showNextMonth(_ sender: Any) {
        presenter.rightButtonPressed()
    }
    
    private func setupConstraints() {
        let constraints = [
            leftButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            leftButton.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor),
            leftButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.08),
            
            rightButton.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor),
            rightButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            rightButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.08),

            collectionView.leadingAnchor.constraint(equalTo: leftButton.trailingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: rightButton.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),
            
            tableView.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func addSubviews(_ views: UIView...) {
        views.forEach { subview in
            view.addSubview(subview)
        }
    }
    
    private func setupCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.register(
            CalendarCell.self,
            forCellWithReuseIdentifier: CalendarCellViewModel.reuseIdentifier
        )
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        return collectionView
    }
    
    private func setupTableView() -> UITableView {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.register(
            TaskListCell.self,
            forCellReuseIdentifier: TaskListCellViewModel.reuseIdentifier
        )
        
        tableView.delegate = self
        tableView.dataSource = self
        
        return tableView
    }
}

// MARK: - CalendarTaskListViewInputProtocol
extension CalendarTaskListViewController: CalendarTaskListViewInputProtocol {
    func reloadCalendar(for calendarSection: CalendarSectionViewModel, with navItemTitle: String) {
        navigationItem.title = navItemTitle
        calendarSectionViewModel = calendarSection
        
        collectionView.reloadData()
    }
    
    func reloadTaskList(for sections: [TaskListSectionViewModel]) {
        taskListSectionViewModels = sections
        
        tableView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource
extension CalendarTaskListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        calendarSectionViewModel.cells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellViewModel = calendarSectionViewModel.cells[indexPath.item]
        // swiftlint:disable force_cast
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarCellViewModel.reuseIdentifier,
                                                      for: indexPath) as! CalendarCell
        // swiftlint:enable force_cast
        cell.viewModel = cellViewModel
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension CalendarTaskListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.collectionViewCellDidSelect(at: indexPath)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CalendarTaskListViewController: UICollectionViewDelegateFlowLayout {
    // swiftlint:disable:next line_length
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = Int(collectionView.frame.width) / 7
        let height = Int(collectionView.frame.height) / 7

        return CGSize(width: width, height: height)
    }
}

// MARK: - UITableViewDataSource
extension CalendarTaskListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        taskListSectionViewModels[section].tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let taskListCellViewModel = taskListSectionViewModels[indexPath.section].tasks[indexPath.row]
        // swiftlint:disable force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskListCellViewModel.reuseIdentifier,
                                                 for: indexPath) as! TaskListCell
        // swiftlint:enable force_cast
        
        cell.viewModel = taskListCellViewModel
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        taskListSectionViewModels.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        taskListSectionViewModels[section].sectionName
    }
}

extension CalendarTaskListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}
