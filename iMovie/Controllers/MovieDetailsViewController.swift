//
//  MovieDetailsViewController.swift
//  iMovie
//
//  Created by admin on 02/02/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    var data: [Comment] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CommentRowCell = tableView.dequeueReusableCell(withIdentifier: "CommentRowCell", for: indexPath) as! CommentRowCell
        
        let content = data[indexPath.row]
        
        cell.userName.text = content.user
        cell.commentText.text = content.text
        
        return cell
    }
    
    var movie:Movie? {
        didSet {
            if let movie = movie {
                if (movieName != nil){
                    movieName.text = movie.name
                }
                
                if (movieGenre != nil){
                    movieGenre.text = movie.genre
                }
                
                if (movieDescription != nil){
                    movieDescription.text = movie.description
                }
                
                if (movieGrade != nil){
                    movieGrade.text = String(movie.grade)
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
    
    let model: FireBaseModel = FireBaseModel.getInstance()
    var movieId:String?
    var isFromSearch:Bool?
    
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var movieGrade: UILabel!
    @IBOutlet weak var movieGenre: UILabel!
    @IBOutlet weak var movieDescription: UITextView!
    @IBOutlet weak var commentsTableView: UITableView!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var editMovieSideButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let movie = movie {
            movieName.text = movie.name
            movieGenre.text = movie.genre
            movieDescription.text = movie.description
            movieImage.image = image
            movieGrade.text = String(movie.grade)
            self.movieId = movie.id
            
            model.ref!.child("Movies/\(movieId!)/Comments").observe(.childAdded, with: { (snapshot) in
                if let value = snapshot.value as? [String:Any] {
                    let comment = Comment(commentJson: value)
                    self.data.insert(comment, at: 0)
                    self.commentsTableView.insertRows(at: [IndexPath(row: 0, section: 0)],
                                                     with: UITableView.RowAnimation.automatic)
                    
                }
            })
            
            commentsTableView.delegate = self
            commentsTableView.dataSource = self
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.editMovieSideButton.isEnabled = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.editMovieSideButton.isEnabled = false
        if (segue.identifier == "editMovie"){
            let editMovieViewController:EditMovieViewController = segue.destination as! EditMovieViewController
            editMovieViewController.movie = movie
            editMovieViewController.image = movieImage.image
            editMovieViewController.isFromSearch = self.isFromSearch
        }
    }
    
    @IBAction func onAddComment(_ sender: UIButton) {
        let alert = UIAlertController(title: "New Comment", message: "Write your comment", preferredStyle: UIAlertController.Style.alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Enter comment"
        }
        
        alert.addAction(UIAlertAction(title: "Save", style: UIAlertAction.Style.default, handler: { action in
            let textField = alert.textFields![0] as UITextField
            let key:String! = self.model.getAutoKey(table: "Movies/\(self.movieId!)/Comments")
            let user:String! = self.model.connectedUser()!.email!
            let comment = Comment(id:key,
                                  movieId: self.movieId!,
                                  text: textField.text!,
                                  user: user)
            self.model.addItemToTable(table: "Movies/\(self.movieId!)/Comments", key: key, value: comment.toJson())
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    

}
