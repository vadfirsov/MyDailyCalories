//
//  IntroVC.swift
//  MyDailyCalories
//
//  Created by pionet\Alex.s on 09/12/2019.
//  Copyright © 2019 VADIM FIRSOV. All rights reserved.
//

import UIKit

protocol MyProductsIntroDelegate {
    func didTapAddNew()
}

class MyProductsIntroVC : UIViewController {
        
    var delegate : MyProductsIntroDelegate?
    
    @IBOutlet weak var lblMessage: UILabel!
    
    @IBOutlet weak var btnLoadProducts:  CustomParentButton!
    @IBOutlet weak var btnAddNewProduct: CustomParentButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLabel()
        setStyleFor(btn: btnLoadProducts)
        setStyleFor(btn: btnAddNewProduct)
        addTapGesture()
    }
    
    private func setLabel() {
        let attributedString = NSMutableAttributedString(string: "Pssst!.. \n Here you can load ready-to-use products or add your own products that you use daily! \n *You can always go back to Settings and add / remove ready-to-use products 🤓")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle,
                                      value:paragraphStyle,
                                      range:NSMakeRange(0, attributedString.length))
        lblMessage.attributedText = attributedString
        lblMessage.textAlignment = .center
    }
    
    private func setStyleFor(btn : CustomParentButton) {
        btn.layer.borderWidth = 1.25
        btn.layer.borderColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        btn.backgroundColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
    }
    
    @IBAction func loadProductsTapped(_ sender: CustomParentButton) {
        Firebase.shared.loadFoods()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addnewTapped(_ sender: CustomParentButton) {
        self.dismiss(animated: true) {
            self.delegate?.didTapAddNew()
        }
    }
    
    private func addTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tappedOnScreen))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc private func tappedOnScreen() {
        self.dismiss(animated: true, completion: nil)
    }
}

