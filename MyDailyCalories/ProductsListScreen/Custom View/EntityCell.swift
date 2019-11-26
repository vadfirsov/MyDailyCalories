//
//  EntityCell.swift
//  MyDailyCalories
//
//  Created by VADIM FIRSOV on 24/11/2019.
//  Copyright © 2019 VADIM FIRSOV. All rights reserved.
//

import UIKit

protocol EntityCellDelegate {
    func tappedLonglyOnCell(index : Int)
}

class EntityCell: UITableViewCell {
    
    var delegate : EntityCellDelegate?
    var index = 0
    
    @IBOutlet weak var lblName:     UILabel!
    @IBOutlet weak var lblCalories: UILabel!
    @IBOutlet weak var lblProtein:  UILabel!
    @IBOutlet weak var lblCarbs:    UILabel!
    @IBOutlet weak var lblFat:      UILabel!
        
    func addGesture() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressed))
        self.addGestureRecognizer(longPress)
    }
    
    @objc func longPressed() {
        delegate?.tappedLonglyOnCell(index: index)
    }
    
}

extension EntityCell : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing(true)
        return false
    }
}
