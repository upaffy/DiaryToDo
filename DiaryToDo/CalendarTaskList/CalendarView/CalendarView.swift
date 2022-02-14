//
//  CalendarView.swift
//  DiaryToDo
//
//  Created by Pavlentiy on 14.02.2022.
//

import UIKit

protocol CalendarViewDelegate: AnyObject {
    func calendarDidChange(selectedDate: Date, currentDateTitle: String, selectedDateTitle: String)
}

protocol CalendarViewOutputProtocol {
    init(view: CalendarViewInputProtocol)
    
    func viewDidLoad()
    func getNextMonth()
    func getPreviousMonth()
    func collectionViewCellDidSelect(at indexPath: IndexPath)
}

protocol CalendarViewInputProtocol: AnyObject {
    func reloadCalendar(
        for calendarSection: CalendarSectionViewModel,
        selectedDate: Date,
        currentDateTitle: String,
        selectedDateTitle: String
    )
}

class CalendarView: UICollectionView {
    var presenter: CalendarViewOutputProtocol!
    
    var calendarDelegate: CalendarViewDelegate! {
        didSet {
            setupCollectionView()
        }
    }
    
    private var calendarSectionViewModel: CalendarSectionViewModelProtocol = CalendarSectionViewModel()
    
    func showNextMonth() {
        presenter.getNextMonth()
    }
    
    func showPreviousMonth() {
        presenter.getPreviousMonth()
    }
}

// MARK: - Private methods
extension CalendarView {
    private func setupCollectionView() {
        presenter.viewDidLoad()
        isScrollEnabled = false
                
        register(
            CalendarCell.self,
            forCellWithReuseIdentifier: CalendarCellViewModel.reuseIdentifier
        )
        
        dataSource = self
        delegate = self
    }
}

// MARK: - CalendarViewInputProtocol
extension CalendarView: CalendarViewInputProtocol {
    // swiftlint:disable:next line_length
    func reloadCalendar(for calendarSection: CalendarSectionViewModel, selectedDate: Date, currentDateTitle: String, selectedDateTitle: String) {
        
        calendarSectionViewModel = calendarSection
        
        calendarDelegate.calendarDidChange(
            selectedDate: selectedDate,
            currentDateTitle: currentDateTitle,
            selectedDateTitle: selectedDateTitle
        )
        
        reloadData()
    }
}

// MARK: - UICollectionViewDataSource
extension CalendarView: UICollectionViewDataSource {
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
extension CalendarView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.collectionViewCellDidSelect(at: indexPath)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CalendarView: UICollectionViewDelegateFlowLayout {
    // swiftlint:disable:next line_length
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = Int(frame.width) / 7
        let height = Int(frame.height) / 7

        return CGSize(width: width, height: height)
    }
}
