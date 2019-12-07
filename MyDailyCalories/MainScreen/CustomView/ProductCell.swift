//
//  ProductCell.swift
//  MyDailyCalories
//
//  Created by VADIM FIRSOV on 21/11/2019.
//  Copyright © 2019 VADIM FIRSOV. All rights reserved.
//

import UIKit

protocol ProductCellDelegate {
    func savedNew(product : Product)
    func tappedLonglyOnCell(atIndex index : Int)
}

class ProductCell : UITableViewCell {
    
    var delegate : ProductCellDelegate?
    var index = 0
    
    @IBOutlet weak var tfName:     UILabel!
    @IBOutlet weak var tfCalories: UILabel!
    @IBOutlet weak var tfProtein:  UILabel!
    @IBOutlet weak var tfCarbs:    UILabel!
    @IBOutlet weak var tfFat:      UILabel!
    
    func addGesture() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressed))
        self.addGestureRecognizer(longPress)
    }
    
    @objc func longPressed() {
        delegate?.tappedLonglyOnCell(atIndex: index)
    }
}

extension ProductCell : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing(true)
        return false
    }
}
