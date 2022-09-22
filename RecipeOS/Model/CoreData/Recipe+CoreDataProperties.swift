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

}

extension Recipe : Identifiable {

}
