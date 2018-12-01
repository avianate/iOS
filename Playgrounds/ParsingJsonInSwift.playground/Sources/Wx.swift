import Foundation

public struct Wx {
    
    // MARK - Errors
    enum SerializationError: Error {
        case missing(String)
    }
    
    // MARK: - Properties
    public let name: String
    public let link: String
    
    // MARK: - Initializers
    public init(name: String, link: String) {
        self.name = name
        self.link = link
    }
    
    public init?(json: [String: Any]) throws {
        
        guard let container = json["im:name"] as? [String: Any],
            let name = container["label"] as? String else {
                throw SerializationError.missing("name")
        }
        
        guard let id = json["id"] as? [String: Any],
            let link = id["label"] as? String else {
                throw SerializationError.missing("link")
        }
        
        self.name = name
        self.link = link
    }
}
