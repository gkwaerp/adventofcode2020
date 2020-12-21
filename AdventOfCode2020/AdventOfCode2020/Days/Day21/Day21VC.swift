//
//  Day21VC.swift
//  AdventOfCode2020
//
//  Created by Geir-Kåre S. Wærp on 21/12/2020.
//

import UIKit

class Day21VC: AoCVC, AdventDay, InputLoadable {
    private class Ingredient: Hashable, Equatable {
        static func == (lhs: Ingredient, rhs: Ingredient) -> Bool {
            return lhs.name == rhs.name
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(self.name)
        }
        
        let name: String
        var allergen: String?
        
        init(name: String) {
            self.name = name
            self.allergen = nil
        }
    }
    
    private struct Food {
        let ingredients: Set<Ingredient>
        let allergens: Set<String>
        
        static func from(_ string: String) -> Food {
            let split = string.components(separatedBy: " (contains ")
            let ingredients = Set(split[0].components(separatedBy: " ").map({Ingredient(name: $0)}))
            let allergens = Set(split[1]
                .replacingOccurrences(of: ")", with: "")
                .components(separatedBy: ", "))
            return Food(ingredients: ingredients, allergens: allergens)
        }
    }
    
    private var foods: [Food] = []
    
    func loadInput() {
        let input = self.defaultInputFileString.loadAsTextStringArray()
        self.foods = input.map({Food.from($0)})
    }
    
    func solveFirst() {
        let result = self.part1(self.foods)
        self.setSolution(challenge: 0, text: "\(result)")
    }
    
    func solveSecond() {
        let result = self.part2(self.foods)
        self.setSolution(challenge: 1, text: result)
    }
    
    private func part1(_ foods: [Food]) -> Int {
        let allIngredients = Set(foods.flatMap({$0.ingredients}))
        var potentials: [String : Set<Ingredient>] = [:] // Allergen --> Ingredients
        
        for food in foods {
            for allergen in food.allergens {
                potentials[allergen, default: allIngredients].formIntersection(food.ingredients)
            }
        }
        
        let anallergenicIngredientsRaw = allIngredients.compactMap { (ingredient) -> Ingredient? in
            for potential in potentials.values {
                if potential.contains(ingredient) {
                    return nil
                }
            }
            return ingredient
        }
        let anallergenicIngredients = Set(anallergenicIngredientsRaw)
        let anallergenicIngredientCount = foods.map({$0.ingredients.filter({anallergenicIngredients.contains($0)}).count}).reduce(0, +)
        
        return anallergenicIngredientCount
    }
    
    private func part2(_ foods: [Food]) -> String {
        let allAllergens = Set(foods.flatMap({$0.allergens}))
        let allIngredients = Set(foods.flatMap({$0.ingredients}))
        var potentials: [String : Set<Ingredient>] = [:] // Allergen --> Ingredients
        
        for food in foods {
            for allergen in food.allergens {
                potentials[allergen, default: allIngredients].formIntersection(food.ingredients)
            }
        }
        
        var done = false
        while !done {
            done = true
            for allergen in allAllergens {
                let potential = potentials[allergen]!
                if potential.count > 1 {
                    done = false
                    
                    let otherAllergens = allAllergens.filter({$0 != allergen})
                    let resolvedAllergens = otherAllergens.filter({potentials[$0]!.count == 1})
                    for resolvedAllergen in resolvedAllergens {
                        potentials[allergen]!.subtract(potentials[resolvedAllergen]!)
                    }
                }
            }
        }
        
        for allergen in allAllergens {
            let ingredient = potentials[allergen]!.first!
            ingredient.allergen = allergen
        }
        
        let sortedIngredientNames = allIngredients
            .filter({$0.allergen != nil})
            .sorted(by: {$0.allergen! < $1.allergen!})
            .map({$0.name})
            .joined(separator: ",")
        
        return sortedIngredientNames
    }
}

extension Day21VC: TestableDay {
    func runTests() {
        let testInput =
        """
        mxmxvkd kfcds sqjhc nhms (contains dairy, fish)
        trh fvjkl sbzzf mxmxvkd (contains dairy)
        sqjhc fvjkl (contains soy)
        sqjhc mxmxvkd sbzzf (contains fish)
        """.components(separatedBy: "\n")
        
        let foods = testInput.map({Food.from($0)})
        let p1 = self.part1(foods)
        assert(p1 == 5)
        
        let p2 = self.part2(foods)
        assert(p2 == "mxmxvkd,sqjhc,fvjkl")
    }
}
