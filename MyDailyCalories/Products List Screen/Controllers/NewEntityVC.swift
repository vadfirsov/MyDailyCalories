//
//  NewEntity.swift
//  MyDailyCalories
//
//  Created by VADIM FIRSOV on 25/11/2019.
//  Copyright © 2019 VADIM FIRSOV. All rights reserved.
//

import UIKit
import GoogleMobileAds

class NewEntityVC : UIViewController {
    

    @IBOutlet weak var tfCalories: UITextField!
    @IBOutlet weak var tfCarbs:    UITextField!
    @IBOutlet weak var tfProtein:  UITextField!
    @IBOutlet weak var tfFat:      UITextField!
    @IBOutlet weak var tfName:     UITextField! {
        didSet { tfName.becomeFirstResponder() }
    }
    
    @IBOutlet weak var btnSave: UIBarButtonItem!
    
    @IBOutlet weak var lblName:    UILabel!
    @IBOutlet weak var lblCals:    UILabel!
    @IBOutlet weak var lblCarbs:   UILabel!
    @IBOutlet weak var lblProtein: UILabel!
    @IBOutlet weak var lblFat:     UILabel!
    
    @IBOutlet var textFields: [UITextField]! 
    
    @IBOutlet weak var bannerView: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLocalized()
    }
    
    private func setLocalized() {

        lblName.text =    locStr("name")
        lblCarbs.text =   locStr("carbs")
        lblCals.text =    locStr("calories")
        lblProtein.text = locStr("protein")
        lblFat.text =     locStr("fat")
        btnSave.title =   locStr("save")
        
        lblName.isAccessibilityElement =    true
        lblCarbs.isAccessibilityElement =   true
        lblCals.isAccessibilityElement =    true
        lblProtein.isAccessibilityElement = true
        lblFat.isAccessibilityElement =     true
        btnSave.isAccessibilityElement =    true
        
        tfCalories.isAccessibilityElement = true
        tfCarbs.isAccessibilityElement =    true
        tfProtein.isAccessibilityElement =  true
        tfFat.isAccessibilityElement =      true
        tfName.isAccessibilityElement =     true
        
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
    
    @IBAction func saveTapped(_ sender: UIBarButtonItem) {
        let entity = Entity(name:     tfName.text     ?? "",
                            calories: tfCalories.text ?? "",
                            protein:  tfProtein.text  ?? "",
                            carbs:    tfCarbs.text    ?? "",
                            fat:      tfFat.text      ?? "")
        Firebase.shared.saveNew(entity: entity)
        self.navigationController?.popViewController(animated: true)
    }
    
    
    private func locStr(_ string : String) -> String {
        return NSLocalizedString("new_food_" + string, comment: "")
    }
}

extension NewEntityVC : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        moveToNextTF()
        return true
    }
}
