//
//  FirebaseManager.swift
//  MyDailyCalories
//
//  Created by VADIM FIRSOV on 21/11/2019.
//  Copyright © 2019 VADIM FIRSOV. All rights reserved.
//

import Foundation
import FirebaseDatabase

protocol FirebaseDelegate {
    func didReceived(products : [Product])
    func newDailyCalorieGoalSet(calorieGoal : String)
    func didReceive(entities : [Entity])
    func didReceive(cart : [CartEntity])
}

extension FirebaseDelegate {
    func didReceived(products : [Product]) {}
    func newDailyCalorieGoalSet(calorieGoal : String) {}
    func didReceive(entities : [Entity]) {}
    func didReceive(cart : [CartEntity]) {}
}

class FirebaseManager {
    
    static let shared = FirebaseManager()
    private init() { }
    
    var delegate : FirebaseDelegate?
    private let ref = Database.database().reference()
    
    private let my_user =             "my_user"
    private let daily_calories_goal = "daily_calories_goal"
    private let my_entities =         "my_entities"
    private let cart =                "cart"
    
    //MARK: SAVE
    func saveNew(product : Product) {
        let fullDate = "\(product.date)"

        
        ref.child(my_user).child(product.dateString).child(fullDate).setValue(product.productDict()) { (error, ref) in
            if error != nil { print(error!.localizedDescription) }
            else { self.loadProductsFrom(dateString: product.dateString) }
        }
    }
    
    func save(dailyCaloriesGoal : String) {
        ref.child(my_user).child(daily_calories_goal).setValue(dailyCaloriesGoal) { (error, ref) in
            if error == nil {
                self.delegate?.newDailyCalorieGoalSet(calorieGoal: dailyCaloriesGoal)
            }
        }
    }
    
    func save(cartEntity : CartEntity) {
        ref.child(my_user).child(cart).child(cartEntity.name).setValue(cartEntity.cartEntityDic()) { (error, ref) in
            if error != nil {
                print(error!.localizedDescription)
            }
            self.loadCart()
        }
    }
    
    func saveNew(entity : Entity) {
        
        ref.child(my_user).child(my_entities).child(entity.name).setValue(entity.entityDict()) { (error, ref) in
            self.loadEntities()
        }
    }
    //MARK: LOAD
    func loadDailyCalorieGoal() {
        ref.child(my_user).child(daily_calories_goal).observeSingleEvent(of: .value) { (snap) in
            if let snapValue = snap.value as? String {
                self.delegate?.newDailyCalorieGoalSet(calorieGoal: snapValue)
            }
        }
    }
    
    func loadProductsFrom(dateString : String) {
        var products : [Product] = []
                
        ref.child(my_user).child(dateString).observeSingleEvent(of: .value) { (snap) in
    
            if let snapValue = snap.value as? [String : [String : String]] {
                for (_, dict) in snapValue {
                    let product = Product(withDict: dict, dateString: dateString)
                    products.append(product)
                }
            }
            products.sort(by: {$0.date < $1.date})
            self.delegate?.didReceived(products: products)
        }
    }
    
    func loadEntities() {
        ref.child(my_user).child(my_entities).observeSingleEvent(of: .value) { (snap) in
            if let snapValue = snap.value as? [String : [String : String]] {
                var entities = [Entity]()
                for (_,dict) in snapValue {
                    let entity = Entity(withDict: dict)
                    entities.append(entity)
                }
                self.delegate?.didReceive(entities: entities)
            }
        }
    }
    
    func loadCart() {
        ref.child(my_user).child(cart).observeSingleEvent(of: .value) { (snap) in
            var cart = [CartEntity]()
            if let snapValue = snap.value as? [String : [String : Double]] {
                for (key,value) in snapValue {
                    let cartEntity = CartEntity(fromDict: value, name: key)
                    cart.append(cartEntity)
                }
                self.delegate?.didReceive(cart: cart)
            }
        }
    }
    
    //MARK: DELETE
    func delete(product : Product) {
        ref.child(my_user).child(product.dateString).child("\(product.date)").removeValue { (error, ref) in
            self.loadProductsFrom(dateString: product.dateString)
        }
    }
    
    func delete(entity : Entity) {
        ref.child(my_user).child(my_entities).child(entity.name).removeValue { (error, ref) in
            self.loadEntities()
        }
    }
}
