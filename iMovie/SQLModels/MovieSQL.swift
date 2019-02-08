//
//  MovieSQL.swift
//  iMovie
//
//  Created by admin on 08/02/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation

extension Movie{
    
    static func createTable(database: OpaquePointer?)  {
        var errormsg: UnsafeMutablePointer<Int8>? = nil
        let res = sqlite3_exec(database, """
                                            CREATE TABLE IF NOT EXISTS MOVIES (ID TEXT PRIMARY KEY,
                                                                               NAME TEXT,
                                                                               DESCRIPTION TEXT,
                                                                               GRADE INT,
                                                                               GENRE TEXT)
                                         """, nil, nil, &errormsg);
        if(res != 0){
            print("error creating table");
            return
        }
    }
    
    static func drop(database: OpaquePointer?)  {
        var errormsg: UnsafeMutablePointer<Int8>? = nil
        let res = sqlite3_exec(database, "DROP TABLE MOVIES;", nil, nil, &errormsg);
        if(res != 0){
            print("error creating table");
            return
        }
    }
    
    static func getAll(database: OpaquePointer?)->[Movie]{
        var sqlite3_stmt: OpaquePointer? = nil
        var data = [Movie]()
        if (sqlite3_prepare_v2(database,"SELECT * from MOVIES;",-1,&sqlite3_stmt,nil)
            == SQLITE_OK){
            while(sqlite3_step(sqlite3_stmt) == SQLITE_ROW){
                let mvId = String(cString:sqlite3_column_text(sqlite3_stmt,0)!)
                let name = String(cString:sqlite3_column_text(sqlite3_stmt,1)!)
                let desc = String(cString:sqlite3_column_text(sqlite3_stmt,2)!)
                let grade = Int(sqlite3_column_int(sqlite3_stmt,3))
                let genre = String(cString:sqlite3_column_text(sqlite3_stmt,4)!)
                data.append(Movie(id: mvId,name: name,description: desc,grade: grade,genre: genre))
            }
        }
        sqlite3_finalize(sqlite3_stmt)
        return data
    }
    
    static func addNew(database: OpaquePointer?, movie:Movie){
        var sqlite3_stmt: OpaquePointer? = nil
        if (sqlite3_prepare_v2(database,"INSERT OR REPLACE INTO MOVIES (ID, NAME, DESCRIPTION, GRADE, GENRE) VALUES (?,?,?,?,?);",-1, &sqlite3_stmt,nil) == SQLITE_OK){
            let id = movie.id.cString(using: .utf8)
            let name = movie.name.cString(using: .utf8)
            let desc = movie.description.cString(using: .utf8)
            let genre = movie.genre.cString(using: .utf8)
            
            sqlite3_bind_text(sqlite3_stmt, 1, id,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 2, name,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 3, desc,-1,nil);
            sqlite3_bind_int(sqlite3_stmt, 4, Int32(movie.grade))
            sqlite3_bind_text(sqlite3_stmt, 5, genre,-1,nil);
            
            if(sqlite3_step(sqlite3_stmt) == SQLITE_DONE){
                print("new row added succefully")
            }
        }
        sqlite3_finalize(sqlite3_stmt)
    }

    static func getLastUpdateDate(database: OpaquePointer?)->Double{
        return LastUpdateDates.get(database: database, tabeName: "movies")
    }
    
    static func setLastUpdateDate(database: OpaquePointer?, date:Double){
        LastUpdateDates.set(database: database, tabeName: "movies", date: date);
    }
}
