//
//  AddEntryPopupView.swift
//  Hydrate
//
//  Created by David Wright on 7/2/20.
//  Copyright © 2020 Hydrate. All rights reserved.
//

import UIKit

protocol AddEntryPopupDelegate: class {
    func didAddIntakeEntry(withDate date: Date, intakeAmount: Int)
}

class AddEntryPopup: UIView {
    
    // MARK: - Properties
    
    weak var delegate: AddEntryPopupDelegate!
    
    fileprivate var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        return dateFormatter
    }()
    
    fileprivate var timeFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        return dateFormatter
    }()
    
    // MARK: - UIComponents
    
    fileprivate let dateTextField: CustomTextField = {
        let textField = CustomTextField()
        
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        let placeholder = formatter.string(from: Date())

        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.662745098, green: 0.662745098, blue: 0.6705882353, alpha: 1)])
        textField.backgroundColor = UIColor.undeadWhite
        textField.textColor = UIColor.ravenClawBlue
        textField.font = .systemFont(ofSize: 18, weight: .medium)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.cornerRadius = 8
        textField.keyboardType = .numberPad
        textField.keyboardAppearance = UIKeyboardAppearance.dark
        textField.addTarget(self, action: #selector(textFieldValueChanged), for: .editingChanged)
        return textField
    }()
    
    fileprivate let timeTextField: CustomTextField = {
        let textField = CustomTextField()
        
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        let placeholder = formatter.string(from: Date())
        
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.662745098, green: 0.662745098, blue: 0.6705882353, alpha: 1)])
        textField.backgroundColor = UIColor.undeadWhite
        textField.textColor = UIColor.sicklySmurfBlue
        textField.font = .systemFont(ofSize: 18, weight: .medium)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.cornerRadius = 8
        textField.keyboardType = .numberPad
        textField.keyboardAppearance = UIKeyboardAppearance.dark
        textField.addTarget(self, action: #selector(textFieldValueChanged), for: .editingChanged)
        return textField
    }()
    
    fileprivate let amountTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.attributedPlaceholder = NSAttributedString(string: "10", attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.662745098, green: 0.662745098, blue: 0.6705882353, alpha: 1)])
        textField.backgroundColor = UIColor.undeadWhite
        textField.textColor = UIColor.sicklySmurfBlue
        textField.font = .systemFont(ofSize: 18, weight: .medium)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.cornerRadius = 8
        textField.keyboardType = .numberPad
        textField.keyboardAppearance = UIKeyboardAppearance.dark
        textField.addTarget(self, action: #selector(textFieldValueChanged), for: .editingChanged)
        return textField
    }()
    
    fileprivate let submitButton: UIButton = {
        let button = UIButton()
        button.tintColor = UIColor.disabledButtonColor
        let config = UIImage.SymbolConfiguration(pointSize: 40)
        let image = UIImage(systemName: "checkmark.circle.fill", withConfiguration: config)
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var dateStackView: UIStackView = {
        let label = UILabel()
        label.text = "Date"
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = UIColor.sicklySmurfBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let padding: CGFloat = 8
        let stack = UIStackView(arrangedSubviews: [label, dateTextField])
        stack.axis = .vertical
        stack.spacing = padding
        stack.layoutMargins = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillEqually
        return stack
    }()
    
    fileprivate lazy var timeStackView: UIStackView = {
        let label = UILabel()
        label.text = "Time"
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = UIColor.sicklySmurfBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let padding: CGFloat = 8
        let stack = UIStackView(arrangedSubviews: [label, timeTextField])
        stack.axis = .vertical
        stack.spacing = padding
        stack.layoutMargins = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillEqually
        return stack
    }()
    
    fileprivate lazy var amountStackView: UIStackView = {
        let label = UILabel()
        label.text = "Intake Amount"
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = UIColor.sicklySmurfBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let padding: CGFloat = 8
        let stack = UIStackView(arrangedSubviews: [label, amountTextField])
        stack.axis = .vertical
        stack.spacing = padding
        stack.layoutMargins = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillEqually
        return stack
    }()
    
    fileprivate let container : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.ravenClawBlue90.withAlphaComponent(0.75)
        view.isOpaque = false
        view.layer.cornerRadius = 24
        return view
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
    
    // MARK: - Selectors
    
    @objc func textFieldValueChanged() {
        if let dateText = dateTextField.text, dateFormatter.date(from: dateText) != nil,
            let timeText = timeTextField.text, timeFormatter.date(from: timeText) != nil,
            let amountText = amountTextField.text, Int(amountText) != nil {
            submitButton.tintColor = .sicklySmurfBlue
        } else {
            submitButton.tintColor = .disabledButtonColor
        }
        layoutIfNeeded()
    }
    
    @objc func submitButtonTapped() {
        guard let dateText = dateTextField.text, let date = dateFormatter.date(from: dateText),
            let timeText = timeTextField.text, let time = timeFormatter.date(from: timeText),
            let amountText = amountTextField.text, let intakeAmount = Int(amountText) else { return }
        
        let timestamp = date
        delegate.didAddIntakeEntry(withDate: timestamp, intakeAmount: intakeAmount)
        animateOut()
    }
    
    @objc fileprivate func animateOut() {

        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.container.transform = CGAffineTransform(translationX: 0, y: self.frame.height)
            self.alpha = 0

        }) { (complete) in
            if complete {
                let generator = UIImpactFeedbackGenerator(style: .medium)
                generator.impactOccurred()
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
    
    // MARK: - Helpers
    
    fileprivate func setupContainerView() {
        self.addSubview(container)
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(animateOut)))

        container.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        container.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        container.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.7).isActive = true
        //container.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.25).isActive = true
        
        container.addSubview(dateStackView)
        dateStackView.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        dateStackView.isLayoutMarginsRelativeArrangement = true
        dateStackView.topAnchor.constraint(equalTo: container.topAnchor, constant: 32).isActive = true
        dateStackView.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
        dateStackView.trailingAnchor.constraint(equalTo: container.trailingAnchor).isActive = true
        
        container.addSubview(timeStackView)
        timeStackView.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        timeStackView.isLayoutMarginsRelativeArrangement = true
        timeStackView.topAnchor.constraint(equalTo: dateStackView.bottomAnchor, constant: 16).isActive = true
        timeStackView.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
        timeStackView.trailingAnchor.constraint(equalTo: container.trailingAnchor).isActive = true
        
        container.addSubview(amountStackView)
        amountStackView.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        amountStackView.isLayoutMarginsRelativeArrangement = true
        amountStackView.topAnchor.constraint(equalTo: timeStackView.bottomAnchor, constant: 16).isActive = true
        amountStackView.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
        amountStackView.trailingAnchor.constraint(equalTo: container.trailingAnchor).isActive = true
        amountStackView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -32).isActive = true
        
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
}
