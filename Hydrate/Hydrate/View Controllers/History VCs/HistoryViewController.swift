//
//  HistoryViewController.swift
//  Hydrate
//
//  Created by David Wright on 6/24/20.
//  Copyright © 2020 Hydrate. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {
    
    // MARK: - UI Components
    
    fileprivate let navigationBar: UINavigationBar = {
        let navigationItem = UINavigationItem(title: "Water Intake History")
        let navigationBar = UINavigationBar()
        navigationBar.setItems([navigationItem], animated: false)
        navigationBar.barTintColor = .ravenClawBlue
        navigationBar.titleTextAttributes = [.foregroundColor: UIColor.undeadWhite]
        navigationBar.isTranslucent = false
        return navigationBar
    }()
    
    fileprivate let chartView: UIView = {
        let chartView = UIView()
        chartView.backgroundColor = .systemGray
        return chartView
    }()
    
    fileprivate let containerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .lightGray
        return containerView
    }()
    
    fileprivate let tableViewNavigationController: UINavigationController = {
        let dailyLogTableVC = DailyLogTableViewController()
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
    }
    
    // MARK: - Private Methods
    
    
}
