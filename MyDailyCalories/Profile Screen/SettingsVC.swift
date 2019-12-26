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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        Firebase.shared.delegate = self
    }
    
    @IBAction func logoutTapped(_ sender: CustomButton) {
        sender.animateTap()
        Firebase.shared.tryLogOut()
    }
    
    @IBAction func resetHintsTapped(_ sender: CustomButton) {
        let alert_hints_reset = NSLocalizedString("alert_hints_reset", comment: "")
        AlertManager.shared.showAlertGenericMessage(inVC: self, message: alert_hints_reset)
        HintsManager.shared.shouldShowIntroInCalculator = true
        HintsManager.shared.shouldShowIntroInMyProducts = true
        sender.animateTap()
    }
    
    @IBAction func howCanWeImproveTapped(_ sender: CustomButton) {
        sender.animateTap()

    }
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
