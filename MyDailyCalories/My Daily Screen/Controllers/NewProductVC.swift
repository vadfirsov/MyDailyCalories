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
    
    @IBOutlet weak var lblWhatAte:  UILabel!
    @IBOutlet weak var lblCalories: UILabel!
    @IBOutlet weak var lblCarbs:    UILabel!
    @IBOutlet weak var lblProtein:  UILabel!
    @IBOutlet weak var lblFat:      UILabel!
    @IBOutlet weak var btnChooseFromList: CustomButton!
    @IBOutlet weak var btnSave:           UIBarButtonItem!
    @IBOutlet weak var bannerView:        GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AdMob.shared.set(banner: bannerView, inVC: self)
        setLocalized()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        bannerView = nil 
    }
    
    private func setLocalized() {
        lblWhatAte.text =  locStr("what_eat")
        lblCalories.text = locStr("calories")
        lblCarbs.text =    locStr("carbs")
        lblProtein.text =  locStr("protein")
        lblFat.text =      locStr("fat")
        btnSave.title =    locStr("save")
        btnChooseFromList.setTitle(locStr("choose"), for: .normal)
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
        sender.animateTap()
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
    
    private func locStr(_ string : String) -> String {
        return NSLocalizedString("new_daily_" + string, comment: "")
    }
}

extension NewProductVC : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        moveToNextTF()
        return true
    }
}

