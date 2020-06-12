import Foundation

struct FacebookLoginInfo {

    public let userId: String
    public let accessToken: String
    public let email: String
    public let firstName: String
    public let lastName: String
    public let imageUrl: String
    public let profileUrl: String
    public let contactNumber: String
    public let categoryId: Int
    public let promoCode: String
    
    func toParam() -> [String: Any] {
        return [
            "userId": userId,
            "accessToken": accessToken,
            "username": email,
            "firstName": firstName,
            "lastName": lastName,
            "contactNumber": contactNumber,
            "category": categoryId,
            "promoCode": promoCode,
            "imageUrl": imageUrl
        ]
    }

}
