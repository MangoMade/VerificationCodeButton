

import UIKit


open class VerificationCodeButton: UIButton {
    
    private enum State {
        case sending
        case waiting
        case normal
    }
    
    private struct Const {
        static let userDefaultsKey = "Verification-Code-Button-Dic"
    }
    
    // MARK: properties
    public var didTouchUpInside : (() -> Void)?
    
    private let when : String
    
    private let style: VerificationCodeButtonStyle
    
    private var sendInterval : TimeInterval = 60
    
    private var buttonState = State.normal {
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
    
    private var lastSending = NSDate() {
        didSet{
            UserDefaults.standard.setValue(NSDate(), forKey: when)
        }
    }
    
    private var localLastSending: NSDate? {
        get {
            guard let dic = UserDefaults.standard.value(forKey: Const.userDefaultsKey) as? [String: NSDate] else {
                return nil
            }
            return dic[when]
        }
        set {
            var dic = UserDefaults.standard.value(forKey: Const.userDefaultsKey) as? [String: NSDate]
            if dic == nil {
                dic = [String: NSDate]()
            }
            dic![when] = newValue
            UserDefaults.standard.setValue(dic!, forKey: Const.userDefaultsKey)
        }
    }
    
    private var timer : Timer?
    
    // MARK: init
    // design init
    public init(when: String,
         style: VerificationCodeButtonStyle)
    {
        self.when = when
        self.style = style
        
        super.init(frame: .zero)
        
        self.addTarget(self, action: #selector(respondsToTap), for: .touchUpInside)
        style.normalState(self)
        if let lastTime = UserDefaults.standard.value(forKey: self.when) as? NSDate {
            self.lastSending = lastTime
            setATimer()
        }
        self.layer.cornerRadius = Screen.scale * 2
    }
    
    public required init?(coder aDecoder: NSCoder) {
        self.when = "123"
        self.style = LoginVerificationCodeButtonStyle()
        super.init(coder: aDecoder)
    }
    
    func respondsToTap() {
        if self.buttonState == .normal {
            self.buttonState = .sending
            didTouchUpInside?()
        }
    }
    
    public func countDown(sendInterval: TimeInterval = 60) {
        lastSending = NSDate()
        self.sendInterval = sendInterval
        setATimer()
    }
    
    func toNormalState() {
        self.buttonState = .normal
    }
    
    private func setATimer() {
        if -lastSending.timeIntervalSinceNow < sendInterval {
            
            self.buttonState = .waiting
            let timer = Timer.scheduledTimer(timeInterval: 1,
                                             target: self,
                                             selector: #selector(VerificationCodeButton.respondsToTimer(_:)),
                                             userInfo: nil,
                                             repeats: true)
            
            timer.fireDate = NSDate.distantPast
        }
    }
    
    func respondsToTimer(_ timer: Timer) {
        let timeInterval = lastSending.timeIntervalSinceNow + sendInterval
        if timeInterval > 0 {
            setAttributedTitleString(string: "\(Int(round(timeInterval)))秒", forState: .normal)
        } else {
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
