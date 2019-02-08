//
//  EditMovieViewController.swift
//  iMovie
//
//  Created by admin on 08/02/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class EditMovieViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieText: UITextField!
    @IBOutlet weak var genreText: UITextField!
    @IBOutlet weak var gradeText: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var descriptionText: UITextView!
    
    let model: FireBaseModel = FireBaseModel.getInstance()
    var movie:Movie? {
        didSet {
            if let movie = movie {
                if self.movieText != nil {
                    self.movieText.text = movie.name
                }
                
                if self.genreText != nil {
                    self.genreText.text = movie.genre
                }
                
                if self.descriptionText != nil {
                    self.descriptionText.text = movie.description
                }
                
                if self.gradeText != nil {
                    self.gradeText.text = String(movie.grade)
                }
            }
        }
    }
    
    var image:UIImage? {
        didSet {
            if let image = image {
                if (movieImage != nil){
                    movieImage.image = image
                }
            }
        }
    }
    
    var isFromSearch:Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.spinner.stopAnimating()
        self.spinner.isHidden = true
        gradeText.delegate = self
        if let movie = movie {
            movieText.text = movie.name
            genreText.text = movie.genre
            descriptionText.text = movie.description
            movieImage.image = image
            gradeText.text = String(movie.grade)
        }
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
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        self.movieImage.image = image
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onSave(_ sender: UIButton) {
        if movieText.text == "" || genreText.text == "" || gradeText.text == ""
            || movieImage.image == nil || descriptionText.text == "" {
            
            let alert = UIAlertController(title: "Incorrect form",
                                          message: "Make sure all fields are full",
                                          preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let score = Int(gradeText.text!)!
        if score < 0 || score > 10 {
            let alert = UIAlertController(title: "Incorrect grade",
                                          message: "grade has to be between 0 and 10",
                                          preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        self.spinner.isHidden = false
        self.spinner.startAnimating()
        let key = self.movie!.id
        let editedMovie: Movie = Movie(id:key,
                                    name:self.movieText.text!,
                                    description:self.descriptionText.text!,
                                    grade:Int(self.gradeText.text!)!,
                                    genre: self.genreText.text!);
        
        model.saveImageToFirebase(image:self.movieImage.image!, name: key ,callback: { (url) in
            self.model.addItemToTable(table: "Movies", key: key, value: editedMovie.toJson())
            self.spinner.stopAnimating()
            self.spinner.isHidden = true
            
            self.unwined()
        })
    }
    
    @IBAction func onDelete(_ sender: UIButton) {
        let alert = UIAlertController(title: "Delete Movie", message: "Are you sure?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Delete", style: UIAlertAction.Style.default, handler: { action in
            self.model.removeItemFromTable(table: "Movies", key: self.movie!.id)
            self.model.removeImage(name: self.movie!.id)
            self.unwined()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func unwined() {
        var toSearch = false;
        if let isFromSearch = self.isFromSearch {
            toSearch = isFromSearch
        }
        
        if toSearch {
            self.performSegue(withIdentifier: "unwindToSearch", sender: self)
        } else {
            self.performSegue(withIdentifier: "unwindToRecents", sender: self)
        }
    }

}
