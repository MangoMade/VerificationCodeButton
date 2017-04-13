//
//  SMSCodeButtonStyle.swift
//  HomerEU
//
//  Created by 崔皓 on 16/6/5.
//  Copyright © 2016年 ios. All rights reserved.
//

import UIKit

protocol SMSCodeButtonStyle {
    func normalState(_ smsCodeButton: SMSCodeButton)
    func waitingState(_ smsCodeButton: SMSCodeButton)
    func sendingState(_ smsCodeButton: SMSCodeButton)
}


struct LoginSMSCodeButtonStyle: SMSCodeButtonStyle {
    private let disenabledColor = UIColor.lightGray
    private let enabledColor = UIColor.black
    
    func normalState(_ smsCodeButton: SMSCodeButton) {
        let attString = NSMutableAttributedString(string: "获取", attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 15) , NSForegroundColorAttributeName: UIColor.black])
        smsCodeButton.backgroundColor = enabledColor
        smsCodeButton.setAttributedTitle(attString, for: .normal)
    }
    
    func waitingState(_ smsCodeButton: SMSCodeButton) {
        let attString = NSMutableAttributedString(string: "..", attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 15) , NSForegroundColorAttributeName : UIColor.black])
        smsCodeButton.setAttributedTitle(attString, for: .normal)
        smsCodeButton.backgroundColor = disenabledColor
    }
    
    func sendingState(_ smsCodeButton: SMSCodeButton) {
        if let currentAttributedTitle = smsCodeButton.currentAttributedTitle{
            let attString = NSMutableAttributedString(attributedString: currentAttributedTitle)
            attString.addAttribute(NSForegroundColorAttributeName, value: UIColor.black, range: NSRange(location: 0, length: attString.length))
            smsCodeButton.setAttributedTitle(attString, for: .normal)
            smsCodeButton.backgroundColor = disenabledColor
        }
    }
}

