//
//  AddEntryPopupView.swift
//  Hydrate
//
//  Created by David Wright on 7/2/20.
//  Copyright © 2020 Hydrate. All rights reserved.
//

import UIKit

protocol AddEntryPopupDelegate: class {
    func didAddIntakeEntry(_ intakeEntry: IntakeEntry)
}

class AddEntryPopup: UIView {
    
    // MARK: - Properties
    
    weak var delegate: AddEntryPopupDelegate!
    
    // MARK: - UIComponents
    
    
    // MARK: - Selectors
    
    
    // MARK: - Helpers
    
    
}
