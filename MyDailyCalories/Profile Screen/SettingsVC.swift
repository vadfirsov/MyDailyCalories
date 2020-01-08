//
//  ProfileVC.swift
//  MyDailyCalories
//
//  Created by VADIM FIRSOV on 01/12/2019.
//  Copyright © 2019 VADIM FIRSOV. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import GoogleSignIn

class SettingsVC : UIViewController {
    
    @IBOutlet weak var btnImprove:    CustomButton!
    @IBOutlet weak var btnResetHints: CustomButton!
    @IBOutlet weak var btnProducts:   CustomButton!
    @IBOutlet weak var btnLogout:     CustomButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        Firebase.shared.delegate = self
        setLocalized()
    }
    
    @IBAction func logoutTapped(_ sender: CustomButton) {
        sender.animateTap()
        Firebase.shared.tryLogOut()
    }
    
    @IBAction func resetHintsTapped(_ sender: CustomButton) {
        let alert_hints_reset = locStr("alert_hints_reset")
        AlertManager.shared.showAlertGenericMessage(inVC: self, message: alert_hints_reset)
        HintsManager.shared.shouldShowIntroInCalculator = true
        HintsManager.shared.shouldShowIntroInMyProducts = true
        sender.animateTap()
    }
    
    @IBAction func howCanWeImproveTapped(_ sender: CustomButton) {
        sender.animateTap()

    }
    
    private func locStr(_ string : String) -> String {
        return NSLocalizedString("settings_" + string, comment: "")
    }
    
    private func setLocalized() {
        btnLogout.setTitle(locStr("logout"),          for: .normal)
        btnImprove.setTitle(locStr("improve"),        for: .normal)
        btnProducts.setTitle(locStr("products"),      for: .normal)
        btnResetHints.setTitle(locStr("reset_hints"), for: .normal)
        navigationItem.title = locStr("vc_title")
    }
    
//    "settings_alert_hints_reset" = "Hints were reset!";
//    "settings_improve" =           "How Can We Improve?";
//    "settings_reset_hints" =       "Reset Hints";
//    "settings_products" =          "Products";
//    "settings_logout" =            "Logout";
}

extension SettingsVC : FirebaseDelegate {
    func didLoggedOutWith(error: Error?) {
        if (error != nil) {
            AlertManager.shared.showAlertWithError(inVC: self, message: error!.localizedDescription)
        }
        else {
            AccessToken.current = nil
            self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    func didReceive(error: Error) {
        AlertManager.shared.showAlertWithError(inVC: self, message: error.localizedDescription)
    }
}
