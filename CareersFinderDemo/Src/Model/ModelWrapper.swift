import Foundation

class ModelWrapper<T: Model> {

    public let model: T?
    public let error: ErrorModel?

    public init() {
        self.model = nil
        self.error = nil
    }

    public init(model: T) {
        self.model = model
        self.error = nil
    }

    public init(error: ErrorModel) {
        self.model = nil
        self.error = error
    }

    public func hasError() -> Bool {
        return error != nil
    }

}
