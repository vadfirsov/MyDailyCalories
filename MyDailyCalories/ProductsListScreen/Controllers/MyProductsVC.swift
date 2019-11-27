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
    private var filteredEntities = [Entity]()
    private var choosenEntityIndex = 200
    private var lowerToHigher = true
    
    @IBOutlet weak var btnName:    UIButton!
    @IBOutlet weak var btnCal:     UIButton!
    @IBOutlet weak var btnProtein: UIButton!
    @IBOutlet weak var btnCarbs:   UIButton!
    @IBOutlet weak var btnFat:     UIButton!
    
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate =   self
            tableView.dataSource = self
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loader.startAnimating()
        FirebaseManager.shared.loadEntities()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        FirebaseManager.shared.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        searchBar.resignFirstResponder()
    }
    
    @IBAction func btnTitleTapped(_ sender: UIButton) {
        var filter = Filter.name
        switch sender {
        case btnCal:     filter = Filter.cal
        case btnFat:     filter = Filter.fat
        case btnCarbs:   filter = Filter.carbs
        case btnProtein: filter = Filter.protein
        case btnName:    filter = Filter.name
        default: break
        }
        lowerToHigher = lowerToHigher ? false : true
        filteredEntities = FilterManager.shared.filtered(entities: filteredEntities, by: filter, lowerToHigher: lowerToHigher)
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? CalculatorVC {
            destinationVC.entity = filteredEntities[choosenEntityIndex]
        }
    }
}

extension MyProductsVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredEntities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? EntityCell {
            let entity = filteredEntities[indexPath.row]
            
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
        filteredEntities = entities
        tableView.reloadData()
    }
}

extension MyProductsVC : EntityCellDelegate {
    func tappedLonglyOnCell(index: Int) {
        AlertManager.shared.showAlertDeleteEntity(inVC: self, entity: filteredEntities[index], index: index)
    }
}

extension MyProductsVC : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let searchText = searchBar.text {
            filteredEntities = FilterManager.shared.entities(entities, contain: searchText)
            tableView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.text = ""
        filteredEntities = entities
        tableView.reloadData()
    }
}
