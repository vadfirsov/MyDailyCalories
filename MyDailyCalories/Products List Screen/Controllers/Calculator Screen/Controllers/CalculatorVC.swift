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
    
    private let segue_to_container =  "show_container"
    private let segue_present_intro = "present_calculator_intro"

    @IBOutlet weak var cartContainer: UIView!
    
    @IBOutlet weak var lblCalories:   UILabel!
    @IBOutlet weak var lblProtein:    UILabel!
    @IBOutlet weak var lblCarbs:      UILabel!
    @IBOutlet weak var lblFat:        UILabel!
    
    var entity = Entity()
    
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet var gramBtns: [SmallButton]!
    
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    @IBOutlet weak var btnAddToDaily:  UIBarButtonItem!
    @IBOutlet weak var btnAddToCart:   CustomButton!
    @IBOutlet weak var lblNameCals:    UILabel!
    @IBOutlet weak var lblNameProtein: UILabel!
    @IBOutlet weak var lblNameCarbs:   UILabel!
    @IBOutlet weak var lblNameFat:     UILabel!
    
    @IBOutlet weak var btn200g:       SmallButton!
    @IBOutlet weak var btn100g:       SmallButton!
    @IBOutlet weak var btnSpoon:      SmallButton!
    @IBOutlet weak var btn50g:        SmallButton!
    @IBOutlet weak var btnTableSpoon: SmallButton!
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
    
    private var isSelfVisible = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AdMob.shared.set(banner: bannerView, inVC: self)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setLocalized()
        setCalculatedLabels()
        addGestures()
        btn100g.isBtnSelected = true
        isSelfVisible = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if HintsManager.shared.shouldShowIntroInCalculator == true {
            showIntro()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        isSelfVisible = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationController?.popViewController(animated: true)
    }
    
    private func setLocalized() {
        btn50g.setTitle(locStr("50g"),       for: .normal)
        btn100g.setTitle(locStr("100g"),     for: .normal)
        btn200g.setTitle(locStr("200g"),     for: .normal)
        btnSpoon.setTitle(locStr("15g"),     for: .normal)
        btnTableSpoon.setTitle(locStr("8g"), for: .normal)
        btnAddToCart.setTitle(locStr("add_to_cart"), for: .normal)


        tfCustomGrams.placeholder = locStr("tf_custom_g")
        
        lblNameFat.text =     locStr("fat")
        lblNameCals.text =    locStr("cals")
        lblNameCarbs.text =   locStr("carbs")
        lblNameProtein.text = locStr("protein")
        
        btnAddToDaily.title = locStr("add_to_daily")
        
        btn50g.isAccessibilityElement =         true
        btn100g.isAccessibilityElement =        true
        btn200g.isAccessibilityElement =        true
        btnSpoon.isAccessibilityElement =       true
        btnTableSpoon.isAccessibilityElement =  true
        btnAddToCart.isAccessibilityElement =   true
        tfCustomGrams.isAccessibilityElement =  true
        lblNameFat.isAccessibilityElement =     true
        lblNameCals.isAccessibilityElement =    true
        lblNameProtein.isAccessibilityElement = true
        btnAddToDaily.isAccessibilityElement =  true
        lblFat.isAccessibilityElement =         true
        lblNameProtein.isAccessibilityElement = true
        lblNameCals.isAccessibilityElement =    true
        lblCarbs.isAccessibilityElement =       true
        lblCalories.isAccessibilityElement =    true
        
    }
    
    private func showIntro() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            if self.isSelfVisible {
                self.performSegue(withIdentifier: self.segue_present_intro, sender: self)
               HintsManager.shared.shouldShowIntroInCalculator = false
            }
        }
    }
    
    @IBAction func addToCartTapped(_ sender: CustomButton) {
        sender.animateTap()
        loader.startAnimating()
        sender.animateTap(bgColor: sender.animatedBgColor, borderColor: sender.animatedBorderColor)
        var cartEntity = CartEntity()
        
        cartEntity.calories = lblCalories.doubleFromText() ?? 0
        cartEntity.protein =  lblProtein.doubleFromText()  ?? 0
        cartEntity.carbs =    lblCarbs.doubleFromText()    ?? 0
        cartEntity.fat =      lblFat.doubleFromText()      ?? 0

        cartEntity.grams = 100 * getMultiplier()
        cartEntity.name = entity.name
        Firebase.shared.save(cartEntity: cartEntity)
    }
    
    @IBAction func gramButtonTapped(_ sender: SmallButton) {
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
    

    
    @objc func textFieldDidChange(_ textField: UITextField) {
        setCalculatedLabels()
    }
    
    private func addGestures() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                 action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    private func getMultiplier() -> Double {
        if tfCustomGrams.isEditing && tfCustomGrams.text != nil {
            let gramMultiplier = (Double(tfCustomGrams.text!) ?? 100) / 100
            return gramMultiplier
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
        if segue.identifier == segue_to_container {
            if let destinationVC = segue.destination as? CartVC {
                destinationVC.delegate = self
            }
        }
    }
    
    private func locStr(_ string : String) -> String {
        return NSLocalizedString("calc_" + string, comment: "")
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
    
    func noDecimelString() -> String {
        let rounded = String(format: "%f", self)
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
