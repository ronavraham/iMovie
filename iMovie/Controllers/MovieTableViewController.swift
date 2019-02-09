//
//  MovieTableViewController.swift
//  iMovie
//
//  Created by admin on 26/01/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class MovieTableViewController: UITableViewController {
    
    var data: [Movie] = []
    let sync:SyncManager = SyncManager.getInstance()
    var modelFirebase:FireBaseModel = FireBaseModel.getInstance()
    var imageData: [String:UIImage] = [:]
    var selctedRow:Int?
    var movieAddedListener:NSObjectProtocol?
    var movieChangedListener:NSObjectProtocol?
    var movieRemovedListener:NSObjectProtocol?
    
    @IBOutlet var moviesTable: UITableView!
    @IBOutlet weak var newBarButton: UIBarButtonItem!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.spinner.stopAnimating()
        self.spinner.isHidden = true
        self.addObservers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.newBarButton.isEnabled = true
    }
    
    deinit{
        if movieAddedListener != nil{
            iMovieNotificationCenter.movieAddedNotification.remove(observer: movieAddedListener!)
        }
        if movieRemovedListener != nil{
            iMovieNotificationCenter.movieRemovedNotification.remove(observer: movieRemovedListener!)
        }
        if movieChangedListener != nil{
            iMovieNotificationCenter.movieChangedNotification.remove(observer: movieChangedListener!)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:MovieRowCell = tableView.dequeueReusableCell(withIdentifier: "MovieRowCell", for: indexPath) as! MovieRowCell
        
        let content = data[indexPath.row]
        
        cell.MovieName.text = content.name
        cell.MovieGrade.text = String(content.grade)
        cell.MovieImage.image = self.imageData[content.id]
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.newBarButton.isEnabled = false
        if (segue.identifier == "showDetails"){
           let movieViewController : MovieDetailsViewController = segue.destination as! MovieDetailsViewController
           let content = data[selctedRow!];
           movieViewController.movie = content
           movieViewController.image = self.imageData[content.id]
        }
    }
    
    override public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        selctedRow = indexPath.row
        performSegue(withIdentifier: "showDetails", sender: self)
    }
    
    @IBAction func unwinedToMovieTable(segue: UIStoryboardSegue) {
        
    }
    
    private func addObservers() {
        self.spinner.isHidden = false
        self.spinner.startAnimating()
        movieAddedListener = iMovieNotificationCenter.movieAddedNotification.observe(cb: movieAdded)
        movieChangedListener = iMovieNotificationCenter.movieChangedNotification.observe(cb: movieChanged)
        movieRemovedListener = iMovieNotificationCenter.movieRemovedNotification.observe(cb: movieRemoved)
    }
    
    public func movieAdded(movie:Movie){
        self.sync.getImage(url: movie.imageUrl, callback: {(image) in
            self.imageData[movie.id] = image
            self.data.insert(movie, at: 0)
            self.moviesTable.insertRows(at: [IndexPath(row: 0, section: 0)],
                                        with: UITableView.RowAnimation.automatic)
            self.spinner.stopAnimating()
            self.spinner.isHidden = true
        })
    }
    
    func movieChanged(movie:Movie){
        self.spinner.isHidden = false
        self.spinner.startAnimating()
        self.sync.getImage(url: movie.imageUrl, callback: {(image) in
            let index = self.data.index(where: { (curr) -> Bool in
                return curr.id == movie.id
            })
            
            if index != nil {
                self.imageData[movie.id] = image
                self.data[index!] = movie
                self.moviesTable.reloadRows(at: [IndexPath(row: index!, section: 0)],
                                            with: UITableView.RowAnimation.automatic)
            }
            
            self.spinner.stopAnimating()
            self.spinner.isHidden = true
        })
    }
    
    func movieRemoved(movie:Movie){
        if self.imageData.keys.contains(movie.id) {
            self.imageData.removeValue(forKey: movie.id)
        }
        
        let index = self.data.index(where: { (curr) -> Bool in
            return curr.id == movie.id
        })
        
        if index != nil {
            self.data.remove(at: index!)
            self.moviesTable.deleteRows(at: [IndexPath(row: index!, section: 0)],
                                        with: UITableView.RowAnimation.automatic)
        }
    }
}
