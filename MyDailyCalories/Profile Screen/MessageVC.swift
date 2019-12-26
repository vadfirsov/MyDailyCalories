//
//  MessageVC.swift
//  MyDailyCalories
//
//  Created by pionet\Alex.s on 12/12/2019.
//  Copyright © 2019 VADIM FIRSOV. All rights reserved.
//

import UIKit

class MessageVC : UIViewController {
    
    let borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.1034621147)
//    let borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.1034621147)

    let bgColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.2009578339)
    
    @IBOutlet weak var textViewMessage: UITextView!
    @IBOutlet weak var tfName: CustomTextField!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegates()
        customizeTextView()
        customizeTf()
        addGestures()
    }
    
    private func setDelegates() {
        tfName.becomeFirstResponder()
        Firebase.shared.delegate = self
    }
    
    private func customizeTextView() {
        
        textViewMessage.layer.cornerRadius = 8
        textViewMessage.clipsToBounds = true
        textViewMessage.layer.borderWidth = 0.75
        textViewMessage.backgroundColor = bgColor
        textViewMessage.layer.borderColor = borderColor.cgColor
    }
    
    private func customizeTf() {
        tfName.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        tfName.layer.cornerRadius = 8
        tfName.clipsToBounds = true
        tfName.layer.borderWidth = 0.75
        tfName.backgroundColor = bgColor
        tfName.layer.borderColor = borderColor.cgColor
    }
    
    @IBAction func sendTapped(_ sender: CustomButton) {
        sender.animateTap()
        if isTextfieldsValid() {
            Firebase.shared.save(message: messageFromTextfields)
        }
    }
    
    private func isTextfieldsValid() -> Bool {
        if tfName.text == nil || tfName.text == "" {
            let alert_name_empty = NSLocalizedString("alert_name_empty", comment: "")
            AlertManager.shared.showAlertWithError(inVC: self, message: alert_name_empty)
            return false
        }
        else if textViewMessage.text == "" {
            let alert_body_empty = NSLocalizedString("alert_body_empty", comment: "")

            AlertManager.shared.showAlertWithError(inVC: self, message: alert_body_empty)
            return false
        }
        loader.startAnimating()
        return true
    }
    
    private var messageFromTextfields : String {
        let name = tfName.text ?? "no_name"
        let body = textViewMessage.text ?? "no_body"
        let message = name + " : " + body
        return message
    }
    
    private func addGestures() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                 action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension MessageVC : FirebaseDelegate {
    func didReceive(error: Error) {
        AlertManager.shared.showAlertWithError(inVC: self, message: error.localizedDescription)
        loader.stopAnimating()
    }
    
    func didSaveMessage() {
        let alert_message_sent = NSLocalizedString("alert_message_sent", comment: "")
        AlertManager.shared.showAlertGenericMessage(inVC: self, message: alert_message_sent)
        loader.stopAnimating()
    }
    
}
