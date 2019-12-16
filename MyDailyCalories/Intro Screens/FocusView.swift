//
//  FocusView.swift
//  MyDailyCalories
//
//  Created by pionet\Alex.s on 12/12/2019.
//  Copyright © 2019 VADIM FIRSOV. All rights reserved.
//

import UIKit

class FocusView : UIView {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setView()
    }
    
    private func setView() {
        backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        layer.borderWidth = 2
        layer.borderColor = #colorLiteral(red: 1, green: 0.6096229553, blue: 0, alpha: 1)
        layer.cornerRadius = 12
        clipsToBounds = true
    }
}
