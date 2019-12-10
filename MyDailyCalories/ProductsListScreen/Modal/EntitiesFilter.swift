//
//  FilterManager.swift
//  MyDailyCalories
//
//  Created by VADIM FIRSOV on 26/11/2019.
//  Copyright © 2019 VADIM FIRSOV. All rights reserved.
//

import Foundation

class EntitiesFilter {
    
    static let shared = EntitiesFilter()
    private init() {}
    
    var isLowestToHighest = true
    
    private func lowestToHighest(entities : [Entity], by filter : Filter) -> [Entity] {
        return entities.sorted { (p1, p2) -> Bool in
            switch filter {
            case.name :    return p1.name                         > p2.name
            case.protein : return doubleFrom(string: p1.protein)  > doubleFrom(string: p2.protein)
            case.cal :     return doubleFrom(string: p1.calories) > doubleFrom(string: p2.calories)
            case.carbs :   return doubleFrom(string: p1.carbs)    > doubleFrom(string: p2.carbs)
            case.fat :     return doubleFrom(string: p1.fat)      > doubleFrom(string: p2.fat)
            }
        }
    }
    
    private func highestToLowest(entities : [Entity], by filter : Filter) -> [Entity] {
        return entities.sorted { (p1, p2) -> Bool in
            switch filter {
            case.name :    return p1.name                         < p2.name
            case.protein : return doubleFrom(string: p1.protein)  < doubleFrom(string: p2.protein)
            case.cal :     return doubleFrom(string: p1.calories) < doubleFrom(string: p2.calories)
            case.carbs :   return doubleFrom(string: p1.carbs)    < doubleFrom(string: p2.carbs)
            case.fat :     return doubleFrom(string: p1.fat)      < doubleFrom(string: p2.fat)
            }
        }
    }
    
    func filtered(entities : [Entity], byFilter filter : Filter) -> [Entity] {
        isLowestToHighest = isLowestToHighest ? false : true
        if isLowestToHighest {
            return lowestToHighest(entities: entities, by: filter)
        }
        else {
            return highestToLowest(entities: entities, by: filter)
        }
    }
    
    private func doubleFrom(string : String) -> Double {
        return Double(string) ?? 0.0
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

