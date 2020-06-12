import Foundation

class AuthTranslator: Translator {

    typealias Input = AuthEntity
    typealias Output = Auth

    func translate(entity: AuthEntity) -> Auth {
        return Auth(
            id: entity.id,
            accessToken: entity.accessToken,
            expiredAt: entity.expiredAt)
    }

}
