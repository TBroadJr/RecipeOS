//
//  Recipe+CoreDataProperties.swift
//  RecipeOS
//
//  Created by Tornelius Broadwater, Jr on 9/27/22.
//
//

import Foundation
import CoreData


extension Recipe {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Recipe> {
        return NSFetchRequest<Recipe>(entityName: "Recipe")
    }

    @NSManaged public var title: String?
    @NSManaged public var cookingTime: Int16
    @NSManaged public var servings: Int16
    @NSManaged public var sourceURL: URL?
    @NSManaged public var image: URL?
    @NSManaged public var ingredients: String?
    @NSManaged public var id: UUID?

}

extension Recipe : Identifiable {

}
