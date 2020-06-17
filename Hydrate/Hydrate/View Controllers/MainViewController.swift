//
//  MainViewController.swift
//  Hydrate
//
//  Created by Joshua Rutkowski on 6/16/20.
//  Copyright © 2020 Hydrate. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    //MARK: - UI Components
    let addWaterIntakeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "water-button"), for: .normal)
        return button
    }()
    
    let showHistoryButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "calendar-button"), for: .normal)
        button.tintColor = UIColor(named: "MausoleumWhite")
        button.contentHorizontalAlignment = .left
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 0.0, right: 0.0);
        button.addTarget(self, action: #selector(handleShowHistoryTapped), for: .touchUpInside)
        return button
    }()
    
    let showSettingsButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "settings-button"), for: .normal)
        button.tintColor = UIColor(named: "MausoleumWhite")
        button.contentHorizontalAlignment = .right
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsets(top: 20.0, left: 0.0, bottom: 0.0, right: 20.0);
        button.addTarget(self, action: #selector(handleShowSettingsTapped), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTapGestures()
        setupViews()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: - Private
    
    /// Sets up long and short press tap gestures. Change default by using `numberofTapsRequired`.
    /// Change default duration by using `minimumPressDuration`
    fileprivate func setupTapGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleNormalPress))
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        addWaterIntakeButton.addGestureRecognizer(tapGesture)
        addWaterIntakeButton.addGestureRecognizer(longGesture)
        
        // UILongPressGestureRecognizer by default cancels touches in the hierarchy once recognized
        // The touch event on the UIButton is canceled and then becomes unhighlighted
        // set cancelsTouchesInView to false to change default behaviour
        longGesture.cancelsTouchesInView = false
    }
    
    /// Sets up programmatic views for view controller
    fileprivate func setupViews() {
        view.backgroundColor = UIColor(named: "RavenclawBlue")
        view.addSubview(addWaterIntakeButton)
        addWaterIntakeButton.anchor(top: nil,
                                    leading: view.leadingAnchor,
                                    bottom: view.bottomAnchor,
                                    trailing: view.trailingAnchor,
                                    padding: .init(top: 0, left: 0, bottom: 20, right: 0))
        setupTopControls()
    }
    
    /// Sets up top stackView
    fileprivate func setupTopControls() {
        //sets a spacer between the left and right buttons, equally dividing the view by 3
        let spacerView = UIView()
        spacerView.backgroundColor = .clear
        
        let topControlsStackView = UIStackView(arrangedSubviews: [showHistoryButton, spacerView, showSettingsButton])
        
        view.addSubview(topControlsStackView)
        topControlsStackView.translatesAutoresizingMaskIntoConstraints = false
        topControlsStackView.distribution  = .fillEqually
        
        NSLayoutConstraint.activate([
            topControlsStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topControlsStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            topControlsStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            topControlsStackView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    //MARK: -  UIButton Methods
    @objc fileprivate func handleShowHistoryTapped() {
        let hvc = HistoryTableViewController()
        hvc.modalTransitionStyle = .flipHorizontal
        present(hvc, animated: true, completion: nil)
    }
    
    @objc fileprivate func handleShowSettingsTapped() {
        let svc = SettingsTableViewController()
        svc.modalTransitionStyle = .flipHorizontal
        present(svc, animated: true, completion: nil)
    }
    
    @objc func handleNormalPress(){
        print("Normal tap")
    }
    
    @objc func handleLongPress(sender : UILongPressGestureRecognizer){
        if sender.state == .ended {
            print("\(sender.state): ended")
        } else if sender.state == .began {
            print("\(sender.state): began")
        } else if sender.state == .changed {
            // Gets called if gesture state changes (i.e. moving finger/mouse)
            print("\(sender.state): is changing")
        }
    }
}
