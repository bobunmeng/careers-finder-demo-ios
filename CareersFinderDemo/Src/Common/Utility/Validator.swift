import Foundation

public func isEmailValid(email: String) -> Bool {
    let pattern = "^(([\\w-]+\\.)+[\\w-]+|([a-zA-Z]|[\\w-]{2,}))@"
        + "((([0-1]?[0-9]{1,2}|25[0-5]|2[0-4][0-9])\\.([0-1]?"
        + "[0-9]{1,2}|25[0-5]|2[0-4][0-9])\\."
        + "([0-1]?[0-9]{1,2}|25[0-5]|2[0-4][0-9])\\.([0-1]?"
        + "[0-9]{1,2}|25[0-5]|2[0-4][0-9]))|"
        + "([a-zA-Z]+[\\w-]+\\.)+[a-zA-Z]{2,4})$"

    return email.range(of: pattern, options: .regularExpression, range: nil, locale: nil) != nil
}

public func isValidPhone(number: String) -> Bool {
    if number.count < 8 || number.count > 15 {
        return false
    }
    return true
}
