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
    var imageData: [String:UIImage] = [:]
    let model: FireBaseModel = FireBaseModel.getInstance()
    let numberOfRecentGames:UInt = 20
    var selctedRow:Int?
    
    @IBOutlet var moviesTable: UITableView!
    @IBOutlet weak var newBarButton: UIBarButtonItem!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.spinner.stopAnimating()
        self.spinner.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.newBarButton.isEnabled = true
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
           // let content = data[selctedRow!];
            //movieViewController.game = content
            //movieViewController.image = self.imageData[content.id]
        }
    }
    
    override public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        selctedRow = indexPath.row
        performSegue(withIdentifier: "showDetails", sender: self)
    }
    
    @IBAction func unwinedToGameTable(segue: UIStoryboardSegue) {
        
    }

}
