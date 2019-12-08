//
//  GradiantView.swift
//  MyDailyCalories
//
//  Created by pionet\Alex.s on 05/12/2019.
//  Copyright © 2019 VADIM FIRSOV. All rights reserved.
//

import UIKit

class GradiantViewOrange : UIView {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.layer.addSublayer(myGradiantLayer)
    }

    private var myGradiantLayer : CAGradientLayer {
        let gradiant = CAGradientLayer()
        gradiant.frame = self.bounds
        gradiant.colors = [#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1).cgColor, #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1).cgColor]
//        gradiant.colors = [#colorLiteral(red: 0.9832625985, green: 0.6496973634, blue: 0.3884976804, alpha: 1).cgColor, #colorLiteral(red: 0.9926779866, green: 0.4866132736, blue: 0.451841116, alpha: 1).cgColor]
        gradiant.shouldRasterize = true
        return gradiant
    }
}
