//
//  ProductModal.swift
//  MyDailyCalories
//
//  Created by VADIM FIRSOV on 21/11/2019.
//  Copyright © 2019 VADIM FIRSOV. All rights reserved.
//

import Foundation

struct Product {

    var name =     ""
    var calories = ""
    var protein =  ""
    var carbs =    ""
    var fat =      ""
    var isNew =    false
    
    var dateString = DateManager.shared.stringFrom(date: Date())

    var date = Date() 
    
    init(name : String, calories : String, protein : String, carbs : String, fat : String) {
        self.name =     name
        self.calories = calories
        self.protein =  protein
        self.carbs =    carbs
        self.fat =      fat
        self.date =     Date()
    }
    
    init() {
        isNew = true
    }
    
    init(withDict dict : [String : String], dateString : String) {
        self.name =       dict["name"]     ?? ""
        self.calories =   dict["calories"] ?? "0.0"
        self.protein =    dict["protein"]  ?? "0.0"
        self.carbs =      dict["carbs"]    ?? "0.0"
        self.fat =        dict["fat"]      ?? "0.0"
        let date =        dict["date"]     ?? ""
        self.dateString = dateString
        self.date = DateManager.shared.dateFrom(string: date) ?? Date()
    }
    
    func productDict() -> [String : String] {
        let productDic = ["name" :     name,
                          "calories" : calories,
                          "protein" :  protein,
                          "carbs" :    carbs,
                          "fat" :      fat,
                          "date" :     "\(date)"]
        return productDic
    }
}

