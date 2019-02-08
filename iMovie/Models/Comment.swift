import Foundation

class Comment {
    
    var id: String
    var movieId: String
    var user:String
    var text: String
    
    init(id:String, movieId:String, text:String, user:String) {
        self.id = id
        self.movieId = movieId
        self.text = text
        self.user = user
    }
    
    init(commentJson:[String:Any]) {
        self.id = commentJson["id"] as! String
        self.movieId = commentJson["movieId"] as! String
        self.text = commentJson["text"] as! String
        self.user = commentJson["user"] as! String
    }
    
    func toJson() -> [String:Any] {
        var commentJson = [String:Any]()
        commentJson["id"] = self.id
        commentJson["movieId"] = self.movieId
        commentJson["text"] = self.text
        commentJson["user"] = self.user
        
        return commentJson
    }
}


