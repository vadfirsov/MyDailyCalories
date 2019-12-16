//
//  CustomCellView.swift
//  MyDailyCalories
//
//  Created by pionet\Alex.s on 08/12/2019.
//  Copyright © 2019 VADIM FIRSOV. All rights reserved.
//

import UIKit

class CustomCellView : UIView {
    
    private let borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.1034621147)
    private let bgColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.2009578339)
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        customize()
    }
    
    private func customize() {
        layer.cornerRadius = 8
        clipsToBounds = true
        layer.borderWidth = 0.75
        backgroundColor = bgColor
        layer.borderColor = borderColor.cgColor
    }
    
//    private func addShadow() {
//        self.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
//        self.layer.shadowOffset = CGSize(width: 1, height: 2)
//        self.layer.masksToBounds = false
//        self.layer.shadowOpacity = 0.5
//    }
//
//    func addIcon(named iconName : String) {
//        let iconImageView = UIImageView(frame: CGRect(x: 6, y: 0, width: 34, height: 34))
//        if let icon = UIImage(named: iconName) {
//            iconImageView.image = icon
//        }
//        self.addSubview(iconImageView)
//    }
//
//    func animateTap(bgColor : UIColor, borderColor : UIColor) {
//        let originBgColor =      backgroundColor
//        let originBorderColor =  layer.borderColor
//        backgroundColor =        bgColor
//        layer.borderColor =      borderColor.cgColor
//
//        UIView.animate(withDuration: 0.2) {
//            self.backgroundColor =   originBgColor
//            self.layer.borderColor = originBorderColor
//        }
//    }
    
}
