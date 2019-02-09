//
//  SyncManager.swift
//  iMovie
//
//  Created by admin on 09/02/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation
import UIKit

class SyncManager {
    static let instance:SyncManager = SyncManager()
    
    var localSql:LocalSQLManager = LocalSQLManager();
    var modelFirebase:FireBaseModel = FireBaseModel.getInstance()
    
    static func getInstance()->SyncManager {
        return instance
    }
    
    private init(){
        observeMovies();
    }
    
    func observeMovies(){
        modelFirebase.movieAddedEvent(callback: { (m:Movie?) in
            if let movie:Movie = m{
                var lastUpdated = Movie.getLastUpdateDate(database: self.localSql.database)
                lastUpdated += 1;
                Movie.addNew(database: self.localSql.database, movie: movie)
                if (movie.lastUpdate != nil && movie.lastUpdate! > lastUpdated){
                    lastUpdated = movie.lastUpdate!
                }
                Movie.setLastUpdateDate(database: self.localSql.database, date: lastUpdated)
                iMovieNotificationCenter.movieAddedNotification.notify(data: movie)
            }
        });
        
        modelFirebase.movieChangedEvent(callback: { (m:Movie?) in
            if let movie:Movie = m{
                iMovieNotificationCenter.movieChangedNotification.notify(data: movie)
            }
        });
        
        modelFirebase.movieRemovedEvent(callback: { (m:Movie?) in
            if let movie:Movie = m{
                iMovieNotificationCenter.movieRemovedNotification.notify(data: movie)
            }
        });
    }
    
    func getImage(name:String, callback:@escaping (UIImage?)->Void){
        if let image = self.getImageFromFile(name: name+".jpeg"){
            callback(image)
        }else{
            modelFirebase.downloadImage(name: name ,callback: {(image) in
                if (image != nil){
                    self.saveImageToFile(image: image!, name: name+".jpeg")
                }
                callback(image)
            });
        }
    }
    
    
    /// File handling
    func saveImageToFile(image:UIImage, name:String){
        if let data = image.jpegData(compressionQuality: 0.8) {
            let filename = getDocumentsDirectory().appendingPathComponent(name)
            try? data.write(to: filename)
        }
    }
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in:
            .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func removeLocalImage(name:String)->Void{
        try? FileManager().removeItem(at: getDocumentsDirectory().appendingPathComponent(name))
    }
    
    func getImageFromFile(name:String)->UIImage?{
        let filename = getDocumentsDirectory().appendingPathComponent(name)
        return UIImage(contentsOfFile:filename.path)
    }

    
        /*
    
    func addNewStudent(student:Student){
        modelFirebase.addNewStudent(student: student);
        //Student.addNew(database: modelSql!.database, student: student)
    }
    
    func getStudent(byId:String)->Student?{
        return modelFirebase.getStudent(byId:byId)
        //return Student.get(database: modelSql!.database, byId: byId);
    }
    
    func saveImage(image:UIImage, name:(String),callback:@escaping (String?)->Void){
        modelFirebase.saveImage(image: image, name: name, callback: callback)
        
    }
    
 */
}

