//
//  GradiantView.swift
//  MyDailyCalories
//
//  Created by pionet\Alex.s on 05/12/2019.
//  Copyright © 2019 VADIM FIRSOV. All rights reserved.
//

import UIKit

class GradiantView : UIView {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setBackground()
    }
    
    private func setBackground() {
        let gradiant = CAGradientLayer()
        gradiant.frame = self.bounds
        gradiant.colors = [#colorLiteral(red: 0, green: 0.5725490196, blue: 0.2705882353, alpha: 1).cgColor, #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1).cgColor]
        gradiant.shouldRasterize = true
        
        self.layer.addSublayer(gradiant)
    }
}
