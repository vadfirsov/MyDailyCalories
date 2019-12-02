//
//  ProfileVC.swift
//  MyDailyCalories
//
//  Created by VADIM FIRSOV on 01/12/2019.
//  Copyright © 2019 VADIM FIRSOV. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class ProfileVC : UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        FirebaseManager.shared.delegate = self
    }
    
    @IBAction func logoutTapped(_ sender: UIButton) {
        FirebaseManager.shared.tryLogOut()
    }
}

extension ProfileVC : FirebaseDelegate {
    func didLoggedOutWith(error: Error?) {
        if (error != nil) {
            AlertManager.shared.showAlertWithAuthError(inVC: self, message: error!.localizedDescription)
        }
        else {
            AccessToken.current = nil
            self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
        }
    }
}
