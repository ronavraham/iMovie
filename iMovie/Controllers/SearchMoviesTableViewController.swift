//
//  SearchMoviesTableViewController.swift
//  iMovie
//
//  Created by admin on 08/02/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class SearchMoviesTableViewController: UITableViewController, UISearchBarDelegate{
    var data: [Movie] = []
    var imageData: [String:UIImage] = [:]
    let model: FireBaseModel = FireBaseModel.getInstance()
    
    @IBOutlet var searchTable: UITableView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:MovieRowCell = tableView.dequeueReusableCell(withIdentifier: "movie_row_cell", for: indexPath) as! MovieRowCell
        
        let content = data[indexPath.row]
        
        cell.MovieName.text = content.name
        cell.MovieGrade.text = String(content.grade)
        cell.MovieImage.image = self.imageData[content.id]
        return cell
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.performSearch()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.spinner.stopAnimating()
        self.spinner.isHidden = true
        searchTable.delegate = self
        searchTable.dataSource = self
        searchBar.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.performSearch()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwinedToSearch(segue: UIStoryboardSegue) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showSearchDetails"){
            let selectedRowPath = self.searchTable.indexPathForSelectedRow!
            let movieViewController:MovieDetailsViewController = segue.destination as! MovieDetailsViewController
            let content = data[selectedRowPath.row];
            movieViewController.movie = content
            movieViewController.image = self.imageData[content.id]
            movieViewController.isFromSearch = true
            self.searchTable.deselectRow(at: selectedRowPath, animated: true)
        }
    }
    
    private func performSearch() {
        if let searchBar = self.searchBar {
            if let text = searchBar.text {
                if text != "" {
                    self.data.removeAll()
                    self.searchTable.reloadData()
                    
                    self.spinner.startAnimating()
                    self.spinner.isHidden = false
                    
                    model.ref!.child("Movies").observeSingleEvent(of: .value) { (snapshot) in
                        if let values = snapshot.value as? [String:[String:Any]] {
                            for stJson in values {
                                let movie = Movie(movieJson: stJson.value)
                                
                                if movie.name.contains(self.searchBar.text!) {
                                    self.model.downloadImage(name: movie.id, callback: {(image) in
                                        self.imageData[movie.id] = image
                                        self.data.insert(movie, at: 0)
                                        self.searchTable.insertRows(at: [IndexPath(row: 0, section: 0)],
                                                                    with: UITableView.RowAnimation.automatic)
                                        
                                        self.spinner.stopAnimating()
                                        self.spinner.isHidden = true
                                    })
                                } else {
                                    self.spinner.stopAnimating()
                                    self.spinner.isHidden = true
                                }
                            }
                        } else {
                            self.spinner.stopAnimating()
                            self.spinner.isHidden = true
                        }
                    }
                }
            }
        }
    }


}
