//
//  GetAuthCodeBtn.swift
//  HomerEU
//
//  Created by Wang on 16/4/13.
//  Copyright © 2016年 ios. All rights reserved.
//

import UIKit

enum SMSCodeButtonTime : String{

    case WhenForgetPassword           = "SMSCodeButtonForgetPasswordKey"
    case WhenLogin = "SMSCodeButtonWhenLogin"
}

class SMSCodeButton: UIButton {
    
    private enum SMSCodeButtonState{
        case Sending
        case Waiting
        case Normal
    }
    // MARK: properties
    private let userDefaultsKey : String
    
    var didTouchUpInside : (() -> Void)?
    private let style: SMSCodeButtonStyle
    
    private var sendInterval : TimeInterval = 60
    private var buttonState = SMSCodeButtonState.Normal{
        didSet{
            switch buttonState {
            case .Normal:
                style.normalState(self)
            case .Waiting:
                style.waitingState(self)
            case .Sending:
                style.sendingState(self)
            }
        }
    }
    
    private var lastTimeSendCode = NSDate(){
        didSet{
  
            UserDefaults.standard.setValue(NSDate(), forKey: userDefaultsKey)
        }
    }
    private var timer : Timer?
    
    // MARK: init
    // design init
    init(time: SMSCodeButtonTime, smsCodeButtonStyle: SMSCodeButtonStyle = LoginSMSCodeButtonStyle()) {
        userDefaultsKey = time.rawValue
        style = smsCodeButtonStyle
        super.init(frame: .zero)
        self.addTarget(self, action: #selector(respondsToTap), for: .touchUpInside)
        style.normalState(self)
        if let lastTime = UserDefaults.standard.value(forKey: userDefaultsKey) as? NSDate{
            self.lastTimeSendCode = lastTime
            setATimer()
        }
        self.layer.cornerRadius = Screen.scale * 2
    }
    
    func respondsToTap(){
        if self.buttonState == .Normal{
            self.buttonState = .Sending
            didTouchUpInside?()
        }
    }
    
    func countDown(sendInterval: TimeInterval = 60){
        lastTimeSendCode = NSDate()
        self.sendInterval = sendInterval
        setATimer()
    }
    
    func toNormalState(){
        self.buttonState = .Normal
    }
    
    private func setATimer(){
        if -lastTimeSendCode.timeIntervalSinceNow < sendInterval{
            self.buttonState = .Waiting
            let timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(SMSCodeButton.respondsToTimer(_:)), userInfo: nil, repeats: true)
            timer.fireDate = NSDate.distantPast
        }
    }
    
    func respondsToTimer(_ timer: Timer){
        let timeInterval = lastTimeSendCode.timeIntervalSinceNow + sendInterval
        if timeInterval > 0{
            setAttributedTitleString(string: "\(Int(round(timeInterval)))秒", forState: .normal)

        }else{
            timer.invalidate()
            toNormalState()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension UIButton {
    func setAttributedTitleString(string: String , forState state : UIControlState){
        guard let oldAttStr = attributedTitle(for: state) else { return }
        let attStr = NSMutableAttributedString(attributedString: oldAttStr)
        attStr.mutableString.setString(string)
        setAttributedTitle(attStr, for: state)
    }
    
    class func buttonWithTitle(title: String, font: UIFont) -> UIButton {
        let button = UIButton(type: .custom)
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = font
        return button
    }
}
