//
//  SyncManager.swift
//  iMovie
//
//  Created by admin on 09/02/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation
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
    
        /*
        //2. get updates from firebase and observe
        modelFirebase.getAllStudentsAndObserve(from:lastUpdated){ (data:[Student]) in
            //3. write new records to the local DB
            for st in data{
                Student.addNew(database: self.modelSql.database, student: st)
                if (st.lastUpdate != nil && st.lastUpdate! > lastUpdated){
                    lastUpdated = st.lastUpdate!
                }
            }
            
            //4. update the local students last update date
            Student.setLastUpdateDate(database: self.modelSql.database, date: lastUpdated)
            
            //5. get the full data
            let stFullData = Student.getAll(database: self.modelSql.database)
            
            //6. notify observers with full data
            ModelNotification.studentsListNotification.notify(data: stFullData)
        }
        
    }
    
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
    
    func getImage(url:String, callback:@escaping (UIImage?)->Void){
        //modelFirebase.getImage(url: url, callback: callback)
        
        //1. try to get the image from local store
        let _url = URL(string: url)
        let localImageName = _url!.lastPathComponent
        if let image = self.getImageFromFile(name: localImageName){
            callback(image)
            print("got image from cache \(localImageName)")
        }else{
            //2. get the image from Firebase
            modelFirebase.getImage(url: url){(image:UIImage?) in
                if (image != nil){
                    //3. save the image localy
                    self.saveImageToFile(image: image!, name: localImageName)
                }
                //4. return the image to the user
                callback(image)
                print("got image from firebase \(localImageName)")
            }
        }
    }
    
    
    /// File handling
    func saveImageToFile(image:UIImage, name:String){
        if let data = UIImageJPEGRepresentation(image, 0.8) {
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
    
    func getImageFromFile(name:String)->UIImage?{
        let filename = getDocumentsDirectory().appendingPathComponent(name)
        return UIImage(contentsOfFile:filename.path)
    }
    
    
    
    ///Authentication
    func signin(email:String, password:String, callback:@escaping (Bool)->Void) {
        modelFirebase.signin(email: email, password: password, callback: callback)
    }
    
    func createUser(email:String, password:String, callback:@escaping (Bool)->Void) {
        modelFirebase.createUser(email: email, password: password, callback: callback)
    }
 */
}

