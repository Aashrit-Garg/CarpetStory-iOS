
class Carpet {
    
    var name : String?
    var length : Int?
    var breadth : Int?
    var imageURL : String?
    var modelURL : String?
    var description : String?
    var category : String?
    
    init(
        name: String?,
        breadth: Int?,
        length: Int?,
        imageURL: String?,
        modelURL : String?,
        description: String?,
        category: String?
        )
    {
        self.name = name
        self.breadth = breadth
        self.length = length
        self.imageURL = imageURL
        self.modelURL = modelURL
        self.description = description
        self.category = category
    }
}

