//
//  LocalSQLManager.swift
//  iMovie
//
//  Created by admin on 08/02/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation

class LocalSQLManager {
    var database: OpaquePointer? = nil
    
    init() {
        // initialize the DB
        let dbFileName = "imovie-database.db"
        if let dir = FileManager.default.urls(for: .documentDirectory, in:
            .userDomainMask).first{
            let path = dir.appendingPathComponent(dbFileName)
            if sqlite3_open(path.absoluteString, &database) != SQLITE_OK {
                print("Failed to open db file: \(path.absoluteString)")
                return
            }
            //dropTables()
            createTables()
        }
        
    }
    
    func createTables() {
        Movie.createTable(database: database);
        LastUpdateDates.createTable(database: database);
    }
    
    func dropTables(){
        Movie.drop(database: database)
        LastUpdateDates.drop(database: database)
    }
    
    
}

