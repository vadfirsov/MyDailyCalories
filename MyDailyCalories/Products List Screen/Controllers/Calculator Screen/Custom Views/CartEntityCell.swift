//
//  CartEntityCell.swift
//  MyDailyCalories
//
//  Created by VADIM FIRSOV on 25/11/2019.
//  Copyright © 2019 VADIM FIRSOV. All rights reserved.
//

import UIKit

class CartEntityCell : UITableViewCell {
    
    var index = 0
    var parentVC : CartVC?
    var tappedLongely : ((Int) -> Void)?
    
    private var summedProduct : Product {
        return Product(name:     locStr("no_name"),
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
    
    private func locStr(_ string : String) -> String {
        return NSLocalizedString("cart_cell_" + string, comment: "")
    }
    
    private func setLabels(withCartEntity cartEntity : CartEntity) {
        lblName.text =     cartEntity.name
        lblCalories.text = locStr("kcal") + "\(cartEntity.calories.roundedString())"
        lblGrams.text =    locStr("gram") + "\(cartEntity.grams.roundedString())"
        lblProtein.text =  locStr("protein") + "\(cartEntity.protein.roundedString())"
        lblCartbs.text =   locStr("carbs") + "\(cartEntity.protein.roundedString())"
        lblFat.text =      locStr("fat") + "\(cartEntity.protein.roundedString())"
    }
    
    private func setCalculatedTotalNutritions() {
        tappedLongely?(index)
    }
    
    
    
    func addGesture() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressed))
        self.addGestureRecognizer(longPress)
    }
    
    @objc func longPressed() {
            
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
