//
//  CartVC.swift
//  MyDailyCalories
//
//  Created by VADIM FIRSOV on 25/11/2019.
//  Copyright © 2019 VADIM FIRSOV. All rights reserved.
//

import UIKit

class CartVC : UIViewController {
    
    private let cellID = "cartCellID"
    private var servings : Double = 1
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

    
    private var cart = [CartEntity]()
    
    
    @IBAction func emptyCartTapped(_ sender: UIButton) {
        //show alert empty cart
    }
    
    @IBAction func servingsTapped(_ sender: UIButton) {
        AlertManager.shared.showAlertChooseServings(inVC: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        FirebaseManager.shared.delegate = self
        FirebaseManager.shared.loadCart()
        AlertManager.shared.delegate = self
    }
    
    private func updateLabels() {
        var demoCart = CartEntity()
        for cartEntity in cart {

            demoCart.calories += cartEntity.calories
            demoCart.grams +=    cartEntity.grams
            demoCart.protein +=  cartEntity.protein
            demoCart.carbs +=    cartEntity.carbs
            demoCart.fat +=      cartEntity.carbs
        }
        demoCart.devidePropertiesBy(servings)
        
        btnSarvings.setTitle("Servings : \(Int(servings))", for: .normal)
        lblCalories.text = demoCart.calories.roundedString()
        lblProtein.text =  demoCart.protein.roundedString()
        lblCarbs.text =    demoCart.carbs.roundedString()
        lblFat.text =      demoCart.fat.roundedString()
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
        updateLabels()
        tableView.reloadData()
    }
}

extension CartVC : AlertDelegate {
    func servingsUpdated(servings: Double) {
        self.servings = servings
        updateLabels()
    }
}
