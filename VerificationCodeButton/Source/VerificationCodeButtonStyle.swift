
import UIKit

protocol VerificationCodeButtonStyle {
    func normalState(_ smsCodeButton: VerificationCodeButton)
    func waitingState(_ smsCodeButton: VerificationCodeButton)
    func sendingState(_ smsCodeButton: VerificationCodeButton)
}


struct LoginVerificationCodeButtonStyle: VerificationCodeButtonStyle {
    private let disenabledColor = UIColor.lightGray.withAlphaComponent(0.5)
    private let enabledColor = UIColor.white
    
    func normalState(_ smsCodeButton: VerificationCodeButton) {
        let attString = NSMutableAttributedString(string: "获取",
                                                  attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 15),
                                                               NSForegroundColorAttributeName: UIColor.black])
        
        smsCodeButton.backgroundColor = enabledColor
        smsCodeButton.setAttributedTitle(attString, for: .normal)
    }
    
    func waitingState(_ smsCodeButton: VerificationCodeButton) {
        let attString = NSMutableAttributedString(string: "..",
                                                  attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 15) ,
                                                               NSForegroundColorAttributeName : UIColor.black])
        
        smsCodeButton.setAttributedTitle(attString, for: .normal)
        smsCodeButton.backgroundColor = disenabledColor
    }
    
    func sendingState(_ smsCodeButton: VerificationCodeButton) {
        if let currentAttributedTitle = smsCodeButton.currentAttributedTitle {
            let attString = NSMutableAttributedString(attributedString: currentAttributedTitle)
            attString.addAttribute(NSForegroundColorAttributeName,
                                   value: UIColor.gray,
                                   range: NSRange(location: 0, length: attString.length))
            
            smsCodeButton.setAttributedTitle(attString, for: .normal)
            smsCodeButton.backgroundColor = disenabledColor
        }
    }
}

