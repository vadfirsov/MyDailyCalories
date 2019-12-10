//
//  ProductsIntroview.swift
//  MyDailyCalories
//
//  Created by pionet\Alex.s on 09/12/2019.
//  Copyright © 2019 VADIM FIRSOV. All rights reserved.
//

import UIKit

protocol ProductsIntroViewDelegate {
    func didTapLoadProducts()
    func didTapAddProduct()
}

class ProductsIntroView : UIView {
    
    var delegate : ProductsIntroViewDelegate?
    
    //MARK: VARS
    private let lenghFromOrigin :    CGFloat = 40
    private let btnLenghFromOrigin : CGFloat = 50
    private let btnHeight :          CGFloat = 30
    private let spaceBetweenBtns :   CGFloat = 40
    private var label = UILabel()

    private var buttonWidth : CGFloat {
        let availableWidth = frame.size.width - (btnLenghFromOrigin * 2) - spaceBetweenBtns
        return availableWidth / 2
    }
    
    private var btnLoadProducts = UIButton()
    
    private var btnAddNew = UIButton()
    
    private var or : UILabel {
        let frame = CGRect(x: btnLenghFromOrigin + buttonWidth, y: 360, width: spaceBetweenBtns, height: btnHeight)
        let label = UILabel(frame: frame)
        label.text = "OR"
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        label.textAlignment = .center
        return label
    }
    


    private var labelFrame : CGRect {
        var lblFrame = CGRect()
        lblFrame.origin.x = lenghFromOrigin
        lblFrame.origin.y = 150
        lblFrame.size.height = 200
        lblFrame.size.width = (frame.size.width - (lenghFromOrigin * 2))
        return lblFrame
    }

    //MARK: DID MOVE TO SUPERVIE
    override func didMoveToSuperview() {
        animateEntrence()
        addTapGesture()
    }
    
    //MARK: DESIGN STUFF
    private func addText() {
        label = UILabel(frame: labelFrame)
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        
        setTextSpacing()
        addSubview(label)
    }
    
    private func addButtons() {
        let x = btnLenghFromOrigin + buttonWidth + spaceBetweenBtns
        let btnAddNew = UIButton(frame: CGRect(x: x, y: 350, width: buttonWidth, height: btnHeight))
        setStyleFor(btn: btnAddNew)
        btnAddNew.addTarget(self, action: #selector(tappedOnAddProduct), for: .touchUpInside)
        btnAddNew.setTitle("Add Product", for: .normal)
        addSubview(btnAddNew)

        btnLoadProducts = UIButton(frame: CGRect(x: btnLenghFromOrigin, y: 350, width: buttonWidth, height: btnHeight))
        setStyleFor(btn: btnLoadProducts)
        btnLoadProducts.setTitle("Load Products", for: .normal)
        btnLoadProducts.addTarget(self, action: #selector(tappedOnLoadProducts), for: .touchUpInside)
        addSubview(btnLoadProducts)

    }
    
    private func addOr() {
        addSubview(or)
    }
    
    private func setStyleFor(btn : UIButton) {
        let bgColor =     #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        let textColor =   #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        let borderColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
               
        btn.backgroundColor = bgColor
        btn.setTitleColor(textColor, for: .normal)
        btn.layer.borderColor = borderColor.cgColor
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        btn.layer.cornerRadius = 8
        btn.clipsToBounds = true
        btn.layer.borderWidth = 1.25
    }
    
    private func setTextSpacing() {
        let attributedString = NSMutableAttributedString(string: "Pssst!.. \n Here you can load ready-to-use products or add your own products that you use daily! \n *You can always go back to Settings and add / remove ready-to-use products 🤓")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle,
                                      value:paragraphStyle,
                                      range:NSMakeRange(0, attributedString.length))
        label.attributedText = attributedString
        label.textAlignment = .center
    }
    
    //MARK: ANIMATION
    private func animateEntrence() {
        backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        addText()
        addButtons()
        addOr()
        UIView.animate(withDuration: 0.3) {
            self.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.8001391267)
            self.label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.or.textColor =    #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
    }
        
    //MARK: ACTIONS
    private func addTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapOnScreen))
        addGestureRecognizer(tap)
    }
    
    @objc private func didTapOnScreen() {
        removeFromSuperview()
    }
    
    @objc private func tappedOnLoadProducts() {
        delegate?.didTapLoadProducts()
    }
    
    @objc private func tappedOnAddProduct() {
        self.delegate?.didTapAddProduct()
    }
}

