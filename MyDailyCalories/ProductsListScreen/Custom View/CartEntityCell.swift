//
//  CartEntityCell.swift
//  MyDailyCalories
//
//  Created by VADIM FIRSOV on 25/11/2019.
//  Copyright © 2019 VADIM FIRSOV. All rights reserved.
//

import UIKit
protocol CartCellDelegate {
    func tappedLonglyOnCell(atIndex index : Int)
}

class CartEntityCell : UITableViewCell {
    
    var delegate : CartCellDelegate?
    var index = 0
    
    @IBOutlet weak var lblName:     UILabel!
    @IBOutlet weak var lblGrams:    UILabel!
    @IBOutlet weak var lblCalories: UILabel!
    @IBOutlet weak var lblCartbs:   UILabel!
    @IBOutlet weak var lblFat:      UILabel!
    @IBOutlet weak var lblProtein:  UILabel!
    
    func setCell(withCartEntity cartEntity : CartEntity, index : Int) {
        lblName.text =     cartEntity.name
        lblCalories.text = "Cal: \(cartEntity.calories.roundedString())"
        lblGrams.text =    "Grams: \(cartEntity.grams.roundedString())"
        lblProtein.text =  "Protein: \(cartEntity.protein.roundedString())"
        lblCartbs.text =   "Carbs: \(cartEntity.protein.roundedString())"
        lblFat.text =      "Fat: \(cartEntity.protein.roundedString())"
        
        self.index = index
        
        addGesture()
    }
    
    func addGesture() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressed))
        self.addGestureRecognizer(longPress)
    }
    
    @objc func longPressed() {
        delegate?.tappedLonglyOnCell(atIndex: index)
    }
    
}
