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

    private var todayString : String {
        return locStr("today")
    }
    private let cellID = "ProductCellID"
    private var products : [Product] = []
    private var dateToDisplay = Date()
    
    private var maxDailyCalories = 0.0
    private var totalCalories = 0.0
    
    private let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                     action: #selector(dismissKeyboard))
    
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    @IBOutlet weak var btnDailyTotal: UIButton! //?
    @IBOutlet weak var btnNext:       UIButton!
    @IBOutlet weak var btnPrev:       UIButton!
    
    @IBOutlet weak var lblDate:          UILabel!
    @IBOutlet weak var lblTotalCalories: UILabel!
    @IBOutlet weak var lblTotalCarbs:    UILabel!
    @IBOutlet weak var lblTotalFat:      UILabel!
    @IBOutlet weak var lblTotalProtein:  UILabel!
    
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var bannerView: GADBannerView!
    
    @IBOutlet weak var addBtn: UIBarButtonItem!
    
    @IBOutlet weak var lblName:    UILabel!
    @IBOutlet weak var lblCals:    UILabel!
    @IBOutlet weak var lblCarbs:   UILabel!
    @IBOutlet weak var lblProtein: UILabel!
    @IBOutlet weak var lblFat:     UILabel!
    @IBOutlet weak var lblTotal:   UILabel!
    
    
    private func setLocalizedLabels() {
        lblName.text =    locStr("name")
        lblCals.text =    locStr("cals")
        lblCarbs.text =   locStr("carbs")
        lblProtein.text = locStr("protein")
        lblFat.text =     locStr("fat")
        lblTotal.text =   locStr("total")
        addBtn.title =    locStr("add")
        lblDate.text =    locStr("today")

        btnNext.setTitle(locStr("next"), for: .normal)
        btnPrev.setTitle(locStr("prev"), for: .normal)
        
        navigationItem.title = locStr("vc_title")
        
    }
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate =   self
            tableView.dataSource = self
        }
    }
    
    
    
    private func locStr(_ string : String) -> String {
        return NSLocalizedString("daily_" + string, comment: "")
    }
    
    private var dailyCalsLabel : String {
        var btnLabel = locStr("tap_choose_calorie_cap")
        if maxDailyCalories > 0 {
            
            btnLabel = "\(Int(totalCalories)) / \(Int(maxDailyCalories))" + locStr("calories")
        }
        return btnLabel
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLocalizedLabels()
        AdMob.shared.set(banner: bannerView, inVC: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setManagers()
        addGestures()
        AdMob.shared.showInterstitialAd(inVC: self)
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
        let nextDate = DateManager.shared.stringFromLocal(date: dateToDisplay)
        if nextDate == DateManager.shared.stringFromLocal(date: Date()) {
            lblDate.text = todayString
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
        
        btnDailyTotal.setTitle(dailyCalsLabel, for: .normal)
        btnDailyTotal.setTitleColor(.white, for: .normal)
        
        if totalCalories > maxDailyCalories { progressBar.progress = 1 }
        if maxDailyCalories > 0 { updateProgressBar() }
        updateProgressColor()
    }
    
    private func updateProgressColor() {
        let color = (totalCalories > maxDailyCalories) ? #colorLiteral(red: 0.9334908128, green: 0, blue: 0, alpha: 1) : #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        btnDailyTotal.setTitleColor(color, for: .normal)
        progressBar.progressTintColor = color
    }
    
    private func tappedLonglyOnCell(atIndex index : Int) {
        let product = products[index]
        AlertManager.shared.showAlertDeleteProduct(inVC: self, product: product, index: index)
    }
}

extension DailyCalsVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if loader.isAnimating { return 0 }
        if (products.isEmpty && lblDate.text != todayString) { return 0 }
        if (products.isEmpty && lblDate.text == todayString) { return 1 }
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? ProductCell {
            if products.isEmpty {
                cell.addNewProductView.isHidden = false
                cell.productView.isHidden = true
            }
            else {
                cell.setWith(product: products[indexPath.row], index: indexPath.row)
                cell.tappedLongely = self.tappedLonglyOnCell
            }
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
        loader.stopAnimating()
        tableView.reloadData()
    }
    
    func didRecieve(firstLoginDateString: String) {
        // for now not used.
    }
    
    func didReceive(error: Error) {
        AlertManager.shared.showAlertWithError(inVC: self, message: error.localizedDescription)
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

//if cart is empty insert empty cell with add button or something
//new user receives ad if just sign up
