//
//  MainViewController.swift
//  Hydrate
//
//  Created by Joshua Rutkowski on 6/16/20.
//  Copyright © 2020 Hydrate. All rights reserved.
//

import UIKit
import SwiftUI

class MainViewController: UIViewController {
    
    // MARK: - Properties
    
    var wave: WaveAnimationView!
    
    // sets the current waterLevel for the wave animation. Values are 0.0...1.0.
    var waterLevel: Float {
        let percentOfTargetReached = Float(intakeEntryController.totalIntakeAmount) / Float(targetDailyIntake)
        return min(percentOfTargetReached, 1.0)
    }
    
    var intakeEntryController = IntakeEntryController()
    
    var targetDailyIntake: Int = 100
    
    var recentlyAddedIntakeEntry: IntakeEntry? {
        didSet {
            guard recentlyAddedIntakeEntry != nil else { return }
            wave.setProgress(waterLevel)
            showUndoButton()
        }
    }
    
    var undoButtonCenterXAnchor: NSLayoutConstraint!
    
    //MARK: - UI Components
    
    let addWaterIntakeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "water-button"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let undoWaterIntakeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = #colorLiteral(red: 0.8172292593, green: 0.8253206381, blue: 0.8253206381, alpha: 1)
        let config = UIImage.SymbolConfiguration(pointSize: 60)
        let image = UIImage(systemName: "arrowshape.turn.up.left.circle.fill", withConfiguration: config)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(handleUndoButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let showHistoryButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "calendar-button"), for: .normal)
        button.tintColor = UIColor.undeadWhite
        button.contentHorizontalAlignment = .left
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 0.0, right: 0.0);
        button.addTarget(self, action: #selector(handleShowHistoryTapped), for: .touchUpInside)
        return button
    }()
    
    let showSettingsButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "settings-button"), for: .normal)
        button.tintColor = UIColor.undeadWhite
        button.contentHorizontalAlignment = .right
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsets(top: 20.0, left: 0.0, bottom: 0.0, right: 20.0);
        button.addTarget(self, action: #selector(handleShowSettingsTapped), for: .touchUpInside)
        return button
    }()
    
    let topControlsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var measurementMarkerStackView: UIStackView = {
        let intervalSize = 8 // number of water units (i.e. ounces) between measurement markers
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 0
        stackView.backgroundColor = .white
        
        let finalIntervalOffset = targetDailyIntake % intervalSize
        let finalInterval = (finalIntervalOffset == 0) ? intervalSize : finalIntervalOffset
        let ratioIntervalToFinalInterval = CGFloat(intervalSize) / CGFloat(finalIntervalOffset)
        
        // helper function used only during initialization of 'numberStackView'
        @discardableResult func createNewMarker(withDisplayNumber displayNumber: Int) -> UIView {
            guard displayNumber >= 0 else { return UIView() }
            let markerView = UIView()
            let label = UILabel()
            markerView.addSubview(label)
            stackView.addArrangedSubview(markerView)
            
            label.textAlignment = .right
            label.font = UIFont.boldSystemFont(ofSize: 20)
            label.textColor = #colorLiteral(red: 0.8469634652, green: 0.8471123576, blue: 0.8469651341, alpha: 0.3020387414)
            label.text = (displayNumber == 0) ? " " : "\(displayNumber) oz."
            
            markerView.translatesAutoresizingMaskIntoConstraints = false
            label.translatesAutoresizingMaskIntoConstraints = false
            label.leadingAnchor.constraint(equalTo: markerView.leadingAnchor).isActive = true
            label.bottomAnchor.constraint(equalTo: markerView.bottomAnchor).isActive = true
            
            //label.backgroundColor = .blue
            //markerView.backgroundColor = .yellow
            
            return markerView
        }
        
        // create top two measurement markers
        createNewMarker(withDisplayNumber: targetDailyIntake)
        let finalIntervalView = createNewMarker(withDisplayNumber: targetDailyIntake - finalInterval)
        
        // create all remaining measurement markers
        let nextMarkerLabelNumber = targetDailyIntake - intervalSize - finalInterval
        for number in stride(from: nextMarkerLabelNumber, through: 0, by: -intervalSize) {
            let intervalView = createNewMarker(withDisplayNumber: number)
            intervalView.heightAnchor.constraint(equalTo: finalIntervalView.heightAnchor, multiplier: ratioIntervalToFinalInterval).isActive = true
        }
        
        return stackView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        intakeEntryController.fetchIntakeEntries()
        
        wave = WaveAnimationView(frame: CGRect(origin: .zero, size: view.bounds.size),
                                 color: UIColor.sicklySmurfBlue.withAlphaComponent(0.5))
        view.addSubview(wave)
        wave.startAnimation()
        wave.setProgress(waterLevel)
        print("The total water intake so far today is: \(intakeEntryController.totalIntakeAmount) ounces.")
        
        setupTapGestures()
        setupViews()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        wave.stopAnimation()
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
        view.backgroundColor = UIColor.ravenClawBlue
        
        // Add subviews
        view.addSubview(measurementMarkerStackView)
        view.addSubview(topControlsStackView)
        view.addSubview(undoWaterIntakeButton)
        view.addSubview(addWaterIntakeButton)

        // Setup subviews
        setupMeasurementMarkers()
        setupTopControls()
        
        // Setup bottom buttons
        NSLayoutConstraint.activate([
            addWaterIntakeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addWaterIntakeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            addWaterIntakeButton.widthAnchor.constraint(equalToConstant: 98),
            addWaterIntakeButton.heightAnchor.constraint(equalToConstant: 98),
        ])
        
        undoWaterIntakeButton.centerYAnchor.constraint(equalTo: addWaterIntakeButton.centerYAnchor).isActive = true
        undoButtonCenterXAnchor = undoWaterIntakeButton.centerXAnchor.constraint(equalTo: addWaterIntakeButton.centerXAnchor)
        undoButtonCenterXAnchor.isActive = true
    }
    
    /// Sets up top stackView
    fileprivate func setupTopControls() {
        //sets a spacer between the left and right buttons, equally dividing the view by 3
        let spacerView = UIView()
        spacerView.backgroundColor = .clear
        
        topControlsStackView.addArrangedSubview(showSettingsButton)
        topControlsStackView.addArrangedSubview(spacerView)
        topControlsStackView.addArrangedSubview(showHistoryButton)
        
        NSLayoutConstraint.activate([
            topControlsStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topControlsStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            topControlsStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            topControlsStackView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    fileprivate func setupMeasurementMarkers() {
        measurementMarkerStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                                          leading: view.safeAreaLayoutGuide.leadingAnchor,
                                          bottom: view.bottomAnchor,
                                          trailing: view.safeAreaLayoutGuide.trailingAnchor,
                                          padding: .init(top: 76, left: 16, bottom: 0, right: 16))
        view.layoutIfNeeded()
    }
    
    // MARK: - UIButton Methods
    
    // Page Navigation
    
    @objc fileprivate func handleShowHistoryTapped() {
        let hvc = HistoryViewController()
        present(hvc, animated: true, completion: nil)
    }
    
    @objc fileprivate func handleShowSettingsTapped() {
        let hostingController = UIHostingController(rootView: SettingsView())
        self.present(hostingController, animated: true, completion: nil)
    }
    
    // Undo Button Tapped
    
    @objc fileprivate func handleUndoButtonTapped() {
        guard let lastIntakeEntry = recentlyAddedIntakeEntry else { return }
        let removeAmount = lastIntakeEntry.intakeAmount
        intakeEntryController.delete(lastIntakeEntry)
        print("Removed \(removeAmount) ounces of water. Total intake: \(intakeEntryController.totalIntakeAmount) ounces.")
        wave.setProgress(waterLevel)
        hideUndoButton()
    }
    
    // Add Water Button (Short Tap)
    
    @objc func handleNormalPress(){
        recentlyAddedIntakeEntry = intakeEntryController.addIntakeEntry(withIntakeAmount: 8)
        print("Added \(recentlyAddedIntakeEntry?.intakeAmount ?? 0) ounces of water. Total intake: \(intakeEntryController.totalIntakeAmount) ounces.")
    }
    
    // Gesture Handlers
    
    /// Sets up the begin state of view animations when using UILongPressGestureRecognizer
    /// - Parameter sender: UILongPressGestureRecognizer
    fileprivate func handleGestureBegan(sender: UILongPressGestureRecognizer) {
        addWaterIntakeButton.isHighlighted = true
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()

    }

    /// Sets up the changed state of view animations when using UILongPressGestureRecognizer
    /// - Parameter sender: UILongPressGestureRecognizer
    fileprivate func handleGestureChanged(sender: UILongPressGestureRecognizer) {

    }
    
    /// Sets up the changed state of view animations when using UILongPressGestureRecognizer
    /// - Parameter sender: UILongPressGestureRecognizer
    fileprivate func handleGestureEnded(sender: UILongPressGestureRecognizer) {
        let pop = Popup()
        self.view.addSubview(pop)
    }
    
    // Add Water (Long Tap)
    
    @objc func handleLongPress(sender : UILongPressGestureRecognizer){
        if sender.state == .ended {
            print("\(sender.state): ended")
            handleGestureEnded(sender: sender)
        } else if sender.state == .began {
            print("\(sender.state): began")
            handleGestureBegan(sender: sender)
        } else if sender.state == .changed {
            // Gets called if gesture state changes (i.e. moving finger/mouse)
            print("\(sender.state): is changing")
            handleGestureChanged(sender: sender)
        }
    }
    
    // MARK: - Undo Button Animations
    
    fileprivate func showUndoButton() {
        undoWaterIntakeButton.layer.removeAllAnimations()
        undoWaterIntakeButton.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        undoButtonCenterXAnchor.constant = 112
        
        // move right and scale up animation
        UIView.animate(withDuration: 0.15, delay: 0.05, options: [.curveEaseOut], animations: {
            self.undoWaterIntakeButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        // pulse animation
        UIView.animate(withDuration: 0.45, delay: 0.1, options: [.repeat, .curveEaseIn, .autoreverse, .allowUserInteraction], animations: {
            self.undoWaterIntakeButton.transform = CGAffineTransform(scaleX: 1.12, y: 1.12)
        }, completion: nil)
        
        perform(#selector(hideUndoButton), with: nil, afterDelay: 3.65)
    }
    
    @objc fileprivate func hideUndoButton() {
        undoButtonCenterXAnchor.constant = 0
        
        // move left and scale down animation
        UIView.animate(withDuration: 0.15, delay: 0, options: [.curveEaseIn], animations: {
            self.undoWaterIntakeButton.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.undoWaterIntakeButton.layer.removeAllAnimations()
        })
    }
}

