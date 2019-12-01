//
//  FirebaseManager.swift
//  MyDailyCalories
//
//  Created by VADIM FIRSOV on 21/11/2019.
//  Copyright © 2019 VADIM FIRSOV. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

protocol FirebaseDelegate {
    func didReceived(products : [Product])
    func newDailyCalorieGoalSet(calorieGoal : String)
    func didReceive(entities : [Entity])
    func didReceive(cart : [CartEntity])
    func productSavedSuccessfully()
    func loginSuccess()
    func loginFailedWith(error : String)
    func savedUserName()
    func autoLoginWith(email : String, pw : String)
    func user(isLogin : Bool) //mandatory
}

extension FirebaseDelegate {
    func didReceived(products : [Product]) {}
    func newDailyCalorieGoalSet(calorieGoal : String) {}
    func didReceive(entities : [Entity]) {}
    func didReceive(cart : [CartEntity]) {}
    func productSavedSuccessfully() {}
    func loginSuccess() {}
    func loginFailedWith(error : String) {}
    func savedUserName() {}
    func autoLoginWith(email : String, pw : String) {}
    func user(isLogin : Bool) {}
}

class FirebaseManager {
    
    static let shared = FirebaseManager()
    private init() { }
    
    var delegate : FirebaseDelegate?
    private let ref = Database.database().reference()
    
    private let daily_calories_goal = "daily_calories_goal"
    private let my_entities =         "my_entities"
    private let cart =                "cart"
    
    //MARK: AUTHENTICATION
    func signUpNewUser(email : String, pw : String) {
        Auth.auth().createUser(withEmail: email, password: pw) { authResult, error in
            self.handleLoginResult(withError: error)
        }
    }
    
    func signIn(email : String, pw : String) {
        Auth.auth().signIn(withEmail: email, password: pw) { authResult, error in
            self.handleLoginResult(withError: error)
        }
    }
    
    private func handleLoginResult(withError error : Error?) {
        if error != nil {
            delegate?.loginFailedWith(error: error!.localizedDescription)
        }
        else {

            //save name to db
            delegate?.loginSuccess()
        }
    } 

    func checkIfUserLoggedIn() {

        let user = Auth.auth().currentUser
        print(user != nil)
        delegate?.user(isLogin: (user != nil))
    }
    
    func tryLogOut() {
        do { try Auth.auth().signOut() }
        catch { print(error.localizedDescription) }
    }
    
    //MARK: SAVE
    func saveNewUserWith(userName : String) {
        if let user = Auth.auth().currentUser {
            ref.child(user.uid).child("full_name").setValue(userName) { [weak self] (error, _) in
                if error != nil {
                    print(error!.localizedDescription)
                }
                else {
                    self?.delegate?.savedUserName()
                }
            }
        }
    }
    
    func saveNew(product : Product) {
        let fullDate = "\(product.date)"
        let uid = Auth.auth().currentUser?.uid ?? ""
        
        ref.child(uid).child(product.dateString).child(fullDate).setValue(product.productDict()) { [weak self] (error, ref) in
            if error != nil { print(error!.localizedDescription) }
            else {
                self?.loadProductsFrom(dateString: product.dateString)
                self?.delegate?.productSavedSuccessfully()
            }
        }
    }

    
    func save(dailyCaloriesGoal : String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        ref.child(uid).child(daily_calories_goal).setValue(dailyCaloriesGoal) { [weak self] (error, ref) in
            if error == nil {
                self?.delegate?.newDailyCalorieGoalSet(calorieGoal: dailyCaloriesGoal)
            }
        }
    }
    
    func save(cartEntity : CartEntity) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        ref.child(uid).child(cart).child(cartEntity.name).setValue(cartEntity.cartEntityDic()) { [weak self] (error, ref) in
            if error != nil {
                print(error!.localizedDescription)
            }
            self?.loadCart()
        }
    }
    
    func saveNew(entity : Entity) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        ref.child(uid).child(my_entities).child(entity.name).setValue(entity.entityDict()) { [weak self] (error, ref) in
            self?.loadEntities()
        }
    }
    //MARK: LOAD
    func loadDailyCalorieGoal() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        ref.child(uid).child(daily_calories_goal).observeSingleEvent(of: .value) { [weak self] (snap) in
            if let snapValue = snap.value as? String {
                self?.delegate?.newDailyCalorieGoalSet(calorieGoal: snapValue)
            }
        }
    }
    
    func loadProductsFrom(dateString : String) {
        var products : [Product] = []
        guard let uid = Auth.auth().currentUser?.uid else { return }
        ref.child(uid).child(dateString).observeSingleEvent(of: .value) { [weak self] (snap) in
    
            if let snapValue = snap.value as? [String : [String : String]] {
                for (_, dict) in snapValue {
                    let product = Product(withDict: dict, dateString: dateString)
                    products.append(product)
                }
            }
            products.sort(by: {$0.date < $1.date})
            self?.delegate?.didReceived(products: products)
        }
    }
    
    func loadEntities() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        ref.child(uid).child(my_entities).observeSingleEvent(of: .value) { [weak self] (snap) in
            if let snapValue = snap.value as? [String : [String : String]] {
                var entities = [Entity]()
                for (_,dict) in snapValue {
                    let entity = Entity(withDict: dict)
                    entities.append(entity)
                }
                self?.delegate?.didReceive(entities: entities)
            }
        }
    }
    
    func loadCart() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        ref.child(uid).child(cart).observeSingleEvent(of: .value) { [weak self] (snap) in
            var cart = [CartEntity]()
            if let snapValue = snap.value as? [String : [String : Double]] {
                for (key,value) in snapValue {
                    let cartEntity = CartEntity(fromDict: value, name: key)
                    cart.append(cartEntity)
                }
                self?.delegate?.didReceive(cart: cart)
            }
        }
    }
    
    //MARK: DELETE
    func delete(product : Product) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        ref.child(uid).child(product.dateString).child("\(product.date)").removeValue { [weak self] (error, ref) in
            self?.loadProductsFrom(dateString: product.dateString)
        }
    }
    
    func delete(entity : Entity) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        ref.child(uid).child(my_entities).child(entity.name).removeValue { [weak self] (error, ref) in
            self?.loadEntities()
        }
    }
    
    func deleteCart() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        ref.child(uid).child(cart).removeValue { [weak self] (error, ref) in
            let emptyCart = [CartEntity]()
            self?.delegate?.didReceive(cart: emptyCart)
        }
    }
}
