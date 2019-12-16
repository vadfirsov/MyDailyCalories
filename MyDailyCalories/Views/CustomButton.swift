//
//  CustomButton.swift
//  MyDailyCalories
//
//  Created by pionet\Alex.s on 08/12/2019.
//  Copyright © 2019 VADIM FIRSOV. All rights reserved.
//

import UIKit

class CustomButton : CustomParentButton { //CustomParentButton
    
    private let bgColor =     #colorLiteral(red: 0, green: 0.6765274405, blue: 0.4677766562, alpha: 1)
//    private let bgColor =     #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)

    private let textColor =   #colorLiteral(red: 0.9664010406, green: 0.999112308, blue: 1, alpha: 1)
    
//    private let textColor =   #colorLiteral(red: 0.1264530122, green: 0.125708729, blue: 0.1270299256, alpha: 1)

    private let borderColor = #colorLiteral(red: 0.18590343, green: 0.7385808229, blue: 0.5299064517, alpha: 1)
//    private let borderColor = #colorLiteral(red: 0.9559559226, green: 0.9502728581, blue: 0.9603242278, alpha: 1)


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
        
        layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
}
