//
//  CustomBtn.swift
//  MyDailyCalories
//
//  Created by pionet\Alex.s on 05/12/2019.
//  Copyright © 2019 VADIM FIRSOV. All rights reserved.
//

import UIKit

class CustomBtn : UIButton {

    private let fbColor =          #colorLiteral(red: 0.143147856, green: 0.3265746236, blue: 0.7066633105, alpha: 1)
    private let googleColor =      #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    private let greenBtnColor =    #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
    private let redBtnColor =      #colorLiteral(red: 1, green: 0.4007155299, blue: 0.2614966631, alpha: 1)
    private let googleLabelColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        customize()
    }
    
    private func customize() {
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
        addShadow()
    }
    
    private func addShadow() {
        self.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.layer.shadowOffset = CGSize(width: 1, height: 2)
        self.layer.masksToBounds = false
        self.layer.shadowOpacity = 0.5
    }
    
    func setFbDesign() {
        self.backgroundColor = fbColor
        add(iconName: "fb_icon")
        add(labelString: "Sign-In with Facebook")
    }
    
    func setGoogleDesign() {
        self.backgroundColor = googleColor
        add(iconName: "google_icon")
        add(labelString: "Sign-In with Google")
        self.setTitleColor(googleLabelColor, for: .normal)
    }
    
//    func setSignInDesign() {
//        add(labelString: "Sign-In")
//    }
    
    func setLogoutDesign() {
        
    }
    
    private func add(iconName : String) {
        let iconImageView = UIImageView(frame: CGRect(x: 6, y: 0, width: 34, height: 34))
        if let icon = UIImage(named: iconName) {
            iconImageView.image = icon
        }
        self.addSubview(iconImageView)
    }
    
    private func add(labelString : String) {
        self.setTitle(labelString, for: .normal)
    }
}
