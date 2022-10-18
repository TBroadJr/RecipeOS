//
//  Recipe+CoreDataProperties.swift
//  RecipeOS
//
//  Created by Tornelius Broadwater, Jr on 10/17/22.
//
//

import Foundation
import CoreData


extension Recipe {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Recipe> {
        return NSFetchRequest<Recipe>(entityName: "Recipe")
    }

    @NSManaged public var cookingTime: Int16
    @NSManaged public var id: UUID?
    @NSManaged public var imageData: Data?
    @NSManaged public var imageURL: URL?
    @NSManaged public var ingredients: String?
    @NSManaged public var instructions: String?
    @NSManaged public var isCreated: Bool
    @NSManaged public var servings: Int16
    @NSManaged public var sourceURL: URL?
    @NSManaged public var title: String?
    @NSManaged public var isFavorited: Bool
    
    public var cookingTimeInt: Int {
        Int(cookingTime)
    }
    
    public var unwrappedID: UUID {
        id ?? UUID()
    }
    
    public var unwrappedImageURL: URL {
        imageURL ?? URL(string: "https://picsum.photos/200")!
    }
    
    public var unwrappedIngredients: [String] {
        var array = [String]()
        guard let ingredientsString = ingredients else {
            return array
        }
        array = ingredientsString.components(separatedBy: "$")
        return array
    }
    
    public var servingsInt: Int {
        Int(servings)
    }
    
    public var unwrappedSourceURL: URL {
        sourceURL ?? URL(string: "www.google.com")!
    }
    
    public var unwrappedTitle: String {
        title ?? "No Title"
    }
    
    public var created: Bool {
        isCreated
    }
    
    public var unwrappedImageData: Data {
        imageData ?? Data()
    }
    
    public var unwrappedInstructions: [String] {
        var array = [String]()
        guard let instructionsString = instructions else {
            return array
        }
        array = instructionsString.components(separatedBy: "$")
        return array
    }

}

extension Recipe : Identifiable {

}
