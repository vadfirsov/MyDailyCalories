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
import GoogleSignIn
import FirebaseUI
import FBSDKLoginKit

protocol FirebaseDelegate {
    func didReceived(products : [Product])
    func newDailyCalorieGoalSet(calorieGoal : String)
    func didReceive(entities : [Entity])
    func didReceive(cart : [CartEntity])
    func productSavedSuccessfully()
    func loginSuccess()
    func loginFailedWith(error : String)
    func autoLoginWith(email : String, pw : String)
    func isUser(login : Bool) //mandatory
    func didLoggedOutWith(error : Error?)
    func didRecieve(firstLoginDateString : String)
    func didReceive(foods : [Entity])
    func didReceive(error : Error)
    func didSaveMessage()
}

extension FirebaseDelegate {
    func didReceived(products : [Product]) {}
    func newDailyCalorieGoalSet(calorieGoal : String) {}
    func didReceive(entities : [Entity]) {}
    func didReceive(cart : [CartEntity]) {}
    func productSavedSuccessfully() {}
    func loginSuccess() {}
    func loginFailedWith(error : String) {}
    func autoLoginWith(email : String, pw : String) {}
    func isUser(login : Bool) {}
    func didLoggedOutWith(error : Error?) {}
    func didRecieve(firstLoginDateString : String) {}
    func didReceive(foods : [Entity]) {}
    func didSaveMessage() {}

}

class Firebase {
    
    static let shared = Firebase()
    private init() { }
    
    var delegate : FirebaseDelegate?
    private let ref = Database.database().reference()
    
    private let daily_calories_goal = "daily_calories_goal"
    private let my_entities =         "my_entities"
    private let cart =                "cart"
    private let first_login_date =    "first_login_date"
    private let last_time_ad_showed = "last_time_ad_showed"
    private let users =               "users"
    private let foods =               "foods"
    private let messages =            "messages"
    
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
        delegate?.isUser(login: (user != nil))
    }
    
    func tryLogOut() {
        var err : Error?
        //facebook & google
        let loginManager = LoginManager()
        loginManager.logOut()
        GIDSignIn.sharedInstance()?.signOut()
        //everything else
        do { try Auth.auth().signOut() }
        catch { err = error }
        delegate?.didLoggedOutWith(error: err)
    }
    
    //MARK: THIRD PARTY SIGNIN
    func signInWithGoogle(user : GIDGoogleUser) {
        if let auth = user.authentication {
            let credentials = GoogleAuthProvider.credential(withIDToken: auth.idToken, accessToken: auth.accessToken)
            signInWith(credentials: credentials)
        }
    }
    
    func signInWithFB() {
        guard let token = AccessToken.current?.tokenString else {
            return
        }

        let credentials = FacebookAuthProvider.credential(withAccessToken: token)
        signInWith(credentials: credentials)
    }
    
    func signInWithApple(credentials : AuthCredential) {
        signInWith(credentials: credentials)
    }
    
     private func signInWith(credentials : AuthCredential) {
        Auth.auth().signIn(with: credentials) { (user, error) in
             if error != nil {
                self.tryLogOut()
                self.delegate?.loginFailedWith(error: error!.localizedDescription)
            } else if error == nil {
             self.delegate?.loginSuccess()
            }
        }
    }
    
    //MARK: SAVE
    func saveNew(product : Product) {
        let fullDate = "\(product.date)"
        let uid = Auth.auth().currentUser?.uid ?? ""
        
        ref.child(users).child(uid).child(product.dateString).child(fullDate).setValue(product.productDict()) { [weak self] (error, ref) in
            if error != nil {
                self?.delegate?.didReceive(error: error!)
            }
            else {
                self?.loadProductsFrom(dateString: product.dateString)
                self?.delegate?.productSavedSuccessfully()
            }
        }
    }

    private func saveUserFirstLoginDate() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let dateString = "\(Date())"
        ref.child(users).child(uid).child(first_login_date).setValue(dateString) { (error, _) in
            if error != nil {
                self.delegate?.didReceive(error: error!)
            }
            else {
                self.loadUserFirstLoginDate()
            }
        }
    }
    
