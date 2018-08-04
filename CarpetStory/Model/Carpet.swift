
class Carpet {
    
    var name : String?
    var length : Int?
    var breadth : Int?
    var imageURL : String?
    var modelURL : String?
    var description : String?
    var category : String?
    var mostViewed : Bool?
    
    init(
        name: String?,
        breadth: Int?,
        length: Int?,
        imageURL: String?,
        modelURL : String?,
        description: String?,
        category: String?,
        mostViewed: Bool?
        )
    {
        self.name = name
        self.breadth = breadth
        self.length = length
        self.imageURL = imageURL
        self.modelURL = modelURL
        self.description = description
        self.category = category
        self.mostViewed = mostViewed
    }
}

