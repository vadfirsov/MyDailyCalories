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
    
    @IBOutlet weak var btnLoadProducts:  CustomButton!
    @IBOutlet weak var btnAddNewProduct: CustomButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLabel()
        addTapGesture()
    }

    private func setLabel() {
        let localizedString = NSLocalizedString("hint_pssst", comment: "")
        let attributedString = NSMutableAttributedString(string: localizedString)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle,
                                      value:paragraphStyle,
                                      range:NSMakeRange(0, attributedString.length))
        lblMessage.attributedText = attributedString
        lblMessage.textAlignment = .center
    }
    
    @IBAction func loadProductsTapped(_ sender: CustomButton) {
        sender.animateTap()
        Firebase.shared.loadFoods()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addnewTapped(_ sender: CustomButton) {
        sender.animateTap()
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

