import Foundation

struct NoModel: Model {
    public let successful: Bool
    
    public var anyString: String = ""
    
    init(successful: Bool) {
        self.successful = successful
    }
    
    init(anyString: String) {
        self.anyString = anyString
        self.successful = true
    }
}
