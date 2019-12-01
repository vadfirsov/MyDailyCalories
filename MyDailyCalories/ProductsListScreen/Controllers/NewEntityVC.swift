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
    
    @IBOutlet var textFields: [UITextField]! {
        didSet {
//            for tf in textFields { tf.delegate = self }
        }
    }
    
    @IBOutlet weak var bannerView: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        AdMobManager.shared.set(banner: bannerView, inVC: self)
    }
    
    private func moveToNextTF() {
        for i in textFields.indices {
            if textFields[i].isFirstResponder {
                if textFields[i] == textFields.last {
                    textFields[0].becomeFirstResponder()
                }
                else {
                    textFields[i+1].becomeFirstResponder()
                }
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
        FirebaseManager.shared.saveNew(entity: entity)
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension NewEntityVC : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        moveToNextTF()
        return true
    }
}
