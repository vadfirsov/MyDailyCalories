//
//  MyProductsVC.swift
//  MyDailyCalories
//
//  Created by VADIM FIRSOV on 24/11/2019.
//  Copyright © 2019 VADIM FIRSOV. All rights reserved.
//

import UIKit
import GoogleMobileAds

class MyProductsVC : UIViewController {
    private let segue_to_intro_view =  "go_to_intro_view"
    private let segue_to_calculator =  "go_to_calculator"
    private let segue_to_new_product = "go_to_add_new_product"
    
    private let cellID =               "EntityCellID"
    private var entities = [Entity]()
    private var filteredEntities = [Entity]()
    private var choosenEntityIndex = 200

    @IBOutlet weak var btnCal:     UIButton!
    @IBOutlet weak var btnProtein: UIButton!
    @IBOutlet weak var btnCarbs:   UIButton!
    @IBOutlet weak var btnFat:     UIButton!
    @IBOutlet weak var btnName:    UIButton! {
        didSet { if #available(iOS 11.0, *) {
            btnName.contentHorizontalAlignment = .leading
        } else {
            btnName.contentHorizontalAlignment = .center
            } } }
    
    @IBOutlet weak var bannerAdd: GADBannerView!
    @IBOutlet var titleBtns: [UIButton]!

    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    private var isSelfVisible = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AdMob.shared.set(banner: bannerAdd, inVC: self)
        loader.startAnimating()
        Firebase.shared.loadEntities()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        setDelegates()
        AdMob.shared.showInterstitialAd(inVC: self)
        isSelfVisible = true

        if HintsManager.shared.shouldShowIntroInMyProducts == true {
            showIntro()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        searchBar.resignFirstResponder()
        isSelfVisible = false
    }
    
    private func setDelegates() {
        Firebase.shared.delegate = self
        tableView.delegate =       self
        tableView.dataSource =     self
        searchBar.delegate =       self
    }
    
    private func showIntro() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            if self.isSelfVisible {
               self.performSegue(withIdentifier: self.segue_to_intro_view, sender: self)
               HintsManager.shared.shouldShowIntroInMyProducts = false
            }
        }
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
        
        setFilterIndicatorOn(button: sender) 
        filteredEntities = EntitiesFilter.shared.filtered(entities: entities, byFilter: filter)

        tableView.reloadData()
    }
    
    private func setFilterIndicatorOn(button : UIButton) {
        for btn in titleBtns {
            var btnTitle = btn.titleLabel?.text ?? ""
            btnTitle = btnTitle.replacingOccurrences(of: "↑", with: "")
            btnTitle = btnTitle.replacingOccurrences(of: "↓", with: "")
            if btn == button {
                btnTitle = EntitiesFilter.shared.isLowestToHighest ? btnTitle + "↓" : btnTitle + "↑"
            }
            btn.setTitle(btnTitle, for: .normal)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let calculatorVC = segue.destination as? CalculatorVC {
            calculatorVC.entity = filteredEntities[choosenEntityIndex]
        }
        else if let introVC = segue.destination as? MyProductsIntroVC {
            introVC.delegate = self
        }
    }
    
    private func locStr(_ string : String) -> String {
        return NSLocalizedString("auth_" + string, comment: "")
    }
    
    private func tappedLonglyOnCell(index: Int) {
        AlertManager.shared.showAlertDeleteEntity(inVC: self, entity: filteredEntities[index], index: index)
    }
}

extension MyProductsVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredEntities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? EntityCell {
            let entity = filteredEntities[indexPath.row]
            cell.setWith(entity : entity, index: indexPath.row)
            cell.addGesture()
            cell.tappedLongely = self.tappedLonglyOnCell
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        choosenEntityIndex = indexPath.row
        performSegue(withIdentifier: segue_to_calculator, sender: self)
    }
}

extension MyProductsVC : FirebaseDelegate {
    
    func didReceive(entities: [Entity]) {
        self.entities = entities
        loader.stopAnimating()
        filteredEntities = EntitiesFilter.shared.filtered(entities: entities, byFilter: .name)
        tableView.reloadData()
    }
    
    func didReceive(foods: [Entity]) {
        Firebase.shared.saveFoodsAd(entities: foods)
    }
    
    func didReceive(error: Error) {
        AlertManager.shared.showAlertWithError(inVC: self, message: error.localizedDescription)
    }
}

extension MyProductsVC : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let searchText = searchBar.text {
            filteredEntities = EntitiesFilter.shared.entities(entities, contain: searchText)
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

extension MyProductsVC : MyProductsIntroDelegate {
    func didTapAddNew() {
        performSegue(withIdentifier: segue_to_new_product, sender: self)
    }
}
