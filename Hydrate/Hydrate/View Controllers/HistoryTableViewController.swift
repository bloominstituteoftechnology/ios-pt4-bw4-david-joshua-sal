//
//  HistoryTableViewController.swift
//  Hydrate
//
//  Created by Joshua Rutkowski on 6/17/20.
//  Copyright © 2020 Hydrate. All rights reserved.
//

import UIKit

class HistoryTableViewController: UITableViewController {

    // MARK: - Properties
    
    let dailyLogController = DailyLogController()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
//        let dailyLogCell = UITableViewCell(style: .value2, reuseIdentifier: "dailyLogCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "dailyLogCell")
        
        updateViews()
    }
    
    // MARK: - Internal
    
    fileprivate var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter
    }()
    
    fileprivate func updateViews() {
        guard isViewLoaded else { return }
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dailyLogController.dailyLogs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dailyLogCell", for: indexPath)
        let dailyLog = dailyLogController.dailyLogs[indexPath.row]
        
        cell.textLabel?.text = dateFormatter.string(from: dailyLog.date)
            + "      Total intake: \(dailyLog.totalIntakeAmount) oz." // FIXME: Remove line after figuring out how to get the detailTextLabel to show up
        cell.detailTextLabel?.text = "\(dailyLog.totalIntakeAmount) oz."
        
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
