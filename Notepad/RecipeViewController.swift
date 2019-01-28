//
//  RecipeViewController.swift
//  Notepad
//
//  Created by Pooja Nadkarni on 1/19/19.
//  Copyright © 2019 Pooja Nadkarni. All rights reserved.
//

import UIKit
import os.log

class RecipeViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    
    //MARK: Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var ingredientsLabel: UILabel!
    @IBOutlet weak var ingredientsTextView: UITextView!
    @IBOutlet weak var directionsLabel: UILabel!
    @IBOutlet weak var directionsTextView: UITextView!
    
    var onEdit: Bool!
    var recipe: Recipe?
    
    //MARK: UIImagePickerController
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //Dismiss if user presses cancel
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set photoImageView to display the selected image.
        photoImageView.image = selectedImage
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Navigation
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        let isPresentingInAddRecipeMode = presentingViewController is UINavigationController
        if isPresentingInAddRecipeMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController {
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The RecipeViewController is not inside a navigation controller.")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        let name = nameTextField.text ?? ""
        let image = photoImageView.image
        let ingredients = ingredientsTextView.text ?? ""
        let directions = directionsTextView.text ?? ""
        
        recipe = Recipe(name: name, photo: image, ingredients: ingredients, directions: directions)
    }
    
    //MARK: Actions
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        //Closes text field if user taps image view
        nameTextField.resignFirstResponder()
        
        //Opens camera roll
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        
        //Tells View to present this view as defined
        present(imagePickerController, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self
        directionsTextView.delegate = self
        ingredientsTextView.delegate = self
        
        print("did load")
        if let recipe = recipe {
            navigationItem.title = recipe.name
            nameTextField.text = recipe.name
            ingredientsTextView.text = recipe.ingredients
            directionsTextView.text = recipe.directions
            photoImageView.image = recipe.photo
            onEdit = true
        } else {
            onEdit = false
        }
        
        updateSaveButtonState()
    }
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Hide the keyboard
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.isEnabled = false
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = nameTextField.text
    }
    
    //MARK: UITextViewDelegate
    func textViewShouldReturn(_ textView: UITextView) -> Bool {
        //Hide the keyboard
        textView.resignFirstResponder()
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if !onEdit {
            saveButton.isEnabled = false
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        updateSaveButtonState()
    }
    
    //MARK: Private Methods
    private func updateSaveButtonState(){
        //Disable Save button if text is empty
        if onEdit {
            saveButton.isEnabled = true
        } else {
            let title = nameTextField.text ?? ""
            let directionsString = directionsTextView.text ?? ""
            let ingredientsString = ingredientsTextView.text ?? ""
            saveButton.isEnabled = !(title.isEmpty || directionsString.isEmpty || ingredientsString.isEmpty)
        }
    }
}
