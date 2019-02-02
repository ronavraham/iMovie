import Foundation

class Movie {
    
    var id: String
    var name: String
    var description: String
    var grade: Int
    var genre: String
    
    init(id:String, name:String, description:String, grade:Int, genre:String) {
        self.id = id
        self.name = name
        self.description = description
        self.grade = grade
        self.genre = genre
    }
    
    init(movieJson:[String:Any]) {
        self.id = movieJson["id"] as! String
        self.name = movieJson["name"] as! String
        self.description = movieJson["description"] as! String
        self.grade = movieJson["grade"] as! Int
        self.genre = movieJson["genre"] as! String
    }
    
    func toJson() -> [String:Any] {
        var movieJson = [String:Any]()
        movieJson["id"] = self.id
        movieJson["name"] = self.name
        movieJson["description"] = self.description
        movieJson["grade"] = self.grade
        movieJson["genre"] = self.genre
        
        return movieJson
    }
}

