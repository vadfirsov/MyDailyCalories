//
//  EntityCell.swift
//  MyDailyCalories
//
//  Created by VADIM FIRSOV on 24/11/2019.
//  Copyright © 2019 VADIM FIRSOV. All rights reserved.
//

import UIKit

class EntityCell: UITableViewCell {
    
    var index = 0
    var tappedLongely : ((Int) -> Void)?
    
    @IBOutlet weak var lblName:     UILabel!
    @IBOutlet weak var lblCalories: UILabel!
    @IBOutlet weak var lblProtein:  UILabel!
    @IBOutlet weak var lblCarbs:    UILabel!
    @IBOutlet weak var lblFat:      UILabel!
        
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setAccessibilites()
    }
    func addGesture() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressed))
        self.addGestureRecognizer(longPress)
    }
    
    @objc func longPressed() {
        tappedLongely?(index)
    }
    
    func setWith(entity : Entity, index: Int) {

        let emptyValIndicator = "-"
        lblName.text =     (entity.name     == "") ? emptyValIndicator : entity.name
        lblCalories.text = (entity.calories == "") ? emptyValIndicator : entity.calories
        lblCarbs.text =    (entity.carbs    == "") ? emptyValIndicator : entity.carbs
        lblProtein.text =  (entity.protein  == "") ? emptyValIndicator : entity.protein
        lblFat.text =      (entity.fat      == "") ? emptyValIndicator : entity.fat
        
        addGesture()
        self.index =      index
    }
    
    private func setAccessibilites() {
        lblName.isAccessibilityElement =     true
        lblName.accessibilityHint = "Product name"
        lblCalories.isAccessibilityElement = true
        lblCalories.accessibilityHint = "Product calories"
        lblCarbs.isAccessibilityElement =    true
        lblCarbs.accessibilityHint = "Product carbs"
        lblProtein.isAccessibilityElement =  true
        lblProtein.accessibilityHint = "Product protein"
        lblFat.isAccessibilityElement =      true
        lblFat.accessibilityHint = "Product fat"
    }
}

extension EntityCell : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing(true)
        return false
    }
}
