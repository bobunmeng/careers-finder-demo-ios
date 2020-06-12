import Foundation

struct ErrorModel {

    public let code: Int?
    public let message: String?
    public let errorCode: ErrorCode?
    public let httpCode: Int?
    
    public init (_ code: Int?, _ message: String?, _ httpCode: Int?) {
        self.code = code
        self.message = message
        self.errorCode = nil
        self.httpCode = httpCode
    }

    public init(_ code: Int?, _ message: String?) {
        self.code = code
        self.message = message
        self.errorCode = nil
        self.httpCode = nil
    }

    public init(code: Int?) {
        self.code = code
        self.message = nil
        self.errorCode = nil
        self.httpCode = nil
    }

    public init(message: String?) {
        self.code = nil
        self.message = message
        self.errorCode = nil
        self.httpCode = nil
    }

    public init(errorCode: ErrorCode) {
        self.code = nil
        self.message = nil
        self.errorCode = errorCode
        self.httpCode = nil
    }

    public var errorMessage: String {
        get {
            return message ?? ""
        }
    }

}
