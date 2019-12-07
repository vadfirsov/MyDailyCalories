//
//  CustomSegment.swift
//  MyDailyCalories
//
//  Created by pionet\Alex.s on 05/12/2019.
//  Copyright © 2019 VADIM FIRSOV. All rights reserved.
//

import UIKit

class CustomSegment : UISegmentedControl {

    private var oldValue : Int!
    
    var isSignInChosen : Bool {
        let signInIndex = 0
        return self.selectedSegmentIndex == signInIndex
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.layer.shadowOffset = CGSize(width: 1, height: 2)
        self.layer.masksToBounds = false
        self.layer.shadowOpacity = 0.5
        
        self.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .selected)
    }
    
    //CHECKS IF TAPPED ON ALREADY SELECTED SEGMENT
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.oldValue = self.selectedSegmentIndex
        super.touchesBegan( touches , with: event )
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded( touches , with: event )

        if self.oldValue == self.selectedSegmentIndex {
            sendActions(for: .touchUpInside)
        }
    }
}
