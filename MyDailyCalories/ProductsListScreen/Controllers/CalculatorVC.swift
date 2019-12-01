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
    
    @IBOutlet weak var btn100g:  UIButton!
    @IBOutlet weak var btnSpoon: UIButton!
    
    @IBOutlet weak var btnTableSpoon: UIButton!
    @IBOutlet weak var tfCustomGrams: UITextField! {
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
    @IBOutlet var gramBtns: [UIButton]!
    
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    private let colorForSelected = #colorLiteral(red: 0, green: 0.7965348363, blue: 0.2799595892, alpha: 1)
    private let colorForDiselected = #colorLiteral(red: 0.5797533989, green: 0.8102962375, blue: 0.7939001322, alpha: 0.194723887)
    
    var entity = Entity()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AdMobManager.shared.set(banner: bannerView, inVC: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setCalculatedLabels()
        addGestures()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addToCartTapped(_ sender: UIButton) {
        loader.startAnimating()
        var cartEntity = CartEntity()
        if let calories = Double(lblCalories.text ?? "0") {
            cartEntity.calories = calories
        }
        if let protein = Double(lblProtein.text ?? "0") {
            cartEntity.protein = protein
        }
        if let carbs = Double(lblCarbs.text ?? "0") {
            cartEntity.carbs = carbs
        }
        if let fat = Double(lblFat.text ?? "0") {
            cartEntity.fat = fat
        }
        cartEntity.grams = 100 * getMultiplier()
        cartEntity.name = entity.name
        FirebaseManager.shared.save(cartEntity: cartEntity)
    }
    
    @IBAction func gramButtonTapped(_ sender: UIButton) {
        dismissKeyboard()
        tfCustomGrams.backgroundColor = colorForDiselected
        for btn in gramBtns {
            if btn == sender {
                btn.backgroundColor = colorForSelected
            }
            else {
                btn.backgroundColor = colorForDiselected
            }
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
        var multiplier = 1.0
        if tfCustomGrams.backgroundColor == colorForSelected && tfCustomGrams.text != nil {
            if let doubleFromTF = Double(tfCustomGrams.text!) {
                multiplier = doubleFromTF
            }
        }
        else {
            for btn in gramBtns {
                if btn.backgroundColor == colorForSelected {
                    switch btn {
                    case btn100g :       multiplier = 1.0
                    case btnSpoon :      multiplier = 0.15
                    case btnTableSpoon : multiplier = 0.08
                    default:             multiplier = 1.0
                    }
                }
            }
        }
        return multiplier
    }
    
    private func setCalculatedLabels() {
        let multiplier = getMultiplier()
        if let calories = Double(entity.calories) {
            lblCalories.text = (calories * multiplier).roundedString()
        }
        if let protein = Double(entity.protein) {
            lblProtein.text = (protein * multiplier).roundedString()
        }
        if let carbs = Double(entity.carbs) {
            lblCarbs.text = (carbs * multiplier).roundedString()
        }
        if let fat = Double(entity.fat) {
            lblFat.text = (fat * multiplier).roundedString()
        }
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
            btn.backgroundColor = colorForDiselected
        }
        tfCustomGrams.backgroundColor = colorForSelected
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension Double {
    func roundedString() -> String {
        let rounded = String(format: "%.1f", self)
        return rounded
    }
}

extension CalculatorVC : CartDelegate {
    func didReceive(cart: [CartEntity]) {
        loader.stopAnimating()
        cartContainer.isHidden = cart.isEmpty
    }
}
