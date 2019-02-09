//
//  NotificationCenter.swift
//  iMovie
//
//  Created by admin on 09/02/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation

class iMovieNotificationCenter{
    static let movieAddedNotification = MyNotification<Movie>("ron.movieadded")
    static let movieChangedNotification = MyNotification<Movie>("ron.moviechanged")
    static let movieRemovedNotification = MyNotification<Movie>("ron.movieremoved")
    
    class MyNotification<T>{
        let name:String
        var count = 0;
        
        init(_ _name:String) {
            name = _name
        }
        func observe(cb:@escaping (T)->Void)-> NSObjectProtocol{
            count += 1
            return NotificationCenter.default.addObserver(forName: NSNotification.Name(name),
                                                          object: nil, queue: nil) { (data) in
                                                            if let data = data.userInfo?["data"] as? T {
                                                                cb(data)
                                                            }
            }
        }
        
        func notify(data:T){
            NotificationCenter.default.post(name: NSNotification.Name(name),
                                            object: self,
                                            userInfo: ["data":data])
        }
        
        func remove(observer: NSObjectProtocol){
            count -= 1
            NotificationCenter.default.removeObserver(observer, name: nil, object: nil)
        }
        
        
    }
    
}

