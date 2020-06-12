import UIKit

extension UILabel {

    func setHTMLText(text: String) {
        let modifiedFont = String(format:"<span style=\"font-family: '-apple-system', 'HelveticaNeue'; font-size: \(self.font!.pointSize)\">%@</span>", text)
        let attrStr = try! NSAttributedString(
            data: modifiedFont.data(using: .utf16, allowLossyConversion: false)!,
            options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html],
            documentAttributes: nil)
        self.attributedText = attrStr
    }

}
