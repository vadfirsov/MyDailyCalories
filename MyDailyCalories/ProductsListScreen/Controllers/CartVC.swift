//
//  CartVC.swift
//  MyDailyCalories
//
//  Created by VADIM FIRSOV on 25/11/2019.
//  Copyright © 2019 VADIM FIRSOV. All rights reserved.
//

import UIKit

protocol CartDelegate {
    func didReceive(cart : [CartEntity])
}

class CartVC : UIViewController {
    
    private let cellID = "cartCellID"
    private var servings : Double = 1
    
    var delegate : CartDelegate?
    
    @IBOutlet weak var btnSarvings: UIButton!
    @IBOutlet weak var lblCalories: UILabel!
    @IBOutlet weak var lblProtein:  UILabel!
    @IBOutlet weak var lblCarbs:    UILabel!
    @IBOutlet weak var lblFat:      UILabel!
    @IBOutlet weak var tableView:   UITableView! {
        didSet {
            tableView.delegate =   self
            tableView.dataSource = self
        }
    }

    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    private var cart = [CartEntity]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loader.startAnimating()
        FirebaseManager.shared.delegate = self
        FirebaseManager.shared.loadCart()
        updateLabels()
    }
    
    @IBAction func emptyCartTapped(_ sender: UIButton) {
        AlertManager.shared.showAlertEmptyCart(inVC: self)
    }
    
    @IBAction func servingsTapped(_ sender: UIButton) {
        AlertManager.shared.showAlertChooseServings(inVC: self)
    }
    
    @IBAction func addToDailyTapped(_ sender: UIButton) {
        let sumOfCart = sumOfCartEntities()
        let product = Product(name:     "No Name",
                              calories: "\(sumOfCart.calories)",
                              protein:  "\(sumOfCart.protein)",
                              carbs:    "\(sumOfCart.carbs)",
                              fat:      "\(sumOfCart.fat)")
        
        AlertManager.shared.showAlertAddToDailyWithName(inVC: self, product: product)
        
    }
    
    private func updateLabels() {
        var sumOfCart = sumOfCartEntities()
        sumOfCart.devidePropertiesBy(servings)
        
        btnSarvings.setTitle("Servings : \(Int(servings))", for: .normal)
        lblCalories.text = sumOfCart.calories.roundedString()
        lblProtein.text =  sumOfCart.protein.roundedString()
        lblCarbs.text =    sumOfCart.carbs.roundedString()
        lblFat.text =      sumOfCart.fat.roundedString()
    }
    
    private func sumOfCartEntities() -> CartEntity {
        var sumOfCart = CartEntity()
        for cartEntity in cart {

            sumOfCart.calories += cartEntity.calories
            sumOfCart.grams +=    cartEntity.grams
            sumOfCart.protein +=  cartEntity.protein
            sumOfCart.carbs +=    cartEntity.carbs
            sumOfCart.fat +=      cartEntity.carbs
        }
        return sumOfCart
    }
}

extension CartVC : UITableViewDelegate, UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cart.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? CartEntityCell {
            cell.setCell(withCartEntity: cart[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
}

extension CartVC : FirebaseDelegate {
    func didReceive(cart: [CartEntity]) {
        self.cart = cart
        delegate?.didReceive(cart : cart)

        updateLabels()
        tableView.reloadData()
    }
    
    func productSavedSuccessfully() {
        if parent != nil {
            AlertManager.shared.showAlertProductSaved(inVC: parent!)
        }
    }
}

extension CartVC : AlertDelegate {
    func servingsUpdated(servings: Double) {
        self.servings = servings
        updateLabels()
    }
}
