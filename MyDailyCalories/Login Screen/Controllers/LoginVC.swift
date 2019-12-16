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
import AuthenticationServices

class LoginVC : UIViewController {
    
    private let segue_to_daily_cals = "go_to_daily_cals"
    private var isKeyboardShown = false
    private var currentNonce: String?
    
    @IBOutlet weak var tfEmail: CustomTextField! {
        didSet { tfEmail.setPlaceholder(string: "email") }
    }
    @IBOutlet weak var tfPw:    CustomTextField! {
        didSet { tfPw.setPlaceholder(string: "password") }
    }
    @IBOutlet weak var tfPw2:   CustomTextField!{
        didSet { tfPw2.setPlaceholder(string: "repeat password") }
    }
    
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    @IBOutlet weak var segment:         CustomSegment!
    @IBOutlet weak var btnFbSignIn:     FacebookButton!
    @IBOutlet weak var btnGoogleSignIn: GoogleButton!
    @IBOutlet weak var btnApple:        AppleButton!


    @IBOutlet var textFields: [UITextField]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnApple.isHidden = true
        Firebase.shared.delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.delegate = self
        setTextFields()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        addGestures()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func segmentValueChanged(_ sender: UISegmentedControl) {
        hideShowTextFields()
    }
    
    @IBAction func sameSegmentTapped(_ sender: CustomSegment) {
        loader.startAnimating()
        let login = Authentication(email: tfEmail.text ?? "",
                                  pw:    tfPw.text ?? "",
                                  pw2:   tfPw2.text)
        login.delegate = self
        
        switch segment.isSignInChosen {
        case true : login.performSignIn()
        case false : login.performSignUp()
        }
    }
    
    
    @IBAction func appleSignInTapped(_ sender: AppleButton) {
        let appleSignIn = AppleSignIn()
        if #available(iOS 13, *) {

            currentNonce = appleSignIn.startSignInWithAppleFlow(inVC: self)
        }
    }
    
    @IBAction func fbSignInTapped(_ sender: FacebookButton) {
        let fbLoginManager = LoginManager()
        sender.animateTap(bgColor: sender.animatedBgColor, borderColor: sender.animatedBorderColor)
        fbLoginManager.logIn(permissions: ["public_profile", "email"], from: self) { (loginResult, error) -> Void in
            if (error != nil) {
                AlertManager.shared.showAlertWithError(inVC: self, message: error!.localizedDescription)
                return
            }
            else if let result = loginResult {
                if result.isCancelled {
                    return
                }
                else if result.grantedPermissions.contains("email") {
                    Firebase.shared.signInWithFB()
                }
            }
        }
    }
    
    @IBAction func googleSignInTapped(_ sender: GoogleButton) {
        sender.animateTap(bgColor: sender.animatedBgColor, borderColor: sender.animatedBorderColor)
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
                let index = textFields[i] == textFields.last ? 0 : 1 + i
                if textFields[index].isHidden {
                    tfEmail.becomeFirstResponder()
                }
                else {
                    textFields[index].becomeFirstResponder()
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
        if #available(iOS 13, *) {
            btnApple.isHidden =    !segment.isSignInChosen
        }
        if isKeyboardShown {
            tfPw.isHidden = false
        }
    }
}

extension LoginVC : FirebaseDelegate {
    func didReceive(error: Error) {
        AlertManager.shared.showAlertWithError(inVC: self, message: error.localizedDescription)
    }
    
    func loginSuccess() {
        loader.stopAnimating()
        performSegue(withIdentifier: segue_to_daily_cals, sender: self)
    }
    
    func loginFailedWith(error: String) {
        loader.stopAnimating()
        AlertManager.shared.showAlertWithError(inVC: self, message: error)
    }

    func autoLogin() {
        performSegue(withIdentifier: segue_to_daily_cals, sender: self) //is needed?
    }
}

extension LoginVC : LoginDelegate {
    func authentication(error: String) {
        loader.stopAnimating()
        AlertManager.shared.showAlertWithError(inVC: self, message: error)
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
            AlertManager.shared.showAlertWithError(inVC: self, message: error.localizedDescription)
        }
        else if user != nil {
            loader.startAnimating()
            Firebase.shared.signInWithGoogle(user: user)
        }
    }
}

//MOCKDATA APPLE DELEGATE
@available(iOS 13.0, *)
extension LoginVC: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return ASPresentationAnchor()
    }
    

  func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
    if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                    fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                AlertManager.shared.showAlertWithError(inVC: self, message: "Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                let errorMessage = "Unable to serialize token string from data: \(appleIDToken.debugDescription)"
                AlertManager.shared.showAlertWithError(inVC: self, message: errorMessage)
                return
            }
        
        let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
        Firebase.shared.signInWithApple(credentials: credential)
        }
    
    }

    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    // Handle error.
        print("Sign in with Apple errored: \(error)")
    }
}
