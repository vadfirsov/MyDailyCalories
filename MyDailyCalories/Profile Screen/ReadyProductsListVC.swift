//
//  ReadyProductsListVC.swift
//  MyDailyCalories
//
//  Created by pionet\Alex.s on 10/12/2019.
//  Copyright © 2019 VADIM FIRSOV. All rights reserved.
//

import UIKit

class ReadyProductsListVC : UIViewController {
    
    private let cellID = "ready_product_cell_ID"
    private var foods =         [Entity]()
    private var filteredFoods = [Entity]()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var loader:    UIActivityIndicatorView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        loader.startAnimating()
        Firebase.shared.loadFoods()
        setDelegates()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        searchBar.resignFirstResponder()
        navigationController?.popViewController(animated: false)
    }
    
    @IBAction func addAllTapped(_ sender: UIBarButtonItem) {
        AlertManager.shared.showAlertAddAllFood(inVC: self, foods: foods)
    }
    
    
    private func setDelegates() {
        tableView.delegate =       self
        tableView.dataSource =     self
        Firebase.shared.delegate = self
        searchBar.delegate =       self
    }
}

extension ReadyProductsListVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredFoods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? ReadyProductCell {
            cell.lblProductName.text = filteredFoods[indexPath.row].name
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        AlertManager.shared.showAlertAddToMyProducts(inVC: self, food: foods[indexPath.row])
    }
}

extension ReadyProductsListVC : FirebaseDelegate {
    func didReceive(foods: [Entity]) {
        self.foods = foods
        filteredFoods = foods
        loader.stopAnimating()
        tableView.reloadData()
    }
    
    func didReceive(entities: [Entity]) {
        AlertManager.shared.showAlertFoodAddedToMyProducts(inVC: self)
    }
    
    func didReceive(error: Error) {
        AlertManager.shared.showAlertWithError(inVC: self, message: error.localizedDescription)
    }
}

extension ReadyProductsListVC : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let searchText = searchBar.text {
            filteredFoods = EntitiesFilter.shared.entities(foods, contain: searchText)
            tableView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.text = ""
        filteredFoods = foods
        tableView.reloadData()
    }
}



