//
//  RecipeTableViewController.swift
//  Notepad
//
//  Created by Pooja Nadkarni on 1/19/19.
//  Copyright © 2019 Pooja Nadkarni. All rights reserved.
//

import UIKit
import os.log

class RecipeTableViewController: UITableViewController {
    //MARK: Properties
    var recipes = [Recipe]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem
        
        //If loadRecipes() returns an array of recipes, add them to the recipes array
        if let savedRecipes = loadRecipes() {
            recipes += savedRecipes
        }
        else {
            // Load the sample data.
            loadSampleRecipes()
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "RecipeTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? RecipeTableViewCell else {
            fatalError("The dequeued cell is not an instance of RecipeTableViewCell.")
        }
        
        // Configure the cell as a recipe
        let recipe = recipes[indexPath.row]
        
        cell.nameLabel.text = recipe.name
        cell.photoImageView.image = recipe.photo
        
        return cell
    }
    
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            recipes.remove(at: indexPath.row)
            saveRecipes()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? ""){
        case "AddItem":
            os_log("Adding a new recipe.", log: OSLog.default, type: .debug)
            
        case "ShowDetail":
            guard let recipeDetailViewController = segue.destination as? RecipeViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedRecipeCell = sender as? RecipeTableViewCell else {
                fatalError("Unexpected sender: \(sender)")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedRecipeCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedRecipe = recipes[indexPath.row]
            recipeDetailViewController.recipe = selectedRecipe
            
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier)")
        }
    }
    
    
    //MARK: Actions
    @IBAction func unwindToMealList(sender: UIStoryboardSegue){
        if let sourceViewController = sender.source as? RecipeViewController, let recipe = sourceViewController.recipe {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                recipes[selectedIndexPath.row] = recipe
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
                let newIndexPath = IndexPath(row: recipes.count, section: 0)
                recipes.append(recipe)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            saveRecipes()
        }
    }
    
    //MARK: Private Methods
    
    private func loadSampleRecipes() {
        //Load recipe photos
        let photoRecipe1 = UIImage(named: "meal1")
        let photoRecipe2 = UIImage(named: "meal2")
        let photoRecipe3 = UIImage(named: "meal3")
        
        //Create sample recipes
        guard let recipe1 = Recipe(name: "Salad", photo: photoRecipe1, ingredients: "Mixed Greens, Salad Dressing", directions: "Mix Greens and Dressing") else {
            fatalError("Unable to instantiate recipe1")
        }
        
        guard let recipe2 = Recipe(name: "Salad Plate", photo: photoRecipe2, ingredients: "Apples, Mixed Greens", directions: "Slice apples and mix with the greens.") else {
            fatalError("Unable to instantiate recipe2")
        }
        
        guard let recipe3 = Recipe(name: "Oatmeal", photo: photoRecipe3, ingredients: "Oats, Brown Sugar", directions: "Heat up oats with milk, and mix with brown sugar.") else {
            fatalError("Unable to instantiate recipe3")
        }
        
        //Add recipes to array
        recipes += [recipe1, recipe2, recipe3]
        
    }
    
    private func saveRecipes(){
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(recipes, toFile: Recipe.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Recipes successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save recipes...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadRecipes() -> [Recipe]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Recipe.ArchiveURL.path) as? [Recipe]
    }
}
