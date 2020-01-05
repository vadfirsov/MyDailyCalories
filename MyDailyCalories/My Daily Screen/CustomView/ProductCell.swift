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
    
    @IBOutlet weak var productView:       CustomCellView!
    @IBOutlet weak var addNewProductView: CustomCellView!
    
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
