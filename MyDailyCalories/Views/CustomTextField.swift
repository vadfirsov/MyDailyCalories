//
//  CustomTextField.swift
//  MyDailyCalories
//
//  Created by pionet\Alex.s on 05/12/2019.
//  Copyright © 2019 VADIM FIRSOV. All rights reserved.
//

import UIKit

class CustomTextField : UITextField {
    
    private let standartColor = #colorLiteral(red: 1, green: 0.521980226, blue: 0.383310914, alpha: 1)
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        customize()
    }
    
    private func customize() {
        self.borderStyle = .none
        self.layer.borderWidth = 1
        self.layer.borderColor = standartColor.cgColor
        self.backgroundColor = #colorLiteral(red: 1, green: 0.01462487131, blue: 0.45694381, alpha: 0)
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
        self.textColor = standartColor

    }
    
    func setPlaceholder(string : String) {
        let color = #colorLiteral(red: 0.6413516402, green: 0.6375417709, blue: 0.6442819834, alpha: 0.8482716182)
        let attributes = [ NSAttributedString.Key.foregroundColor: color]
        self.attributedPlaceholder = NSAttributedString(string: string, attributes: attributes)      
    }
}