//var foo : [Entity] {
//    let mango = Entity(name: "Mango 🥭", calories: "64", protein: "", carbs: "17", fat: "")
//    let pineapple = Entity(name: "Pineapple 🍍", calories: "50", protein: "", carbs: "13.12", fat: "")
//    let coconut = Entity(name: "Coconut 🥥", calories: "354", protein: "3.33", carbs: "15.23", fat: "33.49")
//    let broccoli = Entity(name: "Broccoli 🥦", calories: "34", protein: "2.82", carbs: "6.64", fat: "")
//    let avocado = Entity(name: "Avocado 🥑", calories: "160", protein: "2", carbs: "8.64", fat: "14.66")
//    let eggplant = Entity(name: "Eggplant 🍆", calories: "24", protein: "1.01", carbs: "5.57", fat: "")
//    let tomato = Entity(name: "Tomato 🍅", calories: "18", protein: "", carbs: "3.92", fat: "")
//    let kiwi = Entity(name: "Kiwi 🥝", calories: "61", protein: "", carbs: "14.88", fat: "")
//    let cucumber = Entity(name: "Cucumber 🥒", calories: "15", protein: "", carbs: "3.63", fat: "")
//    let pepper = Entity(name: "Pepper 🌶", calories: "31", protein: "0.99", carbs: "6.03", fat: "")
//    let chilli = Entity(name: "Chili 🌶", calories: "40", protein: "", carbs: "9.42", fat: "")
//    let corn = Entity(name: "Corn Cooked 🌽", calories: "108", protein: "3.32", carbs: "25.2", fat: "1.28")
//    let carrot = Entity(name: "Carrot 🥕", calories: "41", protein: "", carbs: "9.58", fat: "")
//    let bread = Entity(name: "Bread 🍞", calories: "242", protein: "9", carbs: "49.1", fat: "")
//    let wholeBread = Entity(name: "Whole Grains Bread 🍞", calories: "210", protein: "11", carbs: "46.3", fat: "2.4")
//    let sweetPotato = Entity(name: "Sweet Potato 🍠", calories: "86", protein: "", carbs: "20.12", fat: "")
//    let potato = Entity(name: "Potato 🥔", calories: "69", protein: "1.68", carbs: "15.71", fat: "")
//    let beef = Entity(name: "Beef 🥩", calories: "274", protein: "22", carbs: "", fat: "17.51")
//    let chickenBreast = Entity(name: "Chicken Breast 🍗", calories: "114", protein: "21.23", carbs: "", fat: "2.23")
//    let eggs = Entity(name: "Eggs 🥚", calories: "143", protein: "12.56", carbs: "", fat: "9.51")
//    let turkey = Entity(name: "Turkey 🦃", calories: "111", protein: "24.3", carbs: "", fat: "")
//    let cheese5 = Entity(name: "Cheese 5% 🧀", calories: "178", protein: "33", carbs: "", fat: "5")
//    let cheese22 = Entity(name: "Cheese 22% 🧀", calories: "302", protein: "26", carbs: "", fat: "22")
//    let cheese25 = Entity(name: "Cheese 28% 🧀", calories: "349", protein: "24", carbs: "", fat: "28")
//    let rice = Entity(name: "Basmati Rice Raw 🍚", calories: "345", protein: "7", carbs: "78", fat: "")
//    let beer = Entity(name: "Lager Beer 5% 🍺", calories: "42.1", protein: "", carbs: "3.55", fat: "")
//    let redWine = Entity(name: "Red Wine 🍷", calories: "68", protein: "", carbs: "5.29", fat: "")
//    let milk3 = Entity(name: "Milk 3% 🥛", calories: "59", protein: "3.2", carbs: "4.7", fat: "3")
//    let soyMilk = Entity(name: "Soy Milk 🥛", calories: "45", protein: "2.94", carbs: "3.35", fat: "2")
//    let alcohol40 = Entity(name: "Alcohol 40% ☠️", calories: "235", protein: "", carbs: "", fat: "")
//    let fishi = Entity(name: "Fish 🐟", calories: "103", protein: "20", carbs: "", fat: "2.3")
//    let tuna = Entity(name: "Canned Tuna in Oil 🦈", calories: "173", protein: "25.2", carbs: "", fat: "8")
//    let pastrama = Entity(name: "Pastrama Italy 🍖", calories: "113", protein: "25.2", carbs: "3", fat: "5")
//    let lentis = Entity(name: "Lentils Raw 🍲", calories: "344.3", protein: "22.2", carbs: "60.5", fat: "1.5")
//    let olive = Entity(name: "Green Olives 🍲", calories: "164", protein: "2", carbs: "3", fat: "16")
//    let oil = Entity(name: "Olive Oil 🍲", calories: "830", protein: "", carbs: "", fat: "92")
//    let sugar = Entity(name: "Sugar ☠️", calories: "396", protein: "", carbs: "", fat: "")
//
//    let apple = Entity(name: "Apple 🍏", calories: "52", protein: "", carbs: "10.5", fat: "")
//     let pearl = Entity(name: "Pearl 🍐", calories: "58", protein: "", carbs: "15.23", fat: "")
//     let orange = Entity(name: "Orange 🍊", calories: "47", protein: "", carbs: "11.42", fat: "")
//     let lemon = Entity(name: "Lemon 🍋", calories: "20", protein: "", carbs: "10.7", fat: "")
//     let strawberry = Entity(name: "Strawberry 🍓", calories: "32", protein: "", carbs: "7.24", fat: "")
//     let grapes = Entity(name: "Grapes 🍇", calories: "69", protein: "", carbs: "18.1", fat: "")
//     let watermelon = Entity(name: "Watermelon 🍉", calories: "30", protein: "", carbs: "7.55", fat: "")
//     let banana = Entity(name: "Banana 🍌", calories: "89", protein: "1.02", carbs: "22.84", fat: "")
//     let cherry = Entity(name: "Cherry 🍒", calories: "63", protein: "1.06", carbs: "", fat: "")
//     let peach = Entity(name: "Peach 🍑", calories: "39", protein: "", carbs: "9.54", fat: "")
//
//    let foods = [sugar , oil,olive , lentis,pastrama , tuna, fishi,alcohol40 , soyMilk, milk3,redWine , beer,rice ,cheese25 ,cheese22 , cheese5,
//                 turkey, eggs,chickenBreast, beef, potato,sweetPotato , wholeBread, bread, carrot, corn, chilli,pepper,
//        cucumber,kiwi ,tomato,eggplant , avocado, broccoli, coconut,pineapple ,mango , apple,pearl , orange,lemon , strawberry, grapes, watermelon, banana,banana,peach, cherry ]
//    return foods
//}
