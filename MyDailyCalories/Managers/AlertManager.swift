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
    
    let cancel = UIAlertAction(title: NSLocalizedString("alert_cancel", comment: ""), style: .default, handler: nil)
    
    private func messageRemove(entityName : String) -> String {
        return NSLocalizedString("alert_remove_entity", comment: "") + "\(entityName)"
    }
    
    private func locStr(_ string : String) -> String {
        return NSLocalizedString("alert_" + string, comment: "")
    }
    
    func showAlertDeleteProduct(inVC vc : UIViewController, product : Product, index : Int) {
        
        let alert = UIAlertController(title: locStr("uh_oh"),
                                      message: messageRemove(entityName: product.name),
                                      preferredStyle: .alert)
        let ok = UIAlertAction(title: locStr("ok"), style: .default) { (action) in
            Firebase.shared.delete(product: product)
            
        }
        alert.addAction(cancel)
        alert.addAction(ok)
        vc.present(alert, animated: true, completion: nil)
    }
    
    func showAlertSetMaxDailyCalories(inVC vc : UIViewController) {
        let alert = UIAlertController(title: nil,
                                      message: NSLocalizedString("alert_insert_calorie_goal", comment: ""),
                                      preferredStyle: .alert)
        let ok = UIAlertAction(title: locStr("ok"), style: .default) { (action) in

            if let inputText = Int(alert.textFields?.first?.text ?? "n") {
                Firebase.shared.save(dailyCaloriesGoal: "\(inputText)")
            }
            else {
                self.showAlertNumbersOnly(inVC: vc)
            }
            
        }
        alert.addAction(cancel)
        alert.addAction(ok)
        alert.isAccessibilityElement = true

        alert.addTextField { (tf) in
            tf.placeholder = NSLocalizedString("alert_num_only", comment: "")
            tf.autocapitalizationType = .words
        }
        
        vc.present(alert, animated: true, completion: nil)
    }
    
    func showAlertDeleteEntity(inVC vc : UIViewController, entity : Entity, index : Int) {
        
        let alert = UIAlertController(title: NSLocalizedString("alert_uh_oh", comment: ""),
                                      message: messageRemove(entityName: entity.name),
                                      preferredStyle: .alert)
        let ok = UIAlertAction(title: locStr("ok"), style: .default) { (action) in
            Firebase.shared.delete(entity: entity)
        }
        alert.isAccessibilityElement = true

        alert.addAction(cancel)
        alert.addAction(ok)
        vc.present(alert, animated: true, completion: nil)
    }
    
    func showAlertEmptyCart(inVC vc : UIViewController) {
        let alert = UIAlertController(title: NSLocalizedString("alert_empty_cart", comment: ""),
                                      message: nil,
                                      preferredStyle: .alert)
        let ok = UIAlertAction(title: locStr("ok"), style: .default) { (action) in
            Firebase.shared.deleteCart()
        }
        alert.isAccessibilityElement = true
        alert.addAction(cancel)
        alert.addAction(ok)
        vc.present(alert, animated: true, completion: nil)
    }
    
    func showAlertChooseServings(inVC vc : UIViewController) {
        let alert = UIAlertController(title: NSLocalizedString("alert_servings", comment: ""), message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: locStr("ok"), style: .default) { (action) in
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
        alert.isAccessibilityElement = true
        alert.addTextField { (tf) in
            tf.placeholder = "Digits Only"
            tf.autocapitalizationType = .words
        }
        alert.addAction(ok)
        vc.present(alert, animated: true, completion: nil)
    }
    
    func showAlertShouldAdd(product : Product, inVC vc : UIViewController) {
        let alert = UIAlertController(title: locStr("add_daily_cals"), message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: locStr("ok"), style: .default) { (_) in
            Firebase.shared.saveNew(product: product)
        }
        alert.isAccessibilityElement = true
        alert.addAction(cancel)
        alert.addAction(ok)
        vc.present(alert, animated: true, completion: nil)

    }
    
    func showAlertDeleteCartEntity(inVC vc : UIViewController, entity : CartEntity) {
        
        let alert = UIAlertController(title: locStr("uh_oh"),
                                      message: messageRemove(entityName: entity.name),
                                      preferredStyle: .alert)
        let ok = UIAlertAction(title: locStr("ok"), style: .default) { (action) in
            Firebase.shared.delete(cartEntity: entity)            
        }
        alert.isAccessibilityElement = true
        alert.addAction(cancel)
        alert.addAction(ok)
        vc.present(alert, animated: true, completion: nil)
    }
    
    func showAlertProductSaved(inVC vc : UIViewController) {
        let alert = UIAlertController(title: locStr("yey"), message: locStr("product_saved"), preferredStyle: .alert)
        let ok = UIAlertAction(title: locStr("ok"), style: .default, handler: nil)
        alert.addAction(ok)
        vc.present(alert, animated: true, completion: nil)
    }
    
    func showAlertAddToDailyWithName(inVC vc : UIViewController, product : Product) {
        let alert = UIAlertController(title: locStr("choose_name"), message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: locStr("ok"), style: .default) { (_) in
            if alert.textFields?[0] != nil {
                if !(alert.textFields?[0].text?.isEmpty ?? true) {
                    var newProduct = product
                    newProduct.name = alert.textFields![0].text ?? self.locStr("no_name")
                    Firebase.shared.saveNew(product: newProduct)
                }
                else {
                    self.showAlertProductNameCantBeEmpty(inVC: vc)
                }
            }
        }
        alert.isAccessibilityElement = true
        alert.addTextField { (tf) in
            tf.placeholder = self.locStr("product_name")
            tf.autocapitalizationType = .words
        }
        alert.addAction(cancel)
        alert.addAction(ok)
        vc.present(alert, animated: true, completion: nil)
    }
    
    func showAlertAddToMyProducts(inVC vc : UIViewController, food: Entity) {
        let alert = UIAlertController(title: nil, message: locStr("add") + food.name + locStr("to_my_products"), preferredStyle: .alert)

        let ok = UIAlertAction(title: locStr("ok"), style: .default) { (_) in
            Firebase.shared.saveNew(entity: food)
        }
        alert.isAccessibilityElement = true
        alert.addAction(cancel)
        alert.addAction(ok)
        vc.present(alert, animated: true, completion: nil)
    }
    
    func showAlertFoodAddedToMyProducts(inVC vc : UIViewController) {
        let alert = UIAlertController(title: locStr("food_added"), message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: locStr("ok"), style: .default, handler: nil)
        alert.isAccessibilityElement = true
        alert.addAction(ok)
        alert.isAccessibilityElement = true
        vc.present(alert, animated: true, completion: nil)
    }
    
    func showAlertWithError(inVC vc : UIViewController, message : String) {
        let alert = UIAlertController(title: locStr("uh_oh"), message: message, preferredStyle: .alert)
        alert.addAction(cancel)
        alert.isAccessibilityElement = true
        vc.present(alert, animated: true, completion: nil)
    }
    
    func showAlertAddAllFood(inVC vc : UIViewController, foods : [Entity]) {
        let alert = UIAlertController(title: nil, message: locStr("about_to_add_all_to"), preferredStyle: .alert)
        let ok = UIAlertAction(title: locStr("ok"), style: .default) { (_) in
            Firebase.shared.saveFoodsAd(entities: foods)
        }
        alert.addAction(cancel)
        alert.addAction(ok)
        alert.isAccessibilityElement = true
        vc.present(alert, animated: true, completion: nil)
    }
    
    func showAlertGenericMessage(inVC vc : UIViewController, message : String) {
        let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: locStr("ok"), style: .default)
        alert.addAction(ok)
        alert.isAccessibilityElement = true
        vc.present(alert, animated: true, completion: nil)
    }
    
    private func showAlertNumbersOnly(inVC vc : UIViewController) {
        let alert = UIAlertController(title: locStr("only_nums"), message: nil, preferredStyle: .alert)
        alert.addAction(cancel)
        alert.isAccessibilityElement = true
        vc.present(alert, animated: true, completion: nil)
    }
    
    private func showAlertProductNameCantBeEmpty(inVC vc : UIViewController) {
        let alert = UIAlertController(title: locStr("product_name_cant_empty"), message: nil, preferredStyle: .alert)
        alert.addAction(cancel)
        alert.isAccessibilityElement = true
        vc.present(alert, animated: true, completion: nil)
    }
    
}
