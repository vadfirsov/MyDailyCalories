//
//  PreLoginVC.swift
//  MyDailyCalories
//
//  Created by VADIM FIRSOV on 28/11/2019.
//  Copyright © 2019 VADIM FIRSOV. All rights reserved.
//

import UIKit

class PreLoginVC : UIViewController {
    private let goToLogin = "goToLogin"
    private let goToMainScreen = "goToMainScreen"
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        AdMob.shared.requestInterstitialAd()
        Firebase.shared.loadUserWatchedAdDate()
        Firebase.shared.delegate = self
        Firebase.shared.checkIfUserLoggedIn() //leak
        
    }
}

extension PreLoginVC : FirebaseDelegate {
    func isUser(login: Bool) {
        if login {
            performSegue(withIdentifier: goToMainScreen, sender: self)
        }
        else {
            performSegue(withIdentifier: goToLogin, sender: self)
        }
    }
}
