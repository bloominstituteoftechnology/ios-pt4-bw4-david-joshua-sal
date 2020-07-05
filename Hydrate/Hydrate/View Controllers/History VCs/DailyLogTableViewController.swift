//
//  DailyLogTableViewController.swift
//  Hydrate
//
//  Created by David Wright on 6/24/20.
//  Copyright © 2020 Hydrate. All rights reserved.
//

import UIKit

protocol DailyLogTableViewControllerDelegate: class {
    func didUpdateDailyLog(forDate date: Date)
    func didDeleteDailyLog(forDate date: Date)
    func addDataButtonTapped()
}

class DailyLogTableViewController: UITableViewController {

    // MARK: - Properties
    
    var dailyLogController: DailyLogController!
    
    weak var delegate: DailyLogTableViewControllerDelegate!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem
                
        configureTableView()
        updateViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateViews()
    }
    
    // MARK: - Private Properties
    
    fileprivate static var dailyLogCell: UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "intakeEntryCell")
        cell.backgroundColor = .ravenClawBlue90
        cell.tintColor = .sicklySmurfBlue
        cell.textLabel?.textColor = .undeadWhite
        cell.detailTextLabel?.textColor = .undeadWhite
        cell.addDisclosureIndicator()
        cell.selectionStyle = .none
        return cell
    }
    
    fileprivate lazy var addDataButton: UIBarButtonItem = {
        UIBarButtonItem(title: "Add Data", style: .plain, target: self, action: #selector(addDataButtonTapped))
    }()
    
    fileprivate var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter
    }()
    
    // MARK: - Private Methods
    
    fileprivate func configureTableView() {
        title = "Daily Logs"
        tableView.backgroundColor = .ravenClawBlue
        tableView.separatorColor = .ravenClawBlue
    }
    
    fileprivate func updateViews() {
        guard isViewLoaded else { return }
        tableView.reloadData()
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dailyLogController.dailyLogs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "dailyLogCell")
        if cell == nil {
            cell = DailyLogTableViewController.dailyLogCell
        }
        
        let dailyLog = dailyLogController.dailyLogs[indexPath.row]
        cell.textLabel?.text = dateFormatter.string(from: dailyLog.date)
        cell.detailTextLabel?.text = "\(dailyLog.totalIntakeAmount) oz."
        
        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let dailyLog = dailyLogController.dailyLogs[indexPath.row]
            dailyLogController.delete(dailyLog)
            delegate.didDeleteDailyLog(forDate: dailyLog.date)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        if editing {
            self.navigationItem.leftBarButtonItem = self.addDataButton
        } else {
            self.navigationItem.leftBarButtonItem = nil
        }
    }
    
    @objc fileprivate func addDataButtonTapped() {
        print("Add Data button tapped")
        delegate.addDataButtonTapped()
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dailyLog = dailyLogController.dailyLogs[indexPath.row]
        let intakeEntryTableVC = IntakeEntryTableViewController()
        intakeEntryTableVC.dailyLog = dailyLog
        intakeEntryTableVC.delegate = self
        navigationController?.pushViewController(intakeEntryTableVC, animated: true)
    }
}

extension UITableViewCell {
    func addDisclosureIndicator(){
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 13, weight: UIImage.SymbolWeight.semibold)
        let image = UIImage(systemName: "chevron.right", withConfiguration: symbolConfiguration)
        button.setImage(image, for: .normal)
        button.tintColor = .sicklySmurfBlue
        self.accessoryView = button
    }
}

extension DailyLogTableViewController: IntakeEntryTableViewControllerDelegate {
    
    func didDeleteIntakeEntry(_ intakeEntry: IntakeEntry) {
        guard let date = intakeEntry.timestamp else { return }
        dailyLogController.delete(intakeEntry)
        delegate.didUpdateDailyLog(forDate: date)
    }
    
    func didDeleteDailyLog(_ dailyLog: DailyLog) {
        dailyLogController.delete(dailyLog)
        delegate.didDeleteDailyLog(forDate: dailyLog.date)
    }
}
