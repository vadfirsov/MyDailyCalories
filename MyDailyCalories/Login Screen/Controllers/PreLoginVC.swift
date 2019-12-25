//
//  PreLoginVC.swift
//  MyDailyCalories
//
//  Created by VADIM FIRSOV on 28/11/2019.
//  Copyright © 2019 VADIM FIRSOV. All rights reserved.
//

import UIKit

class PreLoginVC : UIViewController {
    private let segue_to_login = "go_to_login"
    private let segue_to_daily_cals = "go_to_daily_cals"
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        AdMob.shared.requestInterstitialAd()
        Firebase.shared.delegate = self
        Firebase.shared.checkIfUserLoggedIn() //leak
        
        setUserDefaults()
    }
    
    private func setUserDefaults() {
        if HintsManager.shared.shouldShowIntroInMyProducts == nil {
            HintsManager.shared.shouldShowIntroInMyProducts = true
        }
        if HintsManager.shared.shouldShowIntroInCalculator == nil {
            HintsManager.shared.shouldShowIntroInCalculator = true
        }
    }
}

extension PreLoginVC : FirebaseDelegate {
    func isUser(login: Bool) {
        if login {
            performSegue(withIdentifier: segue_to_daily_cals, sender: self)
        }
        else {
            performSegue(withIdentifier: segue_to_login, sender: self)
        }
    }
    
    func didReceive(error: Error) {
        AlertManager.shared.showAlertWithError(inVC: self, message: error.localizedDescription)
    }
}
