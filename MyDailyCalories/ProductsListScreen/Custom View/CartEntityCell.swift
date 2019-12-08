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
    var parentVC : CartVC?
    
    private var summedProduct : Product {
        return Product(name:     "No Name",
                       calories: lblTotalCalories.text ?? "0",
                       protein:  lblTotalProtein.text  ?? "0",
                       carbs:    lblTotalCarbs.text    ?? "0",
                       fat:      lblTotalFat.text      ?? "0")
    }
    
    @IBOutlet weak var lblName:     UILabel!
    @IBOutlet weak var lblGrams:    UILabel!
    @IBOutlet weak var lblCalories: UILabel!
    @IBOutlet weak var lblCartbs:   UILabel!
    @IBOutlet weak var lblFat:      UILabel!
    @IBOutlet weak var lblProtein:  UILabel!
    
    @IBOutlet weak var lblTotalCalories: UILabel!
    @IBOutlet weak var lblTotalProtein:  UILabel!
    @IBOutlet weak var lblTotalCarbs:    UILabel!
    @IBOutlet weak var lblTotalFat:      UILabel!
    
    @IBOutlet weak var viewTotalNutritions: CustomCellView!
    @IBOutlet weak var viewActionButtons:   CustomCellView!
    @IBOutlet weak var btnServings:         CustomButton!
    
    func setCell(withCartEntity cartEntity : CartEntity, index : Int) {
        
        setLabels(withCartEntity: cartEntity)
        hideLastCellProperties()
        
        self.index = index
        addGesture()
    }
    
    func setLastCellLabels(withSummedCart summedCart : CartEntity) {
        lblTotalCalories.text = summedCart.calories.roundedString()
        lblTotalProtein.text =  summedCart.protein.roundedString()
        lblTotalCarbs.text =    summedCart.carbs.roundedString()
        lblTotalFat.text =      summedCart.fat.roundedString()
    }
    
    private func hideLastCellProperties() {
        viewTotalNutritions.isHidden = true
        viewActionButtons.isHidden =   true
    }
    
    private func setLabels(withCartEntity cartEntity : CartEntity) {
        lblName.text =     cartEntity.name
        lblCalories.text = "kCal: \(cartEntity.calories.roundedString())"
        lblGrams.text =    "Gram: \(cartEntity.grams.roundedString())"
        lblProtein.text =  "Protein: \(cartEntity.protein.roundedString())"
        lblCartbs.text =   "Carbs: \(cartEntity.protein.roundedString())"
        lblFat.text =      "Fat: \(cartEntity.protein.roundedString())"
    }
    
    private func setCalculatedTotalNutritions() {
        
    }
    
    func addGesture() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressed))
        self.addGestureRecognizer(longPress)
    }
    
    @objc func longPressed() {
        delegate?.tappedLonglyOnCell(atIndex: index)
    }
    
    @IBAction func servingsTapped(_ sender: CustomButton) {
        sender.animateTap(bgColor: sender.animatedBgColor, borderColor: sender.animatedBorderColor)
        if parentVC != nil {
            AlertManager.shared.showAlertChooseServings(inVC: parentVC!)
        }
    }
    
    @IBAction func emptyCartTapped(_ sender: CustomButton) {
        sender.animateTap(bgColor: sender.animatedBgColor, borderColor: sender.animatedBorderColor)
        if parentVC != nil {
            AlertManager.shared.showAlertEmptyCart(inVC: parentVC!)
        }
    }
    
    @IBAction func addToDailyTapped(_ sender: CustomButton) {
        sender.animateTap(bgColor: sender.animatedBgColor, borderColor: sender.animatedBorderColor)
        if parentVC != nil {
            AlertManager.shared.showAlertAddToDailyWithName(inVC: parentVC!, product: summedProduct)
        }
    }
}