//    func saveAdShowedDate() {
//        guard let uid = Auth.auth().currentUser?.uid else { return }
//        let dateString = "\(Date())"
//        ref.child(users).child(uid).child(last_time_ad_showed).setValue(dateString) { (error, _) in
//            if error != nil {
//                self.delegate?.didReceive(error: error!)
//            }
//        }
//    }
    
    func save(dailyCaloriesGoal : String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        ref.child(users).child(uid).child(daily_calories_goal).setValue(dailyCaloriesGoal) { [weak self] (error, ref) in
            if error == nil {
                self?.delegate?.newDailyCalorieGoalSet(calorieGoal: dailyCaloriesGoal)
            }
        }
    }
    
    func save(cartEntity : CartEntity) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        ref.child(users).child(uid).child(cart).child(cartEntity.name).setValue(cartEntity.cartEntityDic()) { [weak self] (error, ref) in
            if error != nil {
                self?.delegate?.didReceive(error: error!)
            }
            self?.loadCart()
        }
    }
    
    func saveNew(entity : Entity) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        ref.child(users).child(uid).child(my_entities).child(entity.name).setValue(entity.entityDict()) { [weak self] (error, ref) in
            if error != nil {
                self?.delegate?.didReceive(error: error!)
            }
            self?.loadEntities()
        }
    }
    
    func saveFoodsAd(entities : [Entity]) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        for entity in entities {
            ref.child(users).child(uid).child(my_entities).child(entity.name).setValue(entity.entityDict()) { (error, _) in
                if error != nil {
                    self.delegate?.didReceive(error: error!)
                }
                else {
                    self.loadEntities()
                }
            }
        }
    }
    
    func save(message : String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let dateStamp = Int(Date().timeIntervalSinceReferenceDate)
        let stringDateStamp = String(dateStamp)
        ref.child(messages).child(uid).child(stringDateStamp).setValue(message) { (error, ref) in
            if error != nil {
                self.delegate?.didReceive(error: error!)
            }
            else {
                self.delegate?.didSaveMessage()
            }
        }
    }

    //MARK: LOAD
    func loadDailyCalorieGoal() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        ref.child(users).child(uid).child(daily_calories_goal).observeSingleEvent(of: .value) { [weak self] (snap) in
            if let snapValue = snap.value as? String {
                self?.delegate?.newDailyCalorieGoalSet(calorieGoal: snapValue)
            }
        }
    }
    
    func loadProductsFrom(dateString : String) {
        var products : [Product] = []
        guard let uid = Auth.auth().currentUser?.uid else { return }
        ref.child(users).child(uid).child(dateString).observeSingleEvent(of: .value) { [weak self] (snap) in
    
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
    
    func loadUserFirstLoginDate() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        ref.child(users).child(uid).child(first_login_date).observeSingleEvent(of: .value) { (snap) in
            if let snapValue = snap.value as? String {
                self.delegate?.didRecieve(firstLoginDateString: snapValue)
            }
            else {
                self.saveUserFirstLoginDate()
            }
        }
    }
    
    //DEPRICARED - DONE IN ADMOB ITSELF
//    func loadUserWatchedAdDate() {
//        guard let uid = Auth.auth().currentUser?.uid else { return }
//        ref.child(users).child(uid).child(last_time_ad_showed).observeSingleEvent(of: .value) { (snap) in
//            if let snapValue = snap.value as? String {
//                if DateManager.shared.isFullDayPassedSince(lastTimeWatchedAd: snapValue) {
//                    AdMob.shared.shouldShowInterstitialAd = true
//                }
//            }
//            else {
//                self.saveAdShowedDate()
//            }
//        }
//    }
    
    func loadEntities() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        ref.child(users).child(uid).child(my_entities).observeSingleEvent(of: .value) { (snap) in
            self.delegate?.didReceive(entities: self.entitiesFrom(snap: snap))
        }
    }
    
    private func entitiesFrom(snap : DataSnapshot) -> [Entity] {
        var entities = [Entity]()
        if let snapValue = snap.value as? [String : [String : String]] {
            for (_,dict) in snapValue {
                let entity = Entity(withDict: dict)
                entities.append(entity)
            }
        }
        return entities
    }
    
    func loadCart() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        ref.child(users).child(uid).child(cart).observeSingleEvent(of: .value) { (snap) in
            self.delegate?.didReceive(cart: self.cartFrom(snap: snap))
        }
    }
    
    func loadFoods() {
        ref.child(foods).observeSingleEvent(of: .value) { (snap) in
            self.delegate?.didReceive(foods: self.foodsFrom(snap: snap))
        }
    }
    
    private func foodsFrom(snap : DataSnapshot) -> [Entity] {
        var foods = [Entity]()
        if let snapValue = snap.value as? [String : [String : String]] {
            for (_,value) in snapValue {
                let food = Entity(withDict: value)
                foods.append(food)
            }
        }
        return foods
    }
    
    private func cartFrom(snap : DataSnapshot) -> [CartEntity] {
        var cart = [CartEntity]()
        if let snapValue = snap.value as? [String : [String : Double]] {
            for (key,value) in snapValue {
                let cartEntity = CartEntity(fromDict: value, name: key)
                cart.append(cartEntity)
            }
        }
        return cart
    }
    
    //MARK: DELETE
    func delete(product : Product) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        ref.child(users).child(uid).child(product.dateString).child("\(product.date)").removeValue { [weak self] (error, ref) in
            if error != nil {
                self?.delegate?.didReceive(error: error!)
            }
            self?.loadProductsFrom(dateString: product.dateString)
        }
    }
    
    func delete(entity : Entity) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        ref.child(users).child(uid).child(my_entities).child(entity.name).removeValue { [weak self] (error, ref) in
            if error != nil {
                self?.delegate?.didReceive(error: error!)
            }
            self?.loadEntities()
        }
    }
    
    func delete(cartEntity : CartEntity) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        ref.child(users).child(uid).child("cart").child(cartEntity.name).removeValue { [weak self] (error, ref) in
            if error != nil {
                self?.delegate?.didReceive(error: error!)
            }
            self?.loadCart()
        }
    }
    
    func deleteCart() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        ref.child(users).child(uid).child(cart).removeValue { [weak self] (error, ref) in
            if error != nil {
                self?.delegate?.didReceive(error: error!)
            }
            let emptyCart = [CartEntity]()
            self?.delegate?.didReceive(cart: emptyCart)
        }
    }
}
