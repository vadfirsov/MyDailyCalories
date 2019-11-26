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
    func tappedLonglyOnCell(atIndex : Int)
}

class ProductCell : UITableViewCell {
    
    var delegate : ProductCellDelegate?
    var index = 0
    
    @IBOutlet weak var tfName:     UITextField!
    @IBOutlet weak var tfCalories: UITextField!
    @IBOutlet weak var tfProtein:  UITextField!
    @IBOutlet weak var tfCarbs:    UITextField!
    @IBOutlet weak var tfFat:      UITextField!
    
    @IBOutlet var textFields: [UITextField]! {
        didSet {
            for tf in textFields {
                tf.delegate =  self
                tf.isEnabled = false
            }
        }
    }
    
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
