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
    
    override func layoutMarginsDidChange() {
        print(superview != nil)
        print(self.frame)
        self.layer.addSublayer(myGradiantLayer)
    }
    
    private var myGradiantLayer : CAGradientLayer {
        
        let gradiant = CAGradientLayer()
        gradiant.frame = UIScreen.main.bounds
        gradiant.colors = [#colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1).cgColor, #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1).cgColor]
        gradiant.shouldRasterize = true
        return gradiant
    }
}
