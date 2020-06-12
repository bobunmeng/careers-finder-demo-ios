import Foundation

public extension String {

    func toDate(format: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: self)
    }

    public var shortDate: Date? {
        get {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy"
            return formatter.date(from: self)
        }
    }

    public var apiShortDate: Date? {
        get {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter.date(from: self)
        }
    }

    public func htmlAttributedString() -> NSAttributedString? {
        guard let data = self.data(using: .utf16, allowLossyConversion: false) else { return nil }
        guard let html = try? NSMutableAttributedString(
            data: data,
            options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html],
            documentAttributes: nil) else { return nil }
        return html
    }

    public func propercased() -> String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }

    mutating func propercased() {
        self = self.propercased()
    }

}
