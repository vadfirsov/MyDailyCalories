//
//  ProductCell.swift
//  MyDailyCalories
//
//  Created by VADIM FIRSOV on 21/11/2019.
//  Copyright © 2019 VADIM FIRSOV. All rights reserved.
//

import UIKit


class ProductCell : UITableViewCell {
    
    var index = 0
    var tappedLongely : ((Int) -> Void)?
    
    @IBOutlet weak var tfName:     UILabel!
    @IBOutlet weak var tfCalories: UILabel!
    @IBOutlet weak var tfProtein:  UILabel!
    @IBOutlet weak var tfCarbs:    UILabel!
    @IBOutlet weak var tfFat:      UILabel!
    @IBOutlet weak var btnAddNewMeal: UIButton! {
        didSet {
            let locStr = NSLocalizedString("daily_add_new_meal", comment: "")
            btnAddNewMeal.setTitle(locStr, for: .normal)
            
        }
    }
    
    @IBOutlet weak var productView:       CustomCellView!
    @IBOutlet weak var addNewProductView: CustomCellView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setAccessibilities()
    }
    
    private func setAccessibilities() {
        tfName.isAccessibilityElement =        true
        tfName.accessibilityHint = "Name"
        tfCarbs.isAccessibilityElement =       true
        tfCalories.accessibilityHint = "Calories"
        tfCalories.isAccessibilityElement =    true
        tfFat.accessibilityHint = "Fat"
        tfFat.isAccessibilityElement =         true
        tfCarbs.accessibilityHint = "Carbs"
        btnAddNewMeal.isAccessibilityElement = true
    }
    
    private func addGesture() {
           let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressed))
           self.addGestureRecognizer(longPress)
    }
    
    @objc func longPressed() {
        tappedLongely?(index)
    }
    
    func setWith(product : Product, index: Int) {
        addGesture()
        
        let noValueIndicator = "--"
        tfName.text =     (product.name     == "") ? noValueIndicator : product.name
        tfCalories.text = (product.calories == "") ? noValueIndicator : product.calories
        tfProtein.text =  (product.protein  == "") ? noValueIndicator : product.protein
        tfCarbs.text =    (product.carbs    == "") ? noValueIndicator : product.carbs
        tfFat.text =      (product.fat      == "") ? noValueIndicator : product.fat

        addNewProductView.isHidden = true
        productView.isHidden = false
        
        self.index = index
    }
}

extension ProductCell : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing(true)
        return false
    }
}
