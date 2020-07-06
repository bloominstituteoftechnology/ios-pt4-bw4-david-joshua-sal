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
    func didEndEditing()
}

class AddEntryPopup: UIView {
    
    // MARK: - Properties
    
    weak var delegate: AddEntryPopupDelegate!
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter
    }()
    
    fileprivate lazy var timeFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        return dateFormatter
    }()
    
    fileprivate lazy var dateAndTimeFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        return dateFormatter
    }()
    
    // MARK: - UIComponents
    
    fileprivate let dateTextField: CustomTextField = {
        let textField = CustomTextField()
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        let placeholder = formatter.string(from: Date())

        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.662745098, green: 0.662745098, blue: 0.6705882353, alpha: 1)])
        textField.backgroundColor = UIColor.undeadWhite
        textField.textColor = UIColor.sicklySmurfBlue
        textField.font = .systemFont(ofSize: 17, weight: .medium)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.cornerRadius = 8
        textField.heightAnchor.constraint(equalToConstant: 32).isActive = true
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
        textField.font = .systemFont(ofSize: 17, weight: .medium)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.cornerRadius = 8
        textField.heightAnchor.constraint(equalToConstant: 32).isActive = true
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
        textField.font = .systemFont(ofSize: 17, weight: .medium)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.cornerRadius = 8
        textField.heightAnchor.constraint(equalToConstant: 32).isActive = true
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
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textColor = #colorLiteral(red: 0.6352941176, green: 0.6509803922, blue: 0.6862745098, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let padding: CGFloat = 8
        let stack = UIStackView(arrangedSubviews: [label, dateTextField])
        stack.axis = .vertical
        stack.spacing = 8
        stack.layoutMargins = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fill
        return stack
    }()
    
    fileprivate lazy var timeStackView: UIStackView = {
        let label = UILabel()
        label.text = "Time"
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textColor = #colorLiteral(red: 0.6352941176, green: 0.6509803922, blue: 0.6862745098, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let padding: CGFloat = 8
        let stack = UIStackView(arrangedSubviews: [label, timeTextField])
        stack.axis = .vertical
        stack.spacing = 8
        stack.layoutMargins = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fill
        return stack
    }()
    
    fileprivate lazy var amountStackView: UIStackView = {
        let unitsLabel = UILabel()
        unitsLabel.text = "ounces"
        unitsLabel.textColor = UIColor.undeadWhite
        unitsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let horizontalStackView = UIStackView(arrangedSubviews: [amountTextField, unitsLabel])
        horizontalStackView.axis = .horizontal
        horizontalStackView.distribution = .fill
        horizontalStackView.alignment = .center
        horizontalStackView.spacing = 6
        
        let label = UILabel()
        label.text = "Intake"
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textColor = #colorLiteral(red: 0.6352941176, green: 0.6509803922, blue: 0.6862745098, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let padding: CGFloat = 8
        let stack = UIStackView(arrangedSubviews: [label, horizontalStackView])
        stack.axis = .vertical
        stack.spacing = 8
        stack.layoutMargins = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fill
        return stack
    }()
    
    fileprivate lazy var inputStackView: UIStackView = {
        let titleLabel = UILabel()
        titleLabel.text = "New Intake Entry"
        titleLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        titleLabel.textColor = UIColor.undeadWhite
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let padding: CGFloat = 8
        let stack = UIStackView(arrangedSubviews: [titleLabel, dateStackView, timeStackView, amountStackView])
        stack.axis = .vertical
        stack.spacing = 16
        stack.layoutMargins = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillProportionally
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
    
    fileprivate let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        return datePicker
    }()
    
    fileprivate let timePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .time
        return datePicker
    }()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .gray
        
        applyBlurEffect()
        
        self.frame = UIScreen.main.bounds
        setupContainerView()
        
        setupDatePicker()
        setupTimePicker()

        animateIn()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(for date: Date) {
        self.init()
        self.dateTextField.text = dateFormatter.string(from: date)
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
        guard let dateText = dateTextField.text, let timeText = timeTextField.text,
            let timestamp = dateAndTimeFormatter.date(from: dateText + " at " + timeText),
            let amountText = amountTextField.text, let intakeAmount = Int(amountText) else { return }
        
        delegate.didAddIntakeEntry(withDate: timestamp, intakeAmount: intakeAmount)
        animateOut()
    }
    
    @objc func datePickerDoneButtonPressed() {
        dateTextField.text = dateFormatter.string(from: datePicker.date)
        delegate.didEndEditing()
    }
    
    @objc func timePickerDoneButtonPressed() {
        timeTextField.text = timeFormatter.string(from: timePicker.date)
        delegate.didEndEditing()
    }
    
    @objc func dateChanged() {
        dateTextField.text = dateFormatter.string(from: datePicker.date)
    }
    
    @objc func timeChanged() {
        timeTextField.text = timeFormatter.string(from: timePicker.date)
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
    
    @objc fileprivate func handleTapInContainer() {
        if dateTextField.isFirstResponder {
            datePickerDoneButtonPressed()
        } else if timeTextField.isFirstResponder {
            timePickerDoneButtonPressed()
        } else {
            delegate.didEndEditing()
        }
    }
    
    // MARK: - Helpers
    
    fileprivate func setupContainerView() {
        self.addSubview(container)
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(animateOut)))
        container.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapInContainer)))
        
        container.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -350).isActive = true
        container.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        container.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.7).isActive = true
        container.heightAnchor.constraint(equalToConstant: 296).isActive = true
        
        container.addSubview(inputStackView)
        inputStackView.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        inputStackView.isLayoutMarginsRelativeArrangement = true
        inputStackView.topAnchor.constraint(equalTo: container.topAnchor, constant: 16).isActive = true
        inputStackView.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
        inputStackView.trailingAnchor.constraint(equalTo: container.trailingAnchor).isActive = true
        
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
    
    fileprivate func setupDatePicker() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.tintColor = .sicklySmurfBlue
        toolbar.barTintColor = #colorLiteral(red: 0.1883931463, green: 0.1966297553, blue: 0.2213395825, alpha: 1)
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(datePickerDoneButtonPressed))
        toolbar.setItems([doneButton], animated: true)
        
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        
        dateTextField.inputAccessoryView = toolbar
        dateTextField.inputView = datePicker
    }
    
    fileprivate func setupTimePicker() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.tintColor = .sicklySmurfBlue
        toolbar.barTintColor = #colorLiteral(red: 0.1883931463, green: 0.1966297553, blue: 0.2213395825, alpha: 1)
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(timePickerDoneButtonPressed))
        toolbar.setItems([doneButton], animated: true)
        
        timePicker.addTarget(self, action: #selector(timeChanged), for: .valueChanged)
        timeTextField.inputAccessoryView = toolbar
        timeTextField.inputView = timePicker
    }
}
