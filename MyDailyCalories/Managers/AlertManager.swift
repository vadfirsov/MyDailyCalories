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
        
        let alert = UIAlertController(title: "Yo man",
                                      message: "You gonna delete entity <\(product.name)> yes!?",
                                      preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { (action) in
            FirebaseManager.shared.delete(product: product)
            
        }
        alert.addAction(cancel)
        alert.addAction(ok)
        vc.present(alert, animated: true, completion: nil)
    }
    
    func showAlertSetMaxDailyCalories(inVC vc : UIViewController) {
        let alert = UIAlertController(title: "Yo man",
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
            tf.placeholder = "Numbers Only !"
        }
        
        vc.present(alert, animated: true, completion: nil)
    }
    
    func showAddNewEntity(inVC vc : UIViewController) {
        let alert = UIAlertController(title: "New Entity",
        message: nil,
        preferredStyle: .alert)
        alert.addTextField { (tf) in
            tf.placeholder = "Entity Name"
        }
        alert.addTextField { (tf) in
            tf.placeholder = "Calories"
        }
        alert.addTextField { (tf) in
            tf.placeholder = "Protein"
        }
        alert.addTextField { (tf) in
            tf.placeholder = "Carbs"
        }
        alert.addTextField { (tf) in
            tf.placeholder = "Fats"
        }
        let ok = UIAlertAction(title: "OK", style: .default) { (action) in
            
            if let entity = self.entityFrom(textFields: alert.textFields) {
                FirebaseManager.shared.saveNew(entity: entity)
                //check if values empty
            }
            else {
                // show alert
            }
        }
        alert.addAction(cancel)
        alert.addAction(ok)
        vc.present(alert, animated: true, completion: nil)
    }
    
    func showAlertDeleteEntity(inVC vc : UIViewController, entity : Entity, index : Int) {
        
        let alert = UIAlertController(title: "Yo man",
                                      message: "You gonna delete entity \(entity.name) yes!?",
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
                self.delegate?.servingsUpdated(servings: servings)
            }
            else {
                self.showAlertNumbersOnly(inVC: vc)
            }
        }
        alert.addTextField { (tf) in
            tf.placeholder = "Digits Only"
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
    
    func showAlertProductSaved(inVC vc : UIViewController) {
        let alert = UIAlertController(title: "Yey!", message: "Product Saved Successfully :)", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        vc.present(alert, animated: true, completion: nil)
    }
    
    private func entityFrom(textFields: [UITextField]?) -> Entity? {
        if let tfs = textFields {
            var newEntity = Entity()
            for tf in tfs {
                switch tf.placeholder {
                case "Entity Name" : newEntity.name = tf.text     ?? "No Value"
                case "Calories" :    newEntity.calories = tf.text ?? "No Value"
                case "Protein" :     newEntity.protein = tf.text  ?? "No Value"
                case "Carbs" :       newEntity.carbs = tf.text    ?? "No Value"
                case "Fats" :        newEntity.fat = tf.text      ?? "No Value"
                default: break;
                }
            }
            return newEntity
        }
        return nil
    }
    
    private func showAlertNumbersOnly(inVC vc : UIViewController) {
        let alert = UIAlertController(title: "Please Use Only Numbers!", message: nil, preferredStyle: .alert)
        alert.addAction(cancel)
        vc.present(alert, animated: true, completion: nil)
    }
}
