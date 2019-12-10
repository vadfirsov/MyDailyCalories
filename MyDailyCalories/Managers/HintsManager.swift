//
//  UserDefaults.swift
//  MyDailyCalories
//
//  Created by pionet\Alex.s on 10/12/2019.
//  Copyright © 2019 VADIM FIRSOV. All rights reserved.
//

import UIKit

class HintsManager {
    
    static let shared = HintsManager()
    private init() {}
    
    private let userDefs = UserDefaults.standard
    private let didShowIntroInMyProducts = "didShowIntroInMyProducts"
    
    var shouldShowIntroInMyProducts : Bool? {
        get {
            if userDefs.value(forKey: didShowIntroInMyProducts) == nil {
                return nil
            }
            return userDefs.bool(forKey: didShowIntroInMyProducts)
        }
        set {
            userDefs.set(newValue, forKey: didShowIntroInMyProducts)
        }
    }
}
