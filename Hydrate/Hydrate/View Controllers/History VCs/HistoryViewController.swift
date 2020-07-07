//
//  HistoryViewController.swift
//  Hydrate
//
//  Created by David Wright on 6/24/20.
//  Copyright © 2020 Hydrate. All rights reserved.
//

import UIKit
import SwiftUI

protocol HistoryViewControllerDelegate: class {
    func updateWaterLevel()
    func didAddIntakeEntry()
}

class HistoryViewController: UIViewController {
    
    weak var delegate: HistoryViewControllerDelegate!
    
    let dailyLogController = DailyLogController()
    
    // MARK: - UI Components
    
    fileprivate let navigationBar: UINavigationBar = {
        let navigationItem = UINavigationItem(title: "Water Intake History")
        let navigationBar = UINavigationBar()
        navigationBar.setItems([navigationItem], animated: false)
        navigationBar.barTintColor = .ravenClawBlue
        navigationBar.titleTextAttributes = [.foregroundColor: UIColor.undeadWhite]
        navigationBar.isTranslucent = false
        navigationBar.tintColor = .sicklySmurfBlue
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        return navigationBar
    }()
    
    fileprivate let chartView: UIView = {
        let chartView = UIView()
        chartView.backgroundColor = .ravenClawBlue
        return chartView
    }()
    
    fileprivate let containerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .lightGray
        return containerView
    }()
    
    fileprivate lazy var tableViewNavigationController: UINavigationController = {
        let dailyLogTableVC = DailyLogTableViewController()
        dailyLogTableVC.delegate = self
        dailyLogTableVC.dailyLogController = dailyLogController
        let navController = UINavigationController(rootViewController: dailyLogTableVC)
        navController.navigationBar.barTintColor = .ravenClawBlue
        navController.navigationBar.tintColor = .sicklySmurfBlue
        navController.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.undeadWhite]
        navController.navigationBar.isTranslucent = false
        return navController
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    // MARK: - Private Methods
    
    fileprivate func setupViews() {
        view.backgroundColor = .ravenClawBlue
        setupNavigationBar()
        setupChartView()
        setupContainerView()
    }
    
    fileprivate func setupNavigationBar() {
        view.addSubview(navigationBar)
        navigationBar.anchor(top: view.topAnchor,
                                   leading: view.leadingAnchor,
                                   bottom: nil,
                                   trailing: view.trailingAnchor)
    }
    
    fileprivate func setupChartView() {
        view.addSubview(chartView)
        
        var chartsView = ChartsView()
        let startOfLastSevenDays = Calendar.current.date(byAdding: .day, value: -6, to: Date().startOfDay)!
        let dailyLogsToChart = dailyLogController.dailyLogs.filter { $0.date >= startOfLastSevenDays }
        chartsView.dailyLogs = dailyLogsToChart
        chartsView.updateDailyLogs()
        
        let childView = UIHostingController(rootView: chartsView)
        childView.view.translatesAutoresizingMaskIntoConstraints = false
        addChild(childView)
        childView.view.frame = chartView.bounds
        
        chartView.addSubview(childView.view)
        childView.view.centerXAnchor.constraint(equalTo: chartView.centerXAnchor).isActive = true
        childView.didMove(toParent: self)
        chartView.anchor(top: navigationBar.bottomAnchor,
                         leading: view.leadingAnchor,
                         bottom: nil,
                         trailing: view.trailingAnchor,
                         size: CGSize(width: view.bounds.width, height: 220))
    }
    
    fileprivate func setupContainerView() {
        view.addSubview(containerView)
        containerView.anchor(top: chartView.bottomAnchor,
                             leading: view.leadingAnchor,
                             bottom: view.bottomAnchor,
                             trailing: view.trailingAnchor)
        setupTableViewNavigationController()
    }
    
    fileprivate func setupTableViewNavigationController() {
        addChild(tableViewNavigationController)
        containerView.addSubview(tableViewNavigationController.view)
        tableViewNavigationController.didMove(toParent: self)
        tableViewNavigationController.view.anchor(top: containerView.topAnchor,
                                                  leading: containerView.leadingAnchor,
                                                  bottom: containerView.bottomAnchor,
                                                  trailing: containerView.trailingAnchor)
    }
    
    @objc fileprivate func doneButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    fileprivate func updateChartData() {
        guard let hostingController = children.first as? UIHostingController<ChartsView> else { return }
        hostingController.rootView.dailyLogController = dailyLogController
        let startOfLastSevenDays = Calendar.current.date(byAdding: .day, value: -6, to: Date().startOfDay)!
        let dailyLogsToChart = dailyLogController.dailyLogs.filter { $0.date >= startOfLastSevenDays }
        hostingController.rootView.dailyLogs = dailyLogsToChart
        hostingController.rootView.updateDailyLogs()
    }
}

extension HistoryViewController: DailyLogTableViewControllerDelegate {
    
    func didUpdateDailyLog(forDate date: Date) {
        let startOfLastSevenDays = Calendar.current.date(byAdding: .day, value: -6, to: Date().startOfDay)!
        if date > startOfLastSevenDays {
            updateChartData()
        }
        
        if date.isInCurrentDay {
            delegate.updateWaterLevel()
        }
    }
    
    func didDeleteDailyLog(forDate date: Date) {
        let startOfLastSevenDays = Calendar.current.date(byAdding: .day, value: -6, to: Date().startOfDay)!
        if date > startOfLastSevenDays {
            updateChartData()
        }
        
        if date.isInCurrentDay {
            delegate.updateWaterLevel()
        }
    }
    
    func addDataButtonTapped() {
        let addEntryPopup = AddEntryPopup()
        addEntryPopup.delegate = self
        self.view.addSubview(addEntryPopup)
    }
    
    func addDataButtonTapped(for date: Date) {
        let addEntryPopup = AddEntryPopup(for: date)
        addEntryPopup.delegate = self
        self.view.addSubview(addEntryPopup)
    }
}

extension HistoryViewController: AddEntryPopupDelegate {
    
    func didAddIntakeEntry(withDate date: Date, intakeAmount: Int) {
        dailyLogController.addIntakeEntry(withDate: date, intakeAmount: intakeAmount)
        
        if date.isInCurrentDay {
            delegate.didAddIntakeEntry()
        }
        
        guard let navController = children.last as? UINavigationController else { return }
        
        if let dailyLogTableVC = navController.topViewController as? DailyLogTableViewController {
            dailyLogTableVC.updateViews()
        } else if let intakeEntryTableVC = navController.topViewController as? IntakeEntryTableViewController {
            intakeEntryTableVC.updateViews()
        }
        
        let startOfLastSevenDays = Calendar.current.date(byAdding: .day, value: -6, to: Date().startOfDay)!
        if date > startOfLastSevenDays {
            updateChartData()
        }
    }
    
    func didEndEditing() {
        view.endEditing(true)
    }
}
