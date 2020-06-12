import Foundation
import RxSwift

public protocol Translator {
    associatedtype Input
    associatedtype Output
    func translate(entity: Input) -> Output
    func translate(with entity: Input?) -> Output?
}

extension Translator {
    func translate(with entity: Input?) -> Output? {
        if let entity = entity {
            return self.translate(entity: entity)
        }
        return nil
    }
}

extension ObservableType {
    func map<T: Translator>(translator: T) -> Observable<T.Output> where Self.E == T.Input {
        return map { translator.translate(entity: $0) }
    }
}

extension Collection {
    func map<T: Translator>(translator: T) -> [T.Output] where Self.Iterator.Element == T.Input {
        return map { translator.translate(entity: $0) }
    }
}
