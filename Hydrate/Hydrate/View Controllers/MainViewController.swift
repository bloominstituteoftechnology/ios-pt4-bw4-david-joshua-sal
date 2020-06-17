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
        return button
    }()
    
    let showSettingsButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "settings-button"), for: .normal)
        button.tintColor = UIColor(named: "MausoleumWhite")
        button.contentHorizontalAlignment = .right
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsets(top: 20.0, left: 0.0, bottom: 0.0, right: 20.0);
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    //MARK: - Private
    
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


}

