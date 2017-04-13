

import UIKit


class VerificationCodeButton: UIButton {
    
    private enum SMSCodeButtonState{
        case sending
        case waiting
        case normal
    }
    
    // MARK: properties
    var didTouchUpInside : (() -> Void)?
    
    private let userDefaultsKey : String
    
    private let style: VerificationCodeButtonStyle
    
    private var sendInterval : TimeInterval = 60
    
    private var buttonState = SMSCodeButtonState.normal {
        didSet{
            switch buttonState {
            case .normal:
                style.normalState(self)
            case .waiting:
                style.waitingState(self)
            case .sending:
                style.sendingState(self)
            }
        }
    }
    
    private var lastTimeSendCode = NSDate() {
        didSet{
            UserDefaults.standard.setValue(NSDate(), forKey: userDefaultsKey)
        }
    }
    private var timer : Timer?
    
    // MARK: init
    // design init
    init(when: String,
         style: VerificationCodeButtonStyle)
    {
        userDefaultsKey = when
        self.style = style
        
        super.init(frame: .zero)
        
        self.addTarget(self, action: #selector(respondsToTap), for: .touchUpInside)
        style.normalState(self)
        if let lastTime = UserDefaults.standard.value(forKey: userDefaultsKey) as? NSDate{
            self.lastTimeSendCode = lastTime
            setATimer()
        }
        self.layer.cornerRadius = Screen.scale * 2
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func respondsToTap(){
        if self.buttonState == .normal{
            self.buttonState = .sending
            didTouchUpInside?()
        }
    }
    
    func countDown(sendInterval: TimeInterval = 60){
        lastTimeSendCode = NSDate()
        self.sendInterval = sendInterval
        setATimer()
    }
    
    func toNormalState(){
        self.buttonState = .normal
    }
    
    private func setATimer(){
        if -lastTimeSendCode.timeIntervalSinceNow < sendInterval{
            self.buttonState = .waiting
            let timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(VerificationCodeButton.respondsToTimer(_:)), userInfo: nil, repeats: true)
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
    
    func setAttributedTitleString(string: String , forState state : UIControlState) {
        guard let oldAttStr = attributedTitle(for: state) else { return }
        let attStr = NSMutableAttributedString(attributedString: oldAttStr)
        attStr.mutableString.setString(string)
        setAttributedTitle(attStr, for: state)
    }
}
