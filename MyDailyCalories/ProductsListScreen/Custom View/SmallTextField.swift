//
//  SmallTextField.swift
//  MyDailyCalories
//
//  Created by pionet\Alex.s on 06/12/2019.
//  Copyright © 2019 VADIM FIRSOV. All rights reserved.
//

import UIKit

class SmallTextField : UITextField {
    

    
//    var isTfSelected = false {
//        didSet {
//            self.layer.borderColor = isTfSelected ? selectedBorderColor : unselectedBorderColor
//        }
//    }
    
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
        self.attributedPlaceholder = NSAttributedString(string: "custom gr", attributes: attributes)
    }
    
//    private let unselectedBorderColor = #colorLiteral(red: 0.1516718268, green: 0.1586366892, blue: 0.149766326, alpha: 0).cgColor
//    private let selectedBorderColor =   #colorLiteral(red: 1, green: 0.5692209601, blue: 0.4097279906, alpha: 1).cgColor
//    private let selectedColor =         #colorLiteral(red: 0.9983753562, green: 0.4877784252, blue: 0.3479389846, alpha: 1)
//    private let unselectedColor =       #colorLiteral(red: 0.2541798353, green: 0.2546336055, blue: 0.2484343648, alpha: 0.1010809075)
    
    func updateDesign() {
        self.backgroundColor =   self.isEditing ? #colorLiteral(red: 1, green: 0.4904733896, blue: 0.3423442841, alpha: 1) : #colorLiteral(red: 0.2541798353, green: 0.2546336055, blue: 0.2484343648, alpha: 0.1010809075)
        self.layer.borderColor = self.isEditing ? #colorLiteral(red: 1, green: 0.5693049431, blue: 0.4109791517, alpha: 1) : #colorLiteral(red: 0.1516718268, green: 0.1586366892, blue: 0.149766326, alpha: 0)
        self.layer.shadowColor = self.isEditing ? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) : #colorLiteral(red: 0.1516718268, green: 0.1586366892, blue: 0.149766326, alpha: 0)
     }
}
