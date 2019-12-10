//
//  CustomButton.swift
//  MyDailyCalories
//
//  Created by pionet\Alex.s on 08/12/2019.
//  Copyright © 2019 VADIM FIRSOV. All rights reserved.
//

import UIKit

class CustomButton : CustomParentButton { //CustomParentButton
    
    private let bgColor =     #colorLiteral(red: 0.9797144532, green: 1, blue: 0.9608044028, alpha: 0.5)
    private let textColor =   #colorLiteral(red: 0.1264530122, green: 0.125708729, blue: 0.1270299256, alpha: 1)
    private let borderColor = #colorLiteral(red: 0.9999018312, green: 1, blue: 0.9998798966, alpha: 0.1547784675)

    let animatedBgColor =     #colorLiteral(red: 0.7085114717, green: 0.7043017149, blue: 0.7117487788, alpha: 0.5035049229)
    let animatedBorderColor = #colorLiteral(red: 0.6607298255, green: 0.6627320647, blue: 0.6874842644, alpha: 0.3221853596)
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setDesign()
    }
    
    func setDesign() {
        
        self.backgroundColor = bgColor
        self.setTitleColor(textColor, for: .normal)
        self.layer.borderColor = borderColor.cgColor
        
        layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
    }
}
