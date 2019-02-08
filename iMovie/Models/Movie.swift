import Foundation
import Firebase

class Movie {
    
    let id: String
    let name: String
    let description: String
    let grade: Int
    let genre: String
    let imageUrl:String
    var lastUpdate:Double?
    
    init(id:String, name:String, description:String, grade:Int, genre:String, url:String="") {
        self.id = id
        self.name = name
        self.description = description
        self.grade = grade
        self.genre = genre
        self.imageUrl = url
    }
    
    init(movieJson:[String:Any]) {
        self.id = movieJson["id"] as! String
        self.name = movieJson["name"] as! String
        self.description = movieJson["description"] as! String
        self.grade = movieJson["grade"] as! Int
        self.genre = movieJson["genre"] as! String
        if movieJson["imageUrl"] != nil{
            self.imageUrl = movieJson["imageUrl"] as! String
        }else{
            self.imageUrl = ""
        }
        if movieJson["lastUpdate"] != nil {
            if let update = movieJson["lastUpdate"] as? Double{
                self.lastUpdate = update
            }
        }
    }
    
    func toJson() -> [String:Any] {
        var movieJson = [String:Any]()
        movieJson["id"] = self.id
        movieJson["name"] = self.name
        movieJson["description"] = self.description
        movieJson["grade"] = self.grade
        movieJson["genre"] = self.genre
        movieJson["imageUrl"] = self.imageUrl
        movieJson["lastUpdate"] = ServerValue.timestamp()
        
        return movieJson
    }
}

