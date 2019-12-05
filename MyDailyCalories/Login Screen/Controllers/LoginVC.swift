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
    private var isKeyboardShown = false
    
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPw:    UITextField!
    @IBOutlet weak var tfPw2:   UITextField!
    @IBOutlet weak var segment: CustomSegment! 

    
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    @IBOutlet weak var btnFbSignIn:     CustomBtn! {
        didSet { btnFbSignIn.setFbDesign()}
    }
    @IBOutlet weak var btnGoogleSignIn: CustomBtn! {
        didSet { btnGoogleSignIn.setGoogleDesign()}
    }


    @IBOutlet var textFields: [UITextField]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FirebaseManager.shared.delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setTextFields()
        addGestures()
        //mockdata
        tfEmail.text = "test@t.com"
        tfPw.text = "123456"
        
    }
    
    @IBAction func segmentValueChanged(_ sender: UISegmentedControl) {
        hideShowTextFields()
    }
    
    @IBAction func sameSegmentTapped(_ sender: CustomSegment) {
        loader.startAnimating()
        let login = SignInManager(email: tfEmail.text ?? "",
                                  pw:    tfPw.text ?? "",
                                  pw2:   tfPw2.text)
        login.delegate = self
        
        switch segment.isSignInChosen {
        case true : login.performSignIn()
        case false : login.performSignUp()
        }
    }
    
    @IBAction func fbSignInTapped(_ sender: UIButton) {
        let fbLoginManager = LoginManager()

        fbLoginManager.logIn(permissions: ["public_profile", "email"], from: self) { (result, error) -> Void in
            if (error != nil) {
                AlertManager.shared.showAlertWithAuthError(inVC: self, message: error!.localizedDescription)
                return
            }
            if (result?.isCancelled)! {
                return
            }
            else if (result!.grantedPermissions.contains("email")) {
                FirebaseManager.shared.signInWithFB()
            }
        }
    }
    
    @IBAction func googleSignInTapped(_ sender: CustomBtn) {
        GIDSignIn.sharedInstance()?.signIn()
    }

    private func addGestures() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            isKeyboardShown = true
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        isKeyboardShown = false
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
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

        tfPw.isHidden =            segment.isSignInChosen
        tfPw2.isHidden =           segment.isSignInChosen
        btnFbSignIn.isHidden =     !segment.isSignInChosen
        btnGoogleSignIn.isHidden = !segment.isSignInChosen
        if isKeyboardShown {
            tfPw.isHidden = false
        }
    }
}

extension LoginVC : FirebaseDelegate {
    
    func loginSuccess() {
        loader.stopAnimating()
        performSegue(withIdentifier: segueID, sender: self)
    }
    
    func loginFailedWith(error: String) {
        loader.stopAnimating()
        AlertManager.shared.showAlertWithAuthError(inVC: self, message: error)
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if segment.isSignInChosen {
            tfPw.isHidden = false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
         if segment.isSignInChosen {
            tfPw.isHidden = true
        }
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
