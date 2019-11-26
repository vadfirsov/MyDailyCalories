//
//  CartEntity.swift
//  MyDailyCalories
//
//  Created by VADIM FIRSOV on 25/11/2019.
//  Copyright © 2019 VADIM FIRSOV. All rights reserved.
//

import Foundation

struct CartEntity {
    
    var name =     ""
    var grams =    0.0
    var calories = 0.0
    var protein =  0.0
    var carbs =    0.0
    var fat =      0.0
    
    func cartEntityDic() -> [String : Double] {
        return ["grams" :    grams,
                "calories" : calories,
                "protein" :  protein,
                "carbs" :    carbs,
                "fat" :      fat]
    }
    
    init() {}
    
    init(fromDict dict : [String : Double], name : String) {
        self.name = name
        calories =  dict["calories"] ?? 0.0
        protein =   dict["protein"]  ?? 0.0
        carbs =     dict["carbs"]    ?? 0.0
        fat =       dict["fat"]      ?? 0.0
        grams =     dict["grams"]    ?? 0.0
    }
    
    mutating func devidePropertiesBy(_ servings : Double) {
        grams /=    servings
        calories /= servings
        protein /=  servings
        carbs /=    servings
        fat /=      servings
    }
}
