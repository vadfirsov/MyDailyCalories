//
//  CalculatorIntroVC.swift
//  MyDailyCalories
//
//  Created by pionet\Alex.s on 12/12/2019.
//  Copyright © 2019 VADIM FIRSOV. All rights reserved.
//

import UIKit

class CalculatorIntroVC : UIViewController {
    
    private let segue_present_intro = "present_calculator_intro"
    
    private let addToDailyText = NSLocalizedString("calc_hint_add_to_daily", comment: "")
    private let gramsText = NSLocalizedString("calc_hint_choose_grams", comment: "")
    private let addToCartText = NSLocalizedString("calc_hint_can_calculate", comment: "")
    
    @IBOutlet weak var viewBarItem:      FocusView!
    @IBOutlet weak var viewAddToCartBtn: FocusView!
    @IBOutlet weak var viewChooseGrams:  FocusView!
    
    @IBOutlet weak var btnAddToCart: CustomButton!
    
    @IBOutlet weak var lblHintAddToDaily: UILabel!
    @IBOutlet weak var lblAddToCart:      UILabel!
    @IBOutlet weak var lblGrams:          UILabel!
    
    @IBOutlet weak var stackViewGrams: UIStackView!
    
    @IBOutlet weak var tfCustomGrams: SmallTextField!
    @IBOutlet weak var lblAddToDaily:        UILabel!
    @IBOutlet weak var btn200g: SmallButton!
    @IBOutlet weak var btn50g:  SmallButton!
    @IBOutlet weak var btn8g:   SmallButton!
    @IBOutlet weak var btn15g:  SmallButton!
    @IBOutlet weak var btn100g: SmallButton! {
        didSet { btn100g.isBtnSelected = true }
    }
    
    private var stage = 1
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
        addTapGesture()
        setLocalized()
        setAccessibilities()
    }
    
    private func setAccessibilities() {
        lblAddToDaily.isAccessibilityElement =     true
        lblAddToCart.isAccessibilityElement =      true
        btn200g.isAccessibilityElement =           true
        btn100g.isAccessibilityElement =           true
        btn50g.isAccessibilityElement =            true
        btn8g.isAccessibilityElement =             true
        btn15g.isAccessibilityElement =            true
        btnAddToCart.isAccessibilityElement =      true
        lblHintAddToDaily.isAccessibilityElement = true
        lblGrams.isAccessibilityElement =          true
        lblAddToCart.isAccessibilityElement =      true
    }
    
    private func setLocalized() {
        
        lblAddToDaily.text = locStr("btn_add_to_daily")
        btn200g.setTitle(locStr("200g"), for: .normal)
        btn100g.setTitle(locStr("100g"), for: .normal)
        btn50g.setTitle(locStr("50g"),   for: .normal)
        btn15g.setTitle(locStr("15g"),   for: .normal)
        btn8g.setTitle(locStr("8g"),     for: .normal)
        btnAddToCart.setTitle(locStr("add_to_cart"), for: .normal)
        tfCustomGrams.placeholder = locStr("custom_g")
        
        set(label: lblHintAddToDaily, text: addToDailyText)
        set(label: lblGrams,          text: gramsText)
        set(label: lblAddToCart,      text: addToCartText)
    }
    
    
    private func addTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tappedOnScreen))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc private func tappedOnScreen() {
        
        updateView()
    }
    
    private func updateView() {
        setViewDefault()
        switch stage {
        case 1:
            stackViewGrams.isHidden =   true
            btnAddToCart.isHidden =     true
            viewBarItem.isHidden =      false
            viewChooseGrams.isHidden =  true
            viewAddToCartBtn.isHidden = true
            lblAddToCart.isHidden =     true
            lblGrams.isHidden =         true
            animate(view: viewBarItem)

        case 2:
            stackViewGrams.isHidden =   false
            btnAddToCart.isHidden =     true
            viewBarItem.isHidden =      true
            viewChooseGrams.isHidden =  false
            viewAddToCartBtn.isHidden = true
            lblGrams.isHidden =         false
            lblHintAddToDaily.isHidden =    true
            animate(view: viewChooseGrams)
            borderAnimation(onView: viewChooseGrams)
            
        case 3:
            stackViewGrams.isHidden =   true
            btnAddToCart.isHidden =     false
            viewBarItem.isHidden =      true
            viewChooseGrams.isHidden =  true
            viewAddToCartBtn.isHidden = false
            lblAddToCart.isHidden =     false
            lblGrams.isHidden =         true
            animate(view: viewAddToCartBtn)
            borderAnimation(onView: viewAddToCartBtn)
        default:
            self.dismiss(animated: true, completion: nil)
        }
        stage += 1
    }
    
    private func setViewDefault() {
        viewBarItem.layer.borderColor =      #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        viewBarItem.backgroundColor =        #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.7506421233)
        viewChooseGrams.layer.borderColor =  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        viewChooseGrams.backgroundColor =    #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.7506421233)
        viewAddToCartBtn.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        viewAddToCartBtn.backgroundColor =   #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.7506421233)
    }
    
    private func animate(view : UIView) {
        view.layer.borderColor = #colorLiteral(red: 1, green: 0.6096229553, blue: 0, alpha: 1)
        UIView.animate(withDuration: 0.3) {
            view.backgroundColor =   #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        }
    }
    
    private func borderAnimation(onView view : UIView) {
        let color = CABasicAnimation(keyPath: "borderColor")
        color.fromValue = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        color.toValue = #colorLiteral(red: 1, green: 0.6096229553, blue: 0, alpha: 1)
        color.duration = 0.3
        color.repeatCount = 1
        view.layer.add(color, forKey: "borderColor")
    }
    
    private func set(label : UILabel, text : String) {
        let attributedString = NSMutableAttributedString(string: text)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle,
                                      value:paragraphStyle,
                                      range:NSMakeRange(0, attributedString.length))
        label.attributedText = attributedString
        label.textAlignment = .center
    }
    
    private func locStr(_ string : String) -> String {
        return NSLocalizedString("calc_hint_" + string, comment: "")
    }
    
    
}
