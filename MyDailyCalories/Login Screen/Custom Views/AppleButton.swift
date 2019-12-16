//
//  AppleButton.swift
//  MyDailyCalories
//
//  Created by pionet\Alex.s on 16/12/2019.
//  Copyright © 2019 VADIM FIRSOV. All rights reserved.
//

import UIKit

class AppleButton : CustomParentButton {
    
    private let bgColor =     #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    private let textColor =   #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    private let borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setDesign()
    }
    
    func setDesign() {
    
        self.backgroundColor = bgColor
        self.setTitle(" Sign in with Apple", for: .normal)
        self.layer.borderColor = borderColor.cgColor
        self.setTitleColor(textColor, for: .normal)
    }
    
}
