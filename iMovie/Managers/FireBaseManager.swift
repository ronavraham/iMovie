//
//  FireBaseModel.swift
//  iMovie
//
//  Created by admin on 26/01/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseStorage

class FireBaseModel {
    var ref:DatabaseReference?
    var storageRef:StorageReference?
    
    static var instance: FireBaseModel = FireBaseModel()
    let numberOfRecentMovies:UInt = 20
    
    static func getInstance()->FireBaseModel {
        return instance
    }
    
    private init() {
        ref = nil
        storageRef = nil
    }
    
    func initRefs() {
        ref = Database.database().reference()
        storageRef = Storage.storage().reference();
    }
    
    func registerUser(email:String, password:String, callback:@escaping (AuthDataResult?)->Void) {
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                callback(nil)
            } else {
                callback(user)
            }
        })
    }
    
    func signIn(email:String, password:String, callback:@escaping (AuthDataResult?)->Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                callback(nil)
            } else {
                callback(user)
            }
        }
    }
    
    func connectedUser() -> User? {
        return Auth.auth().currentUser;
    }
    
    func getAutoKey(table:String)->String? {
        return self.ref?.child(table).childByAutoId().key
    }
    
    /*
    func getAllItemsInTable(table:String, callback:@escaping ([String:[String:Any]]?)->Void) {
        self.ref?.child(table).observeSingleEvent(of: .value, with: { (snapshot) in
            callback(snapshot.value as? [String:[String:Any]])
        })
    }*/
    
    func movieAddedEvent(callback:@escaping (Movie?)->Void){
        self.ref?.child("Movies").queryLimited(toLast: numberOfRecentMovies).observe(.childAdded, with: { (snapshot) in
            iMovieNotificationCenter.activateSpinnerNotification.notify(data: true);
            if let value = snapshot.value as? [String:Any] {
                let movie = Movie(movieJson: value)
                callback(movie)
            }
            else { callback(nil) }
        });
    }
    
    func movieChangedEvent(callback:@escaping (Movie?)->Void){
        self.ref?.child("Movies").queryLimited(toLast: numberOfRecentMovies).observe(.childChanged, with: { (snapshot) in
            if let value = snapshot.value as? [String:Any] {
                let movie = Movie(movieJson: value)
                callback(movie)
            }
            else { callback(nil) }
        });
    }
    
    func movieRemovedEvent(callback:@escaping (Movie?)->Void){
        self.ref?.child("Movies").queryLimited(toLast: numberOfRecentMovies).observe(.childRemoved, with: { (snapshot) in
            if let value = snapshot.value as? [String:Any] {
                let movie = Movie(movieJson: value)
                callback(movie)
            }
            else { callback(nil) }
        });
    }
    
    func addItemToTable(table:String, key:String, value:[String:Any]) {
        self.ref?.child(table).child(key).setValue(value)
    }
    
    func updateItem(table:String, key:String, value:[String:Any]) {
        self.ref?.child(table).child(key).updateChildValues(value);
    }
    
    func removeItemFromTable(table:String, key:String) {
        self.ref?.child(table).child(key).removeValue()
    }
    
    func saveImageToFirebase(image:UIImage, name:(String),
                             callback:@escaping (String?)->Void){
        let movieRef = storageRef!.child("images/"+name+".jpg")
        if let data = image.jpegData(compressionQuality: 0.8) {
            movieRef.putData(data, metadata: nil) { metadata, error in
                if (error != nil) {
                    callback(nil)
                } else {
                   movieRef.downloadURL { url, error in
                    guard let downloadURL = url else {
                        // Uh-oh, an error occurred!
                        return
                    }
                    callback(downloadURL.absoluteString)
                    }
                }
            }
        }
    }
    
    func downloadImage(url:String, callback:@escaping (UIImage?)->Void) {
        let movieRef = Storage.storage().reference(forURL: url)
        movieRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
            if (error != nil) {
                print(error)
                callback(nil)
            } else {
                
                let image = UIImage(data: data!)
                callback(image)
            }
        }
    }
    
    func removeImage(name:String) {
        storageRef!.child("images/"+name+".jpg").delete { (error) in
        }
    }
}

