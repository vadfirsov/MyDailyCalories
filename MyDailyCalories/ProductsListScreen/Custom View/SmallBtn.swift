//
//  SmallBtn.swift
//  MyDailyCalories
//
//  Created by pionet\Alex.s on 06/12/2019.
//  Copyright © 2019 VADIM FIRSOV. All rights reserved.
//

import UIKit

class SmallBtn : UIButton {
    
    var isBtnSelected = false {
        didSet { updateBtnDesign() }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        customize()
    }
    
    private func customize() {
        setBorders()
        addShadow()
        isBtnSelected = false
    }
    
    private func addShadow() {
        self.layer.shadowColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 0)
        self.layer.shadowOffset = CGSize(width: 1, height: 2)
        self.layer.masksToBounds = false
        self.layer.shadowOpacity = 0.5
    }

    
    private func setBorders() {
        self.layer.cornerRadius = 8
        self.layer.borderWidth = 0.75
        self.clipsToBounds = true
    }

    private func updateBtnDesign() {
        self.backgroundColor =   isBtnSelected ? #colorLiteral(red: 1, green: 0.4904733896, blue: 0.3423442841, alpha: 1) : #colorLiteral(red: 0.2541798353, green: 0.2546336055, blue: 0.2484343648, alpha: 0.1010809075)
        self.layer.borderColor = isBtnSelected ? #colorLiteral(red: 1, green: 0.5693049431, blue: 0.4109791517, alpha: 1) : #colorLiteral(red: 0.1516718268, green: 0.1586366892, blue: 0.149766326, alpha: 0)
        self.layer.shadowColor = isBtnSelected ? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) : #colorLiteral(red: 0.1516718268, green: 0.1586366892, blue: 0.149766326, alpha: 0)
        let titleColor =         isBtnSelected ? #colorLiteral(red: 0.2227313817, green: 0.2275489867, blue: 0.2318012118, alpha: 1) : #colorLiteral(red: 0.7686912417, green: 0.7685188651, blue: 0.7771531343, alpha: 1)
        self.setTitleColor(titleColor, for: .normal)
    }
}

