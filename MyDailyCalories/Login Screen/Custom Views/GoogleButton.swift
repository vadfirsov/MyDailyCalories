//
//  GoogleButton.swift
//  MyDailyCalories
//
//  Created by pionet\Alex.s on 08/12/2019.
//  Copyright © 2019 VADIM FIRSOV. All rights reserved.
//

import UIKit

class GoogleButton : CustomParentButton {
    
    private let bgColor =     #colorLiteral(red: 0.999904573, green: 1, blue: 0.9998808503, alpha: 1)
    private let textColor =   #colorLiteral(red: 0.5028075576, green: 0.4978307486, blue: 0.5022109151, alpha: 1)
    private let borderColor = #colorLiteral(red: 0.999904573, green: 1, blue: 0.9998808503, alpha: 1)
    
    let animatedBgColor =     #colorLiteral(red: 0.8973491192, green: 0.8920149803, blue: 0.9014495015, alpha: 1)
    let animatedBorderColor = #colorLiteral(red: 0.9695035815, green: 0.9644463658, blue: 0.9731348157, alpha: 1)
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setDesign()
    }
    
    func setDesign() {
        self.backgroundColor = bgColor
        addIcon(named: "google_icon")
        self.setTitle(NSLocalizedString("Sign-In with Google", comment: ""), for: .normal)
        self.setTitleColor(textColor, for: .normal)
        self.layer.borderColor = borderColor.cgColor
    }
}
