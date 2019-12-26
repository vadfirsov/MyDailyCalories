//
//  AdjustableTextLabel.swift
//  MyDailyCalories
//
//  Created by pionet\Alex.s on 25/12/2019.
//  Copyright © 2019 VADIM FIRSOV. All rights reserved.
//

import UIKit

class AdjustableTextLabel : UILabel {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        adjustsFontSizeToFitWidth = true
    }
}
