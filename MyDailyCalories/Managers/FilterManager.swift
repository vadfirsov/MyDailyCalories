//
//  FilterManager.swift
//  MyDailyCalories
//
//  Created by VADIM FIRSOV on 26/11/2019.
//  Copyright © 2019 VADIM FIRSOV. All rights reserved.
//

import Foundation

class FilterManager {
    
    static let shared = FilterManager()
    private init() {}
    
    func filtered(entities : [Entity], by filter : Filter, lowerToHigher : Bool) -> [Entity] {
        let filteredEntities = entities.sorted { (p1, p2) -> Bool in

            var d1 = 0.0
            var d2 = 0.0
            switch filter {
            case.name :
                switch lowerToHigher {
                case true : return p1.name > p2.name
                case false : return p1.name < p2.name
                }
            case.protein :
                d1 = doubleFrom(string: p1.protein)
                d2 = doubleFrom(string: p2.protein)
            case.cal :
                d1 = doubleFrom(string: p1.calories)
                d2 = doubleFrom(string: p2.calories)
            case.carbs :
                d1 = doubleFrom(string: p1.carbs)
                d2 = doubleFrom(string: p2.carbs)
            case.fat :
                d1 = doubleFrom(string: p1.fat)
                d2 = doubleFrom(string: p2.fat)
            }
            
            return lowerToHigher ? (d1 > d2) : (d1 < d2)
        }

        return filteredEntities
    }
    
    private func doubleFrom(string : String) -> Double {
        if let double = Double(string) {
            return double
        }
        else {
            return 0.0
        }
    }
    
    func entities(_ entities : [Entity], contain string : String) -> [Entity] {
        var filteredEntities = [Entity]()
        if string.isEmpty {
            filteredEntities = entities
        }
        else {
            filteredEntities = entities.filter({ $0.name.contains(string) })
        }
        return filteredEntities
    }
}

enum Filter {
    case name, cal, protein, carbs, fat
}

