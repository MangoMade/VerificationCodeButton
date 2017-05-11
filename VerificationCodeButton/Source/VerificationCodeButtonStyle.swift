
import UIKit

protocol VerificationCodeButtonStyle {
    func normalState(_ button: VerificationCodeButton)
    func waitingState(_ button: VerificationCodeButton)
    func sendingState(_ button: VerificationCodeButton)
}


struct LoginVerificationCodeButtonStyle: VerificationCodeButtonStyle {
    private let disenabledColor = UIColor.lightGray.withAlphaComponent(0.5)
    private let enabledColor = UIColor.white
    
    func normalState(_ button: VerificationCodeButton) {
        let attString = NSMutableAttributedString(string: "获取",
                                                  attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 15),
                                                               NSForegroundColorAttributeName: UIColor.black])
        
        button.backgroundColor = enabledColor
        button.setAttributedTitle(attString, for: .normal)
    }
    
    func waitingState(_ button: VerificationCodeButton) {
        let attString = NSMutableAttributedString(string: "..",
                                                  attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 15) ,
                                                               NSForegroundColorAttributeName : UIColor.black])
        
        button.setAttributedTitle(attString, for: .normal)
        button.backgroundColor = disenabledColor
    }
    
    func sendingState(_ button: VerificationCodeButton) {
        if let currentAttributedTitle = button.currentAttributedTitle {
            let attString = NSMutableAttributedString(attributedString: currentAttributedTitle)
            attString.addAttribute(NSForegroundColorAttributeName,
                                   value: UIColor.gray,
                                   range: NSRange(location: 0, length: attString.length))
            
            button.setAttributedTitle(attString, for: .normal)
            button.backgroundColor = disenabledColor
        }
    }
}

