//
//  AlertManager.swift
//  MyDailyCalories
//
//  Created by VADIM FIRSOV on 21/11/2019.
//  Copyright © 2019 VADIM FIRSOV. All rights reserved.
//

import UIKit

protocol AlertDelegate {
    func newCalorieDailyGoalSet(calorieGoal : String)
    func servingsUpdated(servings : Double)
}

extension AlertDelegate {
    func newCalorieDailyGoalSet(calorieGoal : String) {}
    func servingsUpdated(servings : Double) {}
}

class AlertManager {
    
    static let shared = AlertManager()
    private init() {}
    
    var delegate : AlertDelegate?
    
    let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)

    func showAlertDeleteProduct(inVC vc : UIViewController, product : Product, index : Int) {
        
        let alert = UIAlertController(title: "Uh-Oh!",
                                      message: "You are about to delete entity: \(product.name)",
                                      preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { (action) in
            FirebaseManager.shared.delete(product: product)
            
        }
        alert.addAction(cancel)
        alert.addAction(ok)
        vc.present(alert, animated: true, completion: nil)
    }
    
    func showAlertSetMaxDailyCalories(inVC vc : UIViewController) {
        let alert = UIAlertController(title: nil,
                                      message: "Please Insert Your Daily Calories Goal",
                                      preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { (action) in

            if let inputText = Int(alert.textFields?.first?.text ?? "n") {
                FirebaseManager.shared.save(dailyCaloriesGoal: "\(inputText)")
            }
            else {
                self.showAlertNumbersOnly(inVC: vc)
            }
            
        }
        alert.addAction(cancel)
        alert.addAction(ok)
        
        alert.addTextField { (tf) in
            tf.placeholder = "Numbers Only!"
            tf.autocapitalizationType = .words
        }
        
        vc.present(alert, animated: true, completion: nil)
    }
    
    func showAlertDeleteEntity(inVC vc : UIViewController, entity : Entity, index : Int) {
        
        let alert = UIAlertController(title: "Uh-Oh!",
                                      message: "You are about to delete entity: \(entity.name)",
                                      preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { (action) in
            FirebaseManager.shared.delete(entity: entity)
        }
        alert.addAction(cancel)
        alert.addAction(ok)
        vc.present(alert, animated: true, completion: nil)
    }
    
    func showAlertEmptyCart(inVC vc : UIViewController) {
        let alert = UIAlertController(title: "Empty Cart?",
                                      message: nil,
                                      preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { (action) in
            FirebaseManager.shared.deleteCart()
        }
        alert.addAction(cancel)
        alert.addAction(ok)
        vc.present(alert, animated: true, completion: nil)
    }
    
    func showAlertChooseServings(inVC vc : UIViewController) {
        let alert = UIAlertController(title: "Servings", message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { (action) in
            if let servings = Double(alert.textFields![0].text ?? "1") {
                if vc is CartVC {
                    self.delegate = vc as! CartVC
                    self.delegate?.servingsUpdated(servings: servings)
                }
            }
            else {
                self.showAlertNumbersOnly(inVC: vc)
            }
        }
        alert.addTextField { (tf) in
            tf.placeholder = "Digits Only"
            tf.autocapitalizationType = .words
        }
        alert.addAction(ok)
        vc.present(alert, animated: true, completion: nil)
    }
    
    func showAlertShouldAdd(product : Product, inVC vc : UIViewController) {
        let alert = UIAlertController(title: "Add To Daily Calories?", message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { (_) in
            FirebaseManager.shared.saveNew(product: product)
        }
        alert.addAction(cancel)
        alert.addAction(ok)
        vc.present(alert, animated: true, completion: nil)

    }
    
    func showAlertDeleteCartEntity(inVC vc : UIViewController, entity : CartEntity) {
        
        let alert = UIAlertController(title: "Uh-Oh!",
                                      message: "You are about to delete entity: \(entity.name)",
                                      preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { (action) in
            FirebaseManager.shared.delete(cartEntity: entity)            
        }
        alert.addAction(cancel)
        alert.addAction(ok)
        vc.present(alert, animated: true, completion: nil)
    }
    
    func showAlertProductSaved(inVC vc : UIViewController) {
        let alert = UIAlertController(title: "Yippee Ki-Yay", message: "Product Saved Successfully", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        vc.present(alert, animated: true, completion: nil)
    }
    
    func showAlertAddToDailyWithName(inVC vc : UIViewController, product : Product) {
        let alert = UIAlertController(title: "Choose Name", message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { (_) in
            if alert.textFields?[0] != nil {
                if !(alert.textFields?[0].text?.isEmpty ?? true) {
                    var newProduct = product
                    newProduct.name = alert.textFields![0].text ?? "No Name"
                    FirebaseManager.shared.saveNew(product: newProduct)
                }
                else {
                    self.showAlertProductNameCantBeEmpty(inVC: vc)
                }
            }
            
        }
        alert.addTextField { (tf) in
            tf.placeholder = "Product Name"
            tf.autocapitalizationType = .words
        }
        alert.addAction(cancel)
        alert.addAction(ok)
        vc.present(alert, animated: true, completion: nil)
    }
    
    func showAlertWithAuthError(inVC vc : UIViewController, message : String) {
        let alert = UIAlertController(title: "Uh-Oh!", message: message, preferredStyle: .alert)
        alert.addAction(cancel)
        vc.present(alert, animated: true, completion: nil)
    }
    
    private func showAlertNumbersOnly(inVC vc : UIViewController) {
        let alert = UIAlertController(title: "Please Use Only Numbers!", message: nil, preferredStyle: .alert)
        alert.addAction(cancel)
        vc.present(alert, animated: true, completion: nil)
    }
    
    private func showAlertProductNameCantBeEmpty(inVC vc : UIViewController) {
        let alert = UIAlertController(title: "Product Name Can't Be Empty", message: nil, preferredStyle: .alert)
        alert.addAction(cancel)
        vc.present(alert, animated: true, completion: nil)
    }
}
