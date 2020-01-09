//
//  ReadyProductsCell.swift
//  MyDailyCalories
//
//  Created by pionet\Alex.s on 10/12/2019.
//  Copyright © 2019 VADIM FIRSOV. All rights reserved.
//

import UIKit

class ReadyProductCell : UITableViewCell {
    
    @IBOutlet weak var lblProductName: UILabel!
    
    override func awakeFromNib() {
        lblProductName.isAccessibilityElement = true
    }
}
