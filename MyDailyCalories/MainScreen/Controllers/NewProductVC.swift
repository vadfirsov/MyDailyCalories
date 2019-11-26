//
//  NewProductVC.swift
//  MyDailyCalories
//
//  Created by VADIM FIRSOV on 25/11/2019.
//  Copyright © 2019 VADIM FIRSOV. All rights reserved.
//

import UIKit

class NewProductVC : UIViewController {
    
    private var date = Date()
    
    @IBOutlet weak var tfCalories: UITextField!
    @IBOutlet weak var tfCarbs:    UITextField!
    @IBOutlet weak var tfProtein:  UITextField!
    @IBOutlet weak var tfFat:      UITextField!
    @IBOutlet weak var tfName:     UITextField! {
        didSet { tfName.becomeFirstResponder() }
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
        product.dateString = DateManager.shared.stringFrom(date: date)
        FirebaseManager.shared.saveNew(product: product)
        self.navigationController?.popViewController(animated: true)
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
}

extension NewProductVC : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        moveToNextTF()
        return true
    }
}

