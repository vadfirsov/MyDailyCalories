//
//  NewProductVC.swift
//  MyDailyCalories
//
//  Created by VADIM FIRSOV on 25/11/2019.
//  Copyright © 2019 VADIM FIRSOV. All rights reserved.
//

import UIKit
import GoogleMobileAds

class NewProductVC : UIViewController {
    
    @IBOutlet weak var tfCalories: UITextField!
    @IBOutlet weak var tfCarbs:    UITextField!
    @IBOutlet weak var tfProtein:  UITextField!
    @IBOutlet weak var tfFat:      UITextField!
    @IBOutlet weak var tfName:     UITextField! {
        didSet { tfName.becomeFirstResponder() }
    }

    @IBOutlet weak var bannerView: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AdMob.shared.set(banner: bannerView, inVC: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        bannerView = nil 
    }
       
    @IBOutlet var textFields: [UITextField]! {
        didSet {
            for tf in textFields { tf.delegate = self }
        }
    }
    
    @IBAction func saveTapped(_ sender: UIBarButtonItem) {
        var product = Product(name:     tfName.text     ?? "",
                              calories: tfCalories.text ?? "",
                              protein:  tfProtein.text  ?? "",
                              carbs:    tfCarbs.text    ?? "",
                              fat:      tfFat.text      ?? "")
        product.dateString = DateManager.shared.stringFrom(date: Date())
        Firebase.shared.saveNew(product: product)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func goToProducts(_ sender: CustomButton) {
        let indexOfProductsTab = 1
        tabBarController?.selectedIndex = indexOfProductsTab
    }
    
    private func moveToNextTF() {
        
        for i in textFields.indices {
            if textFields[i].isFirstResponder {
                let index = textFields[i] == textFields.last ? 0 : i + 1
                textFields[index].becomeFirstResponder()
                return
            }
        }
    }
}

extension NewProductVC : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        moveToNextTF()
        return true
    }
}
