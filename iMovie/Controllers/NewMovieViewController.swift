//
//  NewMovieViewController.swift
//  iMovie
//
//  Created by admin on 02/02/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class NewMovieViewController: UIViewController, UIImagePickerControllerDelegate, UITextFieldDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var NameInput: UITextField!
    @IBOutlet weak var GenreInput: UITextField!
    @IBOutlet weak var GradeInput: UITextField!
    @IBOutlet weak var DescriptionInput: UITextView!
    @IBOutlet weak var ImageInput: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    let model: FireBaseModel = FireBaseModel.getInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.spinner.stopAnimating()
        self.spinner.isHidden = true
        
        self.GradeInput.delegate = self
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isStrictSuperset(of: characterSet)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        self.ImageInput.image = image
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func imageClick(_ sender: UITapGestureRecognizer) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
            self.spinner.isHidden = false
            self.spinner.startAnimating()
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: {
                self.spinner.stopAnimating()
                self.spinner.isHidden = true
            })
        }
    }

    @IBAction func OnSave(_ sender: UIButton) {
        if NameInput.text == "" || GenreInput.text == "" || GradeInput.text == ""
            || ImageInput.image == nil || DescriptionInput.text == "" {
            
            let alert = UIAlertController(title: "Incorrect form",
                                          message: "Make sure all fields are full",
                                          preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let grade = Int(GradeInput.text!)!
        if grade < 0 || grade > 10 {
            let alert = UIAlertController(title: "Incorrect score",
                                          message: "score has to be between 0 and 10",
                                          preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        self.spinner.isHidden = false
        self.spinner.startAnimating()
        
        let key: String! = model.getAutoKey(table: "Movies")
        
        let newMovie: Movie = Movie(id:key,
                                 name:self.NameInput.text!,
                                 description:self.DescriptionInput.text!,
                                 grade: grade,
                                 genre: self.GradeInput.text!);
        
        model.saveImageToFirebase(image:self.ImageInput.image!, name: key ,callback: { (url) in
            self.model.addItemToTable(table: "Movies", key: key, value: newMovie.toJson())
            self.spinner.stopAnimating()
            self.spinner.isHidden = true
            self.performSegue(withIdentifier: "unwindFromNewMovie", sender: self)
        })
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
