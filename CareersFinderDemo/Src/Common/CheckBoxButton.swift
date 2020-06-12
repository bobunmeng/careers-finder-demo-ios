import UIKit

class CheckBox: UIButton {
    
    let checkedImage = UIImage(named: "ic-box-checked") ?? UIImage()
    let uncheckedImage = UIImage(named: "ic-box-unchecked") ?? UIImage()
    
    var isChecked: Bool = false {
        didSet {
            if isChecked {
                self.setImage(checkedImage, for: .normal)
            } else {
                self.setImage(uncheckedImage, for: .normal)
            }
        }
    }
    
    override func awakeFromNib() {
        self.addTarget(self, action: #selector(self.buttonClicked(sender:)), for: .touchUpInside)
    }
    
    @objc func buttonClicked(sender: UIButton) {
        if sender == self {
            isChecked = !isChecked
        }
    }
    
}
