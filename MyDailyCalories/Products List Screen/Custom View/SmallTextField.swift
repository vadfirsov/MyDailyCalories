//
//  SmallTextField.swift
//  MyDailyCalories
//
//  Created by pionet\Alex.s on 06/12/2019.
//  Copyright © 2019 VADIM FIRSOV. All rights reserved.
//

import UIKit

class SmallTextField : UITextField {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        customize()
        addShadow()
        setPlaceholder()
    }
    
    private func customize() {
        self.borderStyle = .none
        self.layer.borderWidth = 1.5
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
        updateDesign()
    }
    
    private func addShadow() {
        self.layer.shadowColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 0)
        self.layer.shadowOffset = CGSize(width: 1, height: 2)
        self.layer.masksToBounds = false
        self.layer.shadowOpacity = 0.5
    }
    
    private func setPlaceholder() {
        let placeholderColor = #colorLiteral(red: 0.7686912417, green: 0.7685188651, blue: 0.7771531343, alpha: 1)
        let selectedTitleColor = #colorLiteral(red: 0.2321718335, green: 0.2273033559, blue: 0.2273420095, alpha: 1)
        self.textColor = selectedTitleColor
                
        let attributes = [ NSAttributedString.Key.foregroundColor: placeholderColor]
        let custom_g = NSLocalizedString("small_tf_custom_g", comment: "")
        self.attributedPlaceholder = NSAttributedString(string: custom_g, attributes: attributes)
    }
    
    func updateDesign() {
        self.backgroundColor =   isEditing ? #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1) : #colorLiteral(red: 0.2541798353, green: 0.2546336055, blue: 0.2484343648, alpha: 0.1010809075)
        self.layer.borderColor = isEditing ? #colorLiteral(red: 1, green: 0.770793736, blue: 0.2863535285, alpha: 1) : #colorLiteral(red: 0.1516718268, green: 0.1586366892, blue: 0.149766326, alpha: 0)
        self.layer.shadowColor = isEditing ? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) : #colorLiteral(red: 0.1516718268, green: 0.1586366892, blue: 0.149766326, alpha: 0)
     }
}
