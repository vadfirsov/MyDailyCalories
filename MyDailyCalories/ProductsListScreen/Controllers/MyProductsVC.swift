//
//  MyProductsVC.swift
//  MyDailyCalories
//
//  Created by VADIM FIRSOV on 24/11/2019.
//  Copyright © 2019 VADIM FIRSOV. All rights reserved.
//

import UIKit

class MyProductsVC : UIViewController {
    
    private let goToCalculatorID = "goToCalculator"
    private let cellID = "EntityCellID"
    private var entities = [Entity]()
    private var choosenEntityIndex = 200
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate =   self
            tableView.dataSource = self
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FirebaseManager.shared.loadEntities()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        FirebaseManager.shared.delegate = self
    }
    
    @IBAction func addBtnTapped(_ sender: UIBarButtonItem) {
        AlertManager.shared.showAddNewEntity(inVC: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? CalculatorVC {
            destinationVC.entity = entities[choosenEntityIndex]
        }
    }
}

extension MyProductsVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? EntityCell {
            let entity = entities[indexPath.row]
            
            cell.lblName.text =     entity.name
            cell.lblCalories.text = entity.calories
            cell.lblCarbs.text =    entity.carbs
            cell.lblProtein.text =  entity.protein
            cell.lblFat.text =      entity.fat
            cell.index =            indexPath.row
            
            cell.addGesture()
            cell.delegate = self
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        choosenEntityIndex = indexPath.row
        performSegue(withIdentifier: goToCalculatorID, sender: self)
    }
}

extension MyProductsVC : FirebaseDelegate {
    func didReceive(entities: [Entity]) {
        self.entities = entities
        tableView.reloadData()
    }
}

extension MyProductsVC : EntityCellDelegate {
    func tappedLonglyOnCell(index: Int) {
        AlertManager.shared.showAlertDeleteEntity(inVC: self, entity: entities[index], index: index)
    }
}
