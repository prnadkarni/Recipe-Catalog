//
//  Recipe.swift
//  FoodTracker
//
//  Created by Pooja Nadkarni on 1/16/19.
//  Copyright © 2019 Pooja Nadkarni. All rights reserved.
//

import UIKit
import os.log

class Recipe: NSObject, NSCoding {
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(ingredients, forKey: PropertyKey.ingredients)
        aCoder.encode(directions, forKey: PropertyKey.directions)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        //The name must exist
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Recipe object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let ingredients = aDecoder.decodeObject(forKey: PropertyKey.ingredients) as? String else {
            os_log("Unable to decode the ingredients for a Recipe object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let directions = aDecoder.decodeObject(forKey: PropertyKey.directions) as? String else {
            os_log("Unable to decode the directions for a Recipe object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Because photo is an optional property of Recipe, a conditional cast can be used.
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        
        //Calls initializer.
        self.init(name: name, photo: photo, ingredients: ingredients, directions: directions)
    }
    
    //MARK: Properties
    var name: String
    var photo: UIImage?
    var ingredients: String
    var directions: String
    
    init?(name: String, photo: UIImage?, ingredients: String, directions: String) {
        //Fail if name is an empty string or rating is less than 0
        if name.isEmpty || ingredients.isEmpty || directions.isEmpty {
            return nil
        }
        
        //Initialize stored properties
        self.name = name
        self.photo = photo
        self.ingredients = ingredients
        self.directions = directions
    }
    
    //MARK: Types
    struct PropertyKey {
        static let name = "name"
        static let photo = "photo"
        static let ingredients = "ingredients"
        static let directions = "directions"
    }
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("recipes")
}
