
class Carpet {
    
    var name : String?
    var length : Double?
    var breadth : Double?
    var imageURL : String?
    var modelURL : String?
    var description : String?
    var category : String?
    
    init(
        name: String?,
        breadth: Double?,
        length: Double?,
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

