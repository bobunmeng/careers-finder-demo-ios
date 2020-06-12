import UIKit

class RoundImageView : UIImageView {

    override func layoutSubviews() {
        super.layoutSubviews()

        self.roundImageView()
    }

    private func roundImageView() {
        self.layer.borderWidth = 1.0
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
    }

}
