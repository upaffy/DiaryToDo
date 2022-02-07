//
//  ViewController.swift
//  DiaryToDo
//
//  Created by Pavlentiy on 01.02.2022.
//

import UIKit

protocol CalendarTaskListViewOutputProtocol {
    init(view: CalendarTaskListViewInputProtocol)
}

protocol CalendarTaskListViewInputProtocol: AnyObject {

}

class CalendarTaskListViewController: UIViewController, CalendarTaskListViewInputProtocol {
    var presenter: CalendarTaskListViewOutputProtocol!
    
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
        
        button.addTarget(self, action: #selector(previousMonth), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var rightButton: UIButton = {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
//        button.setImage(UIImage(systemName: "arrowshape.turn.up.right.circle.fill"), for: .normal)
        button.setTitle("Next", for: .normal)
        button.backgroundColor = .blue
        
        button.addTarget(self, action: #selector(nextMonth), for: .touchUpInside)

        return button
    }()
    
    var selectedDate = Date()
    var totalSquares = [CalendarDay]()
    
    let weekdays = [
        CalendarDay(day: "Sun", type: .weekday),
        CalendarDay(day: "Mon", type: .weekday),
        CalendarDay(day: "Tue", type: .weekday),
        CalendarDay(day: "Wed", type: .weekday),
        CalendarDay(day: "Thu", type: .weekday),
        CalendarDay(day: "Fri", type: .weekday),
        CalendarDay(day: "Sat", type: .weekday)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setMonthView()
        
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
            forCellWithReuseIdentifier: CalendarCell.reuseIdentifier
        )
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func setMonthView() {
        totalSquares = weekdays
        
        let daysInMonth = CalendarHelper().daysInMonth(date: selectedDate)
        let firstDayOfMonth = CalendarHelper().firstOfMonth(date: selectedDate)
        let startingSpaces = CalendarHelper().weekDay(date: firstDayOfMonth)
        
        let prevMonth = CalendarHelper().minusMonth(date: selectedDate)
        let daysInPrevMonth = CalendarHelper().daysInMonth(date: prevMonth)
        
        let elementsCountInCollectionView = 49
        
        var count: Int = 1
        
        while count <= elementsCountInCollectionView {
            let calendarDay: CalendarDay
            if count <= startingSpaces {
                let prevMonthDay = daysInPrevMonth - startingSpaces + count
                calendarDay = CalendarDay(day: "\(prevMonthDay)", type: .previous)
            } else if count - startingSpaces > daysInMonth {
                calendarDay = CalendarDay(day: "\(count - daysInMonth - startingSpaces)", type: .next)
            } else {
                calendarDay = CalendarDay(day: "\(count - startingSpaces)", type: .current)
            }
            
            totalSquares.append(calendarDay)
            count += 1
        }
        
        navigationItem.title = CalendarHelper().monthString(date: selectedDate)
        + " " + CalendarHelper().yearString(date: selectedDate)
        
        collectionView.reloadData()
    }
    
    @objc func previousMonth(_ sender: Any) {
        selectedDate = CalendarHelper().minusMonth(date: selectedDate)
        setMonthView()
    }

    @IBAction func nextMonth(_ sender: Any) {
        selectedDate = CalendarHelper().plusMonth(date: selectedDate)
        setMonthView()
    }
    
    override open var shouldAutorotate: Bool {
        return false
    }
}

// MARK: - UICollectionViewDataSource
extension CalendarTaskListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        totalSquares.count + weekdays.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CalendarCell.reuseIdentifier,
            for: indexPath
            
            // swiftlint:disable:next force_cast
        ) as! CalendarCell
        
        let calendarDay = totalSquares[indexPath.item]
        cell.dayOfMonth.text = calendarDay.day
        
        if calendarDay.type == .current {
            cell.dayOfMonth.textColor = .black
        } else if calendarDay.type == .weekday {
            cell.dayOfMonth.textColor = .red
        } else {
            cell.dayOfMonth.textColor = .gray
        }
        
        return cell
    }
}

extension CalendarTaskListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        
        let width = Int(collectionView.frame.width / 7)
        let height = Int(collectionView.frame.height) / 7
        
        return CGSize(width: width, height: height)
    }
}
