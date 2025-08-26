//
//  TasksCalendarScreen.swift
//  BaseiOSApp
//
//  Created by Waqas Ashraf on 14/08/2025.
//

import UIKit

class TasksCalendarScreen: UIViewController {
    
    static let identifier = "TasksCalendarScreen"
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var monthYearLabel: UILabel!
    @IBOutlet weak var tasksTableView: UITableView!
    @IBOutlet weak var tasksTableHeight: NSLayoutConstraint!
    @IBOutlet weak var calendarCollectionView: UICollectionView!
    private let calendar = Calendar.current
    
    private var viewModel: TasksCalendarViewModel
    
    init?(coder: NSCoder, viewModel: TasksCalendarViewModel) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        setupUiElements()
    }
    
    override func viewWillLayoutSubviews() {
        DispatchQueue.main.async {
            self.tasksTableHeight.constant = self.tasksTableView.contentSize.height
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        appNavigationCoordinator.shouldShowNavController(show: false, animted: false)
    }
    
    private func setupUiElements() {
        
        //Register cell
        registerCells()
        
        // Scroll to today
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            if let todayIndex = self.viewModel.dates.value?.1.firstIndex(where: { self.calendar.isDate($0, inSameDayAs: Date()) }) {
                let indexPath = IndexPath(item: todayIndex, section: 0)
                self.calendarCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
            }
        }
        
        headerView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
    }
    
    private func registerCells() {
    
        let cellNib = UINib(nibName: CustomCalendarDayCell.reuseIdentifier, bundle: .main)
        calendarCollectionView.register(cellNib, forCellWithReuseIdentifier: CustomCalendarDayCell.reuseIdentifier)
        
        //Register cell
        let cellNib2 = UINib(nibName: TaskInfoCell.identifier, bundle: .main)
        tasksTableView.register(cellNib2, forCellReuseIdentifier: TaskInfoCell.identifier)
        
    }
    
    private func updateMonthYear(for date: Date, showFull: Bool = false) {
        let formatter = DateFormatter()
        formatter.dateFormat = showFull ? "MMM d, yyyy" : "MMMM, yyyy"
        monthYearLabel.text = formatter.string(from: date)
    }
    
    private func updateMonthLabelFromVisibleDates() {
        let visibleIndexPaths = calendarCollectionView.indexPathsForVisibleItems
        guard let firstIndex = visibleIndexPaths.min() else { return }
        guard let visibleDate = viewModel.dates.value?.1[firstIndex.item] else { return }
        updateMonthYear(for: visibleDate)
    }
    
    private func checkInfiniteScroll() {
        guard let firstVisible = calendarCollectionView.indexPathsForVisibleItems.min(),
              let lastVisible = calendarCollectionView.indexPathsForVisibleItems.max() else { return }
        
        if firstVisible.item < 20 { // close to start
            viewModel.prependDates()
        } else if lastVisible.item > viewModel.dates.value!.1.count - 20 { // close to end
            viewModel.appendDates()
        }
    }
    
    private func navToInviteScreen() {
//        let vc = AppUIViewControllers.friendsListScreen()
//        appNavigationCoordinator.pushUIKit(vc)
    }
    
    @objc
    private func goBack() {
        appNavigationCoordinator.pop()
    }
    
    //MARK: ButtonActions
    @IBAction func backBtn(_ sender: Any) {
        goBack()
    }
    
    
}

extension TasksCalendarScreen: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskInfoCell.identifier, for: indexPath) as! TaskInfoCell
        cell.closure = { [weak self] in
            DispatchQueue.main.async {
                self?.navToInviteScreen()
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewWillLayoutSubviews()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        10
    }
    
}

extension TasksCalendarScreen: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.dates.value?.1.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 40, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCalendarDayCell.reuseIdentifier, for: indexPath) as? CustomCalendarDayCell else {
            return UICollectionViewCell()
        }
        
        let date = viewModel.dates.value?.1[indexPath.item]
        if let date {
            let isSelected = calendar.isDate(date, inSameDayAs: viewModel.selectedDate!)
            cell.configure(with: date, calendar: calendar, isSelected: isSelected)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.selectedDate = viewModel.dates.value?.1[indexPath.item]
        updateMonthYear(for: viewModel.selectedDate!, showFull: true)
        calendarCollectionView.reloadData()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateMonthLabelFromVisibleDates()
        checkInfiniteScroll()
    }
    
}

extension TasksCalendarScreen {
    
    private func bindViewModel() {
        
        viewModel.dates.bind { dateObj in
            if dateObj?.0 == true {
                //Appended
                guard let startIndex = dateObj?.1.count else { return }
                if let newDates = dateObj?.2 {
                    DispatchQueue.main.async {
                        var indexPaths: [IndexPath] = []
                        for i in 0..<newDates.count {
                            indexPaths.append(IndexPath(item: startIndex + i, section: 0))
                        }
                        
                        self.calendarCollectionView.performBatchUpdates({
                            self.calendarCollectionView.insertItems(at: indexPaths)
                        })
                    }
                }
                
                
            }
            else {
                //inserted
                DispatchQueue.main.async {
                    if let newDates = dateObj?.2 {
                        let oldOffset = self.calendarCollectionView.contentOffset
                        self.calendarCollectionView.reloadData()
                        self.calendarCollectionView.layoutIfNeeded()
                        self.calendarCollectionView.contentOffset = CGPoint(x: oldOffset.x + CGFloat(newDates.count) * 72, y: oldOffset.y)
                    }
                }
            }
        }
        
    }
    
}
