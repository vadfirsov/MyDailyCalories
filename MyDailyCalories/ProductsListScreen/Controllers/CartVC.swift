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
    
    
    @IBAction func servingsTapped(_ sender: UIButton) {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        FirebaseManager.shared.loadCart()
    }
}

extension CartVC : UITableViewDelegate, UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cart.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? CartEntityCell {
            return cell
        }
        return UITableViewCell()
    }
}

