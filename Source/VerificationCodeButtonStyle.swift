
import UIKit

public protocol VerificationCodeButtonStyle {
    func normalState(_ button: VerificationCodeButton)
    func waitingState(_ button: VerificationCodeButton)
    func sendingState(_ button: VerificationCodeButton)
}


public struct LoginVerificationCodeButtonStyle: VerificationCodeButtonStyle {
    
    public init () {}
    
    private let disenabledColor = UIColor.lightGray.withAlphaComponent(0.5)
    private let enabledColor = UIColor.white
    
    public func normalState(_ button: VerificationCodeButton) {
         /*
        let attString = NSMutableAttributedString(string: "获取验证码",
                                                  attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15),
                                                               NSAttributedStringKey.foregroundColor: UIColor.black])
        
        button.setAttributedTitle(attString, for: .normal)
         */
        button.backgroundColor = enabledColor
    }
    
    public func waitingState(_ button: VerificationCodeButton) {
        /*
        if let currentAttributedTitle = button.currentAttributedTitle {
            let attString = NSMutableAttributedString(attributedString: currentAttributedTitle)
            attString.addAttribute(NSForegroundColorAttributeName,
                                   value: UIColor.gray,
                                   range: NSRange(location: 0, length: attString.length))
            
            button.setAttributedTitle(attString, for: .normal)
            button.backgroundColor = disenabledColor
        }
         */
    }
    
    public func sendingState(_ button: VerificationCodeButton) {
        /*
        let attString = NSMutableAttributedString(string: "发送中..",
                                                  attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15) ,
                                                               NSAttributedStringKey.foregroundColor: UIColor.black])
        
        button.setAttributedTitle(attString, for: .normal)
         */
        button.backgroundColor = disenabledColor
    }
}

