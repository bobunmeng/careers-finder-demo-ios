import Foundation

public struct Auth: Model {

    public let id: Int
    public let accessToken: String
    public let expiredAt: Date

}
