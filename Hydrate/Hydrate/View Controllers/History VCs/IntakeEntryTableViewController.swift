//
//  IntakeEntryTableViewController.swift
//  Hydrate
//
//  Created by David Wright on 6/24/20.
//  Copyright © 2020 Hydrate. All rights reserved.
//

import UIKit

class IntakeEntryTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    var dailyLog: DailyLog!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        configureTableView()
        updateViews()
    }
    
    // MARK: - Private Properties
    
    fileprivate static var intakeEntryCell: UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "intakeEntryCell")
        cell.backgroundColor = .ravenClawBlue90
        cell.tintColor = .sicklySmurfBlue
        cell.textLabel?.textColor = .undeadWhite
        cell.detailTextLabel?.textColor = .undeadWhite
        cell.selectionStyle = .none
        return cell
    }
    
    fileprivate var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter
    }()
    
    fileprivate var timeFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        return dateFormatter
    }()
    
    // MARK: - Private Methods
    
    fileprivate func configureTableView() {
        title = dateFormatter.string(from: dailyLog.date)
        tableView = UITableView(frame: self.tableView.frame, style: .insetGrouped)
        tableView.backgroundColor = .ravenClawBlue
        tableView.separatorColor = .ravenClawBlue
    }
    
    fileprivate func updateViews() {
        guard isViewLoaded else { return }
        tableView.reloadData()
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dailyLog.entries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "intakeEntryCell")
        if cell == nil {
            cell = IntakeEntryTableViewController.intakeEntryCell
        }
        
        let intakeEntry = dailyLog.entries[indexPath.row]
        if let timestamp = intakeEntry.timestamp {
            cell.textLabel?.text = timeFormatter.string(from: timestamp)
        } else {
            cell.textLabel?.text = "--"
        }
        cell.detailTextLabel?.text = "\(intakeEntry.intakeAmount) oz."
        
        return cell
    }
    
    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */
}
