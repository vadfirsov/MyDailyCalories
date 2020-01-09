//
//  FacebookButton.swift
//  MyDailyCalories
//
//  Created by pionet\Alex.s on 08/12/2019.
//  Copyright © 2019 VADIM FIRSOV. All rights reserved.
//

import UIKit

class FacebookButton : CustomParentButton {
    
    private let bgColor =     #colorLiteral(red: 0.143147856, green: 0.3265746236, blue: 0.7066633105, alpha: 1)
    private let textColor =   #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    private let borderColor = #colorLiteral(red: 0.2205816805, green: 0.3981317878, blue: 0.7782555223, alpha: 1)
    
    let animatedBgColor =     #colorLiteral(red: 0.1274367273, green: 0.2913477719, blue: 0.6303659678, alpha: 1)
    let animatedBorderColor = #colorLiteral(red: 0.2002905011, green: 0.3595842719, blue: 0.701279819, alpha: 1)
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setDesign()
    }
    
    func setDesign() {
    
        self.backgroundColor = bgColor
        self.addIcon(named: "fb_icon")
        self.setTitle(NSLocalizedString("Sign-In with Facebook", comment: ""), for: .normal)
        self.isAccessibilityElement = true
        self.layer.borderColor = borderColor.cgColor
        self.setTitleColor(textColor, for: .normal)
    }
}
