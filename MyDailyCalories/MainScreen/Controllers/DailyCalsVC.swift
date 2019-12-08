//
//  ViewController.swift
//  MyDailyCalories
//
//  Created by VADIM FIRSOV on 21/11/2019.
//  Copyright © 2019 VADIM FIRSOV. All rights reserved.
//

import UIKit
import GoogleMobileAds


class DailyCalsVC: UIViewController {

    private let cellID = "ProductCellID"
    private var products : [Product] = []
    private var dateToDisplay = Date()
    
    private var maxDailyCalories = 0.0
    private var totalCalories = 0.0
    
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                             action: #selector(dismissKeyboard))
    
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    @IBOutlet weak var btnDailyTotal: UIButton!
    @IBOutlet weak var btnNext:       UIButton!
    @IBOutlet weak var btnPrev:       UIButton!
    
    @IBOutlet weak var lblDate:          UILabel!
    @IBOutlet weak var lblTotalCalories: UILabel!
    @IBOutlet weak var lblTotalCarbs:    UILabel!
    @IBOutlet weak var lblTotalFat:      UILabel!
    @IBOutlet weak var lblTotalProtein:  UILabel!
    
    @IBOutlet weak var progressBar: UIProgressView!
    
    @IBOutlet weak var bannerView: GADBannerView!
    
    @IBOutlet weak var tableView:        UITableView! {
        didSet {
            tableView.delegate =   self
            tableView.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AdMob.shared.set(banner: bannerView, inVC: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setManagers()
        addGestures()
        showHint()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        view.removeGestureRecognizer(tap)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        bannerView = nil
    }
    
    //MARK: UIBUTTONS
    @IBAction func showNextDate(_ sender: UIButton) {
        showNewDay(sender: sender)
    }
    
    @IBAction func dailyTotalTapped(_ sender: UIButton) {
        AlertManager.shared.showAlertSetMaxDailyCalories(inVC: self)
    }
    
    private func showNewDay(sender: UIButton) {
        var timeInterval : TimeInterval = 0
        if sender == btnNext { timeInterval = 86400 }
        else if sender == btnPrev { timeInterval = -86400 }
        
        dateToDisplay = dateToDisplay.addingTimeInterval(timeInterval)
        let nextDate = DateManager.shared.stringFrom(date: dateToDisplay)
        if nextDate == DateManager.shared.stringFrom(date: Date()) {
            lblDate.text = "Today"
        }
        else {
            lblDate.text = nextDate
        }
        loader.startAnimating()
        Firebase.shared.loadProductsFrom(dateString: nextDate)
    }
    
    private func updateProgressBar() {
        let progress : Float = Float(totalCalories / maxDailyCalories)
        progressBar.setProgress(progress, animated: true)
    }
    
    private func setManagers() {
        AlertManager.shared.delegate =    self
        Firebase.shared.delegate = self
        loader.startAnimating()
        Firebase.shared.loadProductsFrom(dateString: DateManager.shared.stringFrom(date: dateToDisplay))
        Firebase.shared.loadDailyCalorieGoal()
    }

    private func addGestures() {
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func setLabels() {
        var totalProtein =  0.0
        var totalCarbs =    0.0
        var totalFat =      0.0
        for product in products {
            if let calories = Double(product.calories) { totalCalories += calories }
            if let protein =  Double(product.protein)  { totalProtein +=  protein }
            if let carbs =    Double(product.carbs)    { totalCarbs +=    carbs }
            if let fat =      Double(product.fat)      { totalFat +=      fat }
        }
        lblTotalCalories.text = totalCalories.roundedString()
        lblTotalProtein.text =  totalProtein.roundedString()
        lblTotalCarbs.text =    totalCarbs.roundedString()
        lblTotalFat.text =      totalFat.roundedString()
    }
    
    private func setDailyCaloriesIndicator() {
        let btnLabel = "\(Int(totalCalories)) / \(Int(maxDailyCalories)) Calories"
        btnDailyTotal.setTitle(btnLabel, for: .normal)

        btnDailyTotal.setTitleColor(.white, for: .normal)
        let color = (totalCalories > maxDailyCalories) ? #colorLiteral(red: 1, green: 0.3351041079, blue: 0.3041929901, alpha: 1) : #colorLiteral(red: 0.5527830124, green: 0.9990368485, blue: 0.239377737, alpha: 1)
        btnDailyTotal.setTitleColor(color, for: .normal)
        progressBar.progressTintColor = color
        if maxDailyCalories > 0 { updateProgressBar() }

    }
    
    private func showHint() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            AlertManager.shared.showHintChooseCaloriesCap(inVC: self)
        }
    }
}

extension DailyCalsVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? ProductCell {
            cell.setWith(product: products[indexPath.row], index: indexPath.row)
            cell.delegate = self
            return cell
        }
        else {
            return UITableViewCell()
        }
    }
}

extension DailyCalsVC : FirebaseDelegate {

    func newDailyCalorieGoalSet(calorieGoal: String) {
        if let maxCalories = Double(calorieGoal) {
            maxDailyCalories = maxCalories
            setDailyCaloriesIndicator()
        }
    }
    
    func didReceived(products: [Product]) {
        self.products = products
        totalCalories = 0
        setLabels()
        setDailyCaloriesIndicator()
        tableView.reloadData()
        loader.stopAnimating()
    }
}

extension DailyCalsVC : ProductCellDelegate {
    func tappedLonglyOnCell(atIndex index : Int) {
        let product = products[index]
        AlertManager.shared.showAlertDeleteProduct(inVC: self, product: product, index: index)
    }
    
    func savedNew(product: Product) {
        loader.startAnimating()
        var p = product
        p.dateString = DateManager.shared.stringFrom(date: dateToDisplay)
        Firebase.shared.saveNew(product: p)
        tableView.reloadData()
    }
}

extension DailyCalsVC : AlertDelegate {
    
    func newCalorieDailyGoalSet(calorieGoal: String) {
        if let calorieGoalInt = Double(calorieGoal) {
            maxDailyCalories = calorieGoalInt
            setDailyCaloriesIndicator()
        }
    }
}
