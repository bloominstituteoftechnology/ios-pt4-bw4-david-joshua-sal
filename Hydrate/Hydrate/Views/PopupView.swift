//
//  PopupView.swift
//  Hydrate
//
//  Created by Joshua Rutkowski on 6/17/20.
//  Copyright © 2020 Hydrate. All rights reserved.
//

import UIKit

class Popup: UIView, UIPickerViewDelegate, UIPickerViewDataSource {

    
    fileprivate let inputTextField: CustomTextField = {
       let textField = CustomTextField()
        textField.placeholder = "0.5"
        textField.backgroundColor = UIColor(named: "UndeadWhite")
        textField.textColor = UIColor(named: "RavenclawBlue")
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.cornerRadius = 8
        return textField
    }()
    
    fileprivate let cupLabel: UILabel = {
       let label = UILabel()
        label.text = "cup(s)"
        label.textColor = UIColor(named: "SicklySmurfBlue")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let spacerView : UIView = {
        let spacer = UIView()
        spacer.translatesAutoresizingMaskIntoConstraints = false
        return spacer
    }()
    
    fileprivate let addOneCupButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("+1 cup", for: .normal )
        button.setTitleColor(UIColor(named: "RavenclawBlue"), for: .normal)
        button.backgroundColor = UIColor(named: "UndeadWhite")
        button.layer.cornerRadius = 8
        button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        button.layer.shadowOffset = CGSize(width: 0, height:4)
        button.layer.shadowOpacity = 1.0
        button.layer.shadowRadius = 10.0
        button.layer.masksToBounds = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    fileprivate let addTwoCupsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(UIColor(named: "RavenclawBlue"), for: .normal)
        button.backgroundColor = UIColor(named: "UndeadWhite")
        button.setTitle("+2 cups", for: .normal)
        button.layer.cornerRadius = 8
        button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        button.layer.shadowOffset = CGSize(width: 0, height:4)
        button.layer.shadowOpacity = 1.0
        button.layer.shadowRadius = 10.0
        button.layer.masksToBounds = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    fileprivate let addFourCupsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("+4 cups", for: .normal)
        button.setTitleColor(UIColor(named: "RavenclawBlue"), for: .normal)
        button.backgroundColor = UIColor(named: "UndeadWhite")
        button.layer.cornerRadius = 8
        button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        button.layer.shadowOffset = CGSize(width: 0, height:4)
        button.layer.shadowOpacity = 1.0
        button.layer.shadowRadius = 4.0
        button.layer.masksToBounds = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    fileprivate let submitButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "check-mark"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(animateOut), for: .touchUpInside)


        return button
    }()
    
    
    
    fileprivate let picker: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    

    fileprivate lazy var topHorizontalStackView: UIStackView = {
        let padding: CGFloat = 8
        let stack = UIStackView(arrangedSubviews: [spacerView, inputTextField, cupLabel ])
        stack.spacing = padding
        stack.layoutMargins = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillEqually
        return stack
    }()
    
    fileprivate lazy var bottomHorizontalStackView: UIStackView = {
        let padding: CGFloat = 8

        let stack = UIStackView(arrangedSubviews: [addOneCupButton, addTwoCupsButton, addFourCupsButton ])
        stack.spacing = padding
        stack.layoutMargins = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillEqually
        return stack
    }()
    
    fileprivate let container : UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor(named: "RavenclawBlue")?.withAlphaComponent(0.75)
        v.isOpaque = false
        
        v.layer.cornerRadius = 24
        return v
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .gray
        
        applyBlurEffect()
        
        self.frame = UIScreen.main.bounds
        setupContainerView()

        animateIn()


    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    
    fileprivate func setupContainerView() {
        self.addSubview(container)
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(animateOut)))

        container.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        container.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        container.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.7).isActive = true
        container.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.25).isActive = true
        
        container.addSubview(bottomHorizontalStackView)
        bottomHorizontalStackView.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        bottomHorizontalStackView.isLayoutMarginsRelativeArrangement = true
        bottomHorizontalStackView.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
        bottomHorizontalStackView.trailingAnchor.constraint(equalTo: container.trailingAnchor).isActive = true
        bottomHorizontalStackView.widthAnchor.constraint(equalTo: container.widthAnchor).isActive = true
        bottomHorizontalStackView.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        bottomHorizontalStackView.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        bottomHorizontalStackView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        container.addSubview(topHorizontalStackView)
        topHorizontalStackView.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        topHorizontalStackView.isLayoutMarginsRelativeArrangement = true
        topHorizontalStackView.topAnchor.constraint(equalTo: container.topAnchor, constant: 40).isActive = true
        topHorizontalStackView.bottomAnchor.constraint(equalTo: bottomHorizontalStackView.topAnchor, constant: -8).isActive = true
        topHorizontalStackView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        topHorizontalStackView.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
        topHorizontalStackView.trailingAnchor.constraint(equalTo: container.trailingAnchor).isActive = true
        topHorizontalStackView.widthAnchor.constraint(equalTo: container.widthAnchor).isActive = true
        
        
        container.addSubview(picker)
        picker.delegate = self as UIPickerViewDelegate
        picker.dataSource = self as UIPickerViewDataSource
        picker.setValue(UIColor(named: "UndeadWhite"), forKeyPath: "textColor")
        picker.topAnchor.constraint(equalTo: bottomHorizontalStackView.bottomAnchor).isActive = true
        picker.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
        picker.trailingAnchor.constraint(equalTo: container.trailingAnchor).isActive = true
        picker.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        
        container.addSubview(submitButton)
        submitButton.topAnchor.constraint(equalTo: container.topAnchor, constant: -12).isActive = true
        submitButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: 12).isActive = true
    }
    
    fileprivate func applyBlurEffect() {
        //only apply the blur if the user hasn't disabled transparency effects
        if !UIAccessibility.isReduceTransparencyEnabled {
            self.backgroundColor = .clear
            
            let blurEffect = UIBlurEffect(style: .systemChromeMaterialDark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            //always fill the view
            blurEffectView.frame = self.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            self.addSubview(blurEffectView) //if you have more UIViews, use an insertSubview API to place it where needed
        } else {
            self.backgroundColor = UIColor.black.withAlphaComponent(0.75)
            self.isOpaque = false
            
        }
    }
    
    @objc fileprivate func animateOut() {

        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.container.transform = CGAffineTransform(translationX: 0, y: self.frame.height)
            self.alpha = 0

        }) { (complete) in
            if complete {
                self.removeFromSuperview()
            }
        }
    }
    
    @objc fileprivate func animateIn() {
        self.container.transform = CGAffineTransform(translationX: 0, y: self.frame.height)
        self.alpha = 0
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.container.transform = .identity
            self.alpha = 1

        })
    }
    
    
    //MARK: - Picker
    
    let dataArray = ["Water", "Tea", "Soda", "Coffee", "Alcohol", "Other"]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
           pickerView.subviews.forEach({
             $0.isHidden = $0.frame.height < 1.0
         })
         return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
       return dataArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
       let row = dataArray[row]
       return row
    }
}


