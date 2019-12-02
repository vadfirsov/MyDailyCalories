//
//  LoginVC.swift
//  MyDailyCalories
//
//  Created by VADIM FIRSOV on 26/11/2019.
//  Copyright © 2019 VADIM FIRSOV. All rights reserved.
//

import UIKit
import FirebaseUI
import GoogleSignIn
import FBSDKLoginKit
//import FirebaseAu

class LoginVC : UIViewController {
    
    private let segueID = "goToDailyCals"
    private let signInIndex = 0
    
    @IBOutlet weak var tfName:  UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPw:    UITextField!
    @IBOutlet weak var tfPw2:   UITextField!
    @IBOutlet weak var segment: UISegmentedControl!
    
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    @IBOutlet weak var btnGoogleLogin: GIDSignInButton! 
    @IBOutlet weak var btnFBLogin:     FBLoginButton! {
        didSet {btnFBLogin.permissions = ["public_profile", "email"] } }
    
    @IBOutlet var textFields: [UITextField]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FirebaseManager.shared.delegate = self
        btnFBLogin.delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.signOut()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setTextFields()
        addGestures()
        //mockdata
        tfEmail.text = "test@t.com"
        tfPw.text = "123456"
    }

    private func addGestures() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                 action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func setTextFields() {
        for tf in textFields {
            tf.delegate = self
        }
        hideShowTextFields()
    }
        
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        loader.stopAnimating()
    }

    @IBAction func segmentValueChanged(_ sender: UISegmentedControl) {
        hideShowTextFields()
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        loader.startAnimating()
        let login = SignInManager(name:  tfName.text,
                                 email: tfEmail.text ?? "",
                                 pw:    tfPw.text ?? "",
                                 pw2:   tfPw2.text)
        login.delegate = self
        if segment.selectedSegmentIndex == signInIndex {
            login.performSignIn()
        }
        else {
            login.performSignUp()
        }
    }
    
    private func moveToNextTF() {
        
        for i in textFields.indices {
            if textFields[i].isFirstResponder {
                if textFields[i] == textFields.last {
                    if !textFields[0].isHidden {
                        textFields[0].becomeFirstResponder()
                    }
                    else {
                        tfEmail.becomeFirstResponder()
                    }
                }
                else {
                    if !textFields[i+1].isHidden {
                        textFields[i+1].becomeFirstResponder()
                    }
                    else {
                        tfEmail.becomeFirstResponder()
                    }
                }
                return
            }
        }
    }
    
    private func hideShowTextFields() {
        let isSignInChosen = segment.selectedSegmentIndex == 0
        tfName.isHidden =         isSignInChosen
        tfPw2.isHidden =          isSignInChosen
        btnFBLogin.isHidden =     !isSignInChosen
        btnGoogleLogin.isHidden = !isSignInChosen
    }
}

extension LoginVC : FirebaseDelegate {
    
    func loginSuccess() {
        loader.stopAnimating()
        if segment.selectedSegmentIndex != signInIndex {
            FirebaseManager.shared.saveNewUserWith(userName: tfName.text!)
        }
        else {
            performSegue(withIdentifier: segueID, sender: self)
        }
    }
    
    func loginFailedWith(error: String) {
        loader.stopAnimating()
        AlertManager.shared.showAlertWithAuthError(inVC: self, message: error)
    }
    
    func savedUserName() {
        performSegue(withIdentifier: segueID, sender: self)
    }
    
    func autoLogin() {
        performSegue(withIdentifier: segueID, sender: self) //is needed?
    }
}

extension LoginVC : LoginDelegate {
    func authentication(error: String) {
        loader.stopAnimating()
        AlertManager.shared.showAlertWithAuthError(inVC: self, message: error)
    }
}

extension LoginVC : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        moveToNextTF()
        return true
    }
}

extension LoginVC : GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil {
            AlertManager.shared.showAlertWithAuthError(inVC: self, message: error.localizedDescription)
        }
        else if user != nil {
            loader.startAnimating()
            FirebaseManager.shared.signInWithGoogle(user: user)
        }
    }
}

extension LoginVC : LoginButtonDelegate {
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("logout")
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if error != nil {
            AlertManager.shared.showAlertWithAuthError(inVC: self, message: error!.localizedDescription)
        }
        else {
            FirebaseManager.shared.signInWithFB()
        }
    }
    
    func loginButtonWillLogin(_ loginButton: FBLoginButton) -> Bool {
        return true
    }
    
    
}
