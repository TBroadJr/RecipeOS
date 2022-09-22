//
//  Recipe+CoreDataProperties.swift
//  RecipeOS
//
//  Created by Tornelius Broadwater, Jr on 9/22/22.
//
//

import Foundation
import CoreData


extension Recipe {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Recipe> {
        return NSFetchRequest<Recipe>(entityName: "Recipe")
    }

    @NSManaged public var calories: Double
    @NSManaged public var cookingTime: Double
    @NSManaged public var image: URL?
    @NSManaged public var ingredients: String?
    @NSManaged public var label: String?
    @NSManaged public var sourceURL: URL?
    
    public var unwrappedImage: URL {
        image ?? URL(string: "www.google.com")!
    }
    
    public var unwrappedIngredients: [String] {
        let newIngredients = ingredients?.components(separatedBy: "$")
        return newIngredients ?? [String]()
    }
    
    public var unwrappedLabel: String {
        label ?? "No Label"
    }
    
    public var unwrappedSourceURL: URL {
        sourceURL ?? URL(string: "www.google.com")!
    }

}

extension Recipe : Identifiable {

}
