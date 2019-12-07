//
//  GradientViewBlack.swift
//  MyDailyCalories
//
//  Created by pionet\Alex.s on 06/12/2019.
//  Copyright © 2019 VADIM FIRSOV. All rights reserved.
//

import UIKit

class GradiantViewBlack : UIView {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.layer.addSublayer(myGradiantLayer)
    }

    private var myGradiantLayer : CAGradientLayer {
        let gradiant = CAGradientLayer()
        gradiant.frame = self.bounds
        gradiant.colors = [#colorLiteral(red: 0.1450169086, green: 0.1451832354, blue: 0.1407575011, alpha: 1).cgColor, #colorLiteral(red: 0.2115600705, green: 0.2176567614, blue: 0.215184927, alpha: 1).cgColor]
        gradiant.shouldRasterize = true
        return gradiant
    }
}
