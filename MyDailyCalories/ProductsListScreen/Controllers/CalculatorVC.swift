//
//  CalculatorVC.swift
//  MyDailyCalories
//
//  Created by VADIM FIRSOV on 25/11/2019.
//  Copyright © 2019 VADIM FIRSOV. All rights reserved.
//

import UIKit
import GoogleMobileAds

class CalculatorVC : UIViewController {
    
    private let containerSegueID = "showContainer"
    
    @IBOutlet weak var cartContainer: UIView!
    
    @IBOutlet weak var lblCalories:   UILabel!
    @IBOutlet weak var lblProtein:    UILabel!
    @IBOutlet weak var lblCarbs:      UILabel!
    @IBOutlet weak var lblFat:        UILabel!
    
    @IBOutlet weak var btn200g:       SmallBtn!
    @IBOutlet weak var btn100g:       SmallBtn!
    @IBOutlet weak var btnSpoon:      SmallBtn!
    @IBOutlet weak var btn50g:        SmallBtn!
    @IBOutlet weak var btnTableSpoon: SmallBtn!
    @IBOutlet weak var tfCustomGrams: SmallTextField! {
        didSet {
            tfCustomGrams.addTarget(self,
                                    action: #selector(textFieldDidChange(_:)),
                                    for: UIControl.Event.editingChanged)
            tfCustomGrams.delegate = self }
    }
    
    @IBOutlet weak var cartViewContainer: UIView! {
        didSet {
            cartViewContainer.isHidden = true
        }
    }
    
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet var gramBtns: [SmallBtn]!
    
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    var entity = Entity()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AdMob.shared.set(banner: bannerView, inVC: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setCalculatedLabels()
        addGestures()
        btn100g.isBtnSelected = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addToCartTapped(_ sender: UIButton) {
        loader.startAnimating()
        var cartEntity = CartEntity()
        
        cartEntity.calories = lblCalories.doubleFromText() ?? 0
        cartEntity.protein = lblProtein.doubleFromText()   ?? 0
        cartEntity.carbs = lblCarbs.doubleFromText()       ?? 0
        cartEntity.fat = lblFat.doubleFromText()           ?? 0

        cartEntity.grams = 100 * getMultiplier()
        cartEntity.name = entity.name
        Firebase.shared.save(cartEntity: cartEntity)
    }
    
    @IBAction func gramButtonTapped(_ sender: SmallBtn) {
        dismissKeyboard()
        tfCustomGrams.updateDesign()
        tfCustomGrams.resignFirstResponder()
        for btn in gramBtns {
            btn.isBtnSelected = (btn == sender)
        }
        setCalculatedLabels()
    }
    
    @IBAction func addToDailyTapped(_ sender: UIBarButtonItem) {
        let product = Product(name:     entity.name,
                              calories: lblCalories.text ?? "0.0",
                              protein:  lblProtein.text  ?? "0.0",
                              carbs:    lblCarbs.text    ?? "0.0",
                              fat:      lblFat.text      ?? "0.0")
        AlertManager.shared.showAlertShouldAdd(product: product, inVC: self)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        setCalculatedLabels()
    }
    
    private func addGestures() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                 action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    private func getMultiplier() -> Double {
        if tfCustomGrams.isEditing && tfCustomGrams.text != nil {
            return Double(tfCustomGrams.text!) ?? 1.0
        }
        else {
            return multiplierFromSelectedBtn()
        }
    }
    
    private func multiplierFromSelectedBtn() -> Double {
        for btn in gramBtns {
            if btn.isBtnSelected {
                switch btn {
                case btn100g :       return 1.0
                case btnSpoon :      return 0.15
                case btnTableSpoon : return 0.08
                case btn50g :        return 0.5
                case btn200g :       return 2.0
                default:             return 1.0
                }
            }
        }
        return 1.0
    }
    
    private func setCalculatedLabels() {
        let multiplier = getMultiplier()

        lblCalories.text = entity.calories.string(multipliedBy: multiplier)
        lblProtein.text =  entity.protein.string(multipliedBy:  multiplier)
        lblCarbs.text =    entity.carbs.string(multipliedBy:    multiplier)
        lblFat.text =      entity.fat.string(multipliedBy:      multiplier)

        self.title = entity.name
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == containerSegueID {
            if let destinationVC = segue.destination as? CartVC {
                destinationVC.delegate = self
            }
        }
    }
}

extension CalculatorVC : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        for btn in gramBtns {
            btn.isBtnSelected = false
        }
        tfCustomGrams.updateDesign()
        setCalculatedLabels()
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        tfCustomGrams.resignFirstResponder()
        tfCustomGrams.updateDesign()
        return true
    }
}

extension CalculatorVC : CartDelegate {
    func didReceive(cart: [CartEntity]) {
        loader.stopAnimating()
        cartContainer.isHidden = cart.isEmpty
    }
}

extension Double {
    func roundedString() -> String {
        let rounded = String(format: "%.1f", self)
        return rounded
    }
}

extension UILabel {
    func doubleFromText() -> Double? {
        if self.text != nil {
            return Double(self.text!)
        }
        else {
            return nil
        }
    }
}

extension String {
    func string(multipliedBy multiplier : Double) -> String {
        let double = Double(self) ?? 0.0
        let result = (double * multiplier)
        return String(format: "%.1f", result)
    }
}
