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
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblHowCanWeImprove: UILabel!
    
    @IBOutlet weak var btnSend: CustomButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegates()
        customizeTextView()
        customizeTf()
        addGestures()
        setLocalized()
    }
    
    private func setDelegates() {
        tfName.becomeFirstResponder()
        Firebase.shared.delegate = self
    }
    
    private func setLocalized() {
        lblName.text = locStr("name")
        lblHowCanWeImprove.text = locStr("improve")
        btnSend.setTitle(locStr("send"), for: .normal)
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
            AlertManager.shared.showAlertWithError(inVC: self, message: locStr("alert_name_empty"))
            return false
        }
        else if textViewMessage.text == "" {
            AlertManager.shared.showAlertWithError(inVC: self, message: locStr("alert_body_empty"))
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
    
    private func locStr(_ string : String) -> String {
        return NSLocalizedString("message_" + string, comment: "")
    }
}

extension MessageVC : FirebaseDelegate {
    func didReceive(error: Error) {
        AlertManager.shared.showAlertWithError(inVC: self, message: error.localizedDescription)
        loader.stopAnimating()
    }
    
    func didSaveMessage() {
        AlertManager.shared.showAlertGenericMessage(inVC: self, message: locStr("alert_message_sent"))
        loader.stopAnimating()
    }
    
}
