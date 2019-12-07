//
//  Entity.swift
//  MyDailyCalories
//
//  Created by VADIM FIRSOV on 24/11/2019.
//  Copyright © 2019 VADIM FIRSOV. All rights reserved.
//

import UIKit

struct Entity {
    
    var name =     ""
    var calories = "0.0"
    var protein =  "0.0"
    var carbs =    "0.0"
    var fat =      "0.0"
    
    init() {}
    
    init(name: String, calories: String, protein: String, carbs: String, fat: String) {
        self.name =     name
        self.calories = calories
        self.protein =  protein
        self.carbs =    carbs
        self.fat =      fat
    }
    
    init(withDict dict : [String : String]) {
        self.name =     dict["name"]     ?? ""
        self.calories = dict["calories"] ?? "0.0"
        self.protein =  dict["protein"]  ?? "0.0"
        self.carbs =    dict["carbs"]    ?? "0.0"
        self.fat =      dict["fat"]      ?? "0.0"
    }
    
    func entityDict() -> [String : String] {
        let entityDict = ["name" :     name,
                          "calories" : calories,
                          "protein" :  protein,
                          "carbs" :    carbs,
                          "fat" :      fat]
        return entityDict
    }
}
