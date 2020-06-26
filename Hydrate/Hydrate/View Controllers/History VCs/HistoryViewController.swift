//
//  HistoryViewController.swift
//  Hydrate
//
//  Created by David Wright on 6/24/20.
//  Copyright © 2020 Hydrate. All rights reserved.
//

import UIKit
import SwiftUI

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
        chartView.backgroundColor = .ravenClawBlue
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
        let childView = UIHostingController(rootView: ChartsView())
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
        setupChart()
    }
    
    fileprivate func setupChart() {
        // TODO: Setup chart
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
}
