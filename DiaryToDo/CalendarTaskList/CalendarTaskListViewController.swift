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
}

protocol CalendarTaskListViewInputProtocol: AnyObject {
    func reloadCalendar(for section: CalendarSectionViewModel, with navItemTitle: String)
}

class CalendarTaskListViewController: UIViewController {
    var presenter: CalendarTaskListViewOutputProtocol!
    private let configurator: CalendarTaskListConfiguratorInputProtocol = CalendarTaskListConfigurator()
    
    private var sectionViewModel: CalendarSectionViewModelProtocol = CalendarSectionViewModel()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    private lazy var leftButton: UIButton = {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
//        button.setImage(UIImage(systemName: "arrowshape.turn.up.left.circle.fill"), for: .normal)
        button.setTitle("Prev", for: .normal)
        button.backgroundColor = .blue
        
        button.addTarget(self, action: #selector(showPreviousMonth), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var rightButton: UIButton = {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
//        button.setImage(UIImage(systemName: "arrowshape.turn.up.right.circle.fill"), for: .normal)
        button.setTitle("Next", for: .normal)
        button.backgroundColor = .blue
        
        button.addTarget(self, action: #selector(showNextMonth), for: .touchUpInside)

        return button
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(with: self)
        presenter.viewDidLoad()
        
        view.addSubview(collectionView)
        view.addSubview(leftButton)
        view.addSubview(rightButton)
        
        NSLayoutConstraint.activate([
            leftButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            leftButton.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor),
            leftButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.08),
            
            rightButton.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor),
            rightButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            rightButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.08),

            collectionView.leadingAnchor.constraint(equalTo: leftButton.trailingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: rightButton.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3)
        ])
        
        collectionView.register(
            CalendarCell.self,
            forCellWithReuseIdentifier: CalendarCellViewModel.reuseIdentifier
        )
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    @objc func showPreviousMonth(_ sender: Any) {
        presenter.leftButtonPressed()
    }

    @objc func showNextMonth(_ sender: Any) {
        presenter.rightButtonPressed()
    }
    
    override open var shouldAutorotate: Bool {
        return false
    }
}

// MARK: - UICollectionViewDataSource
extension CalendarTaskListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        sectionViewModel.cells.count
//        totalSquares.count + weekdays.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellViewModel = sectionViewModel.cells[indexPath.item]
        // swiftlint:disable force_cast
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarCellViewModel.reuseIdentifier,
                                                      for: indexPath) as! CalendarCell
        // swiftlint:enable force_cast
        cell.viewModel = cellViewModel
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CalendarTaskListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        
        let width = Int(collectionView.frame.width) / 7
        let height = Int(collectionView.frame.height) / 7
        
        return CGSize(width: width, height: height)
    }
}

// MARK: - CalendarTaskListViewInputProtocol
extension CalendarTaskListViewController: CalendarTaskListViewInputProtocol {
    func reloadCalendar(for section: CalendarSectionViewModel, with navItemTitle: String) {
        navigationItem.title = navItemTitle
        sectionViewModel = section
        
        collectionView.reloadData()
    }
}
