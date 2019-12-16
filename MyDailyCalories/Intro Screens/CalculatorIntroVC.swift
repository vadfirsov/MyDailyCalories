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
    
    private let addToDailyText = "Tap to add the product to your daily calories 🤓"
    private let gramsText = "Tap to choose how many grams you would like to calculate 🤓"
    private let addToCartText = "You can add products to your \"Cart\" to calculate multile ingredients at once 🤓"
    
    @IBOutlet weak var viewBarItem:      FocusView!
    @IBOutlet weak var viewAddToCartBtn: FocusView!
    @IBOutlet weak var viewChooseGrams:  FocusView!
    
    @IBOutlet weak var btnAddToCart: CustomButton!
    
    
    @IBOutlet weak var btn100g: SmallButton! {
        didSet { btn100g.isBtnSelected = true }
    }
    
    @IBOutlet weak var lblAddToDaily:        UILabel!
    @IBOutlet weak var lblAddToCart:         UILabel!
    @IBOutlet weak var lblGrams:             UILabel!
    
    @IBOutlet weak var stackViewGrams: UIStackView!
    
    private var stage = 1
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
        addTapGesture()
        
        set(label: lblAddToDaily, text: addToDailyText)
        set(label: lblGrams, text: gramsText)
        set(label: lblAddToCart, text: addToCartText)


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
            lblAddToDaily.isHidden =    true
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
}
