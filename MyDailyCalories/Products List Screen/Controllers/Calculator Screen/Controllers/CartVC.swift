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
        Firebase.shared.delegate = self
        Firebase.shared.loadCart()
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
        sumOfCart.devidePropertiesBy(servings)
        return sumOfCart
    }
}

extension CartVC : UITableViewDelegate, UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cart.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? CartEntityCell {
            cell.setCell(withCartEntity: cart[indexPath.row], index : indexPath.row)
            cell.delegate = self
            if cart.count - 1 == indexPath.row {
                cell.viewActionButtons.isHidden = false
                cell.viewTotalNutritions.isHidden = false
                cell.setLastCellLabels(withSummedCart: sumOfCartEntities())
                let btnTitle = NSLocalizedString("cart_servings", comment: "") + "\(Int(servings))"
                cell.btnServings.setTitle(btnTitle, for: .normal)
                cell.parentVC = self
            }
            return cell
        }
        return UITableViewCell()
    }
}

extension CartVC : FirebaseDelegate {

    func didReceive(cart: [CartEntity]) {
        self.cart = cart
        delegate?.didReceive(cart : cart)
        loader.stopAnimating()
        tableView.reloadData()
    }
    
    func productSavedSuccessfully() {
        if parent != nil {
            AlertManager.shared.showAlertProductSaved(inVC: parent!)
        }
    }
    
    func didReceive(error: Error) {
        AlertManager.shared.showAlertWithError(inVC: self, message: error.localizedDescription)
    }
}

extension CartVC : AlertDelegate {
    func servingsUpdated(servings: Double) {
        self.servings = servings
        tableView.reloadData()
//        updateLabels()
    }
}

extension CartVC : CartCellDelegate {
    func tappedLonglyOnCell(atIndex index: Int) {
        AlertManager.shared.showAlertDeleteCartEntity(inVC: self, entity: cart[index])
    }
}
