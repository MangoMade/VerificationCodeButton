

import UIKit

@IBDesignable open class VerificationCodeButton: UIButton {
    
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
    
    @IBInspectable private(set) var when: String
    
    @IBInspectable var sendInterval: TimeInterval = 60
    
    private let style: VerificationCodeButtonStyle
    
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
    
    /*

    */
    private var localLastSending: Date {
        get {
            if let dic = UserDefaults.standard.value(forKey: Const.userDefaultsKey) as? [String: Date] {
                if let date = dic[when] {
                    return date
                }
            }
            return Date.distantPast
        }
        set {
            var dic = UserDefaults.standard.value(forKey: Const.userDefaultsKey) as? [String: Date]
            if dic == nil {
                dic = [String: Date]()
            }
            dic![when] = newValue
            UserDefaults.standard.setValue(dic!, forKey: Const.userDefaultsKey)
        }
    }
    
    private var timer : Timer?
    
    // MARK: - Class Method
    
    open class func styleForStoryboard() -> VerificationCodeButtonStyle {
        return LoginVerificationCodeButtonStyle()
    }
    
    // MARK: - Initialization

    public init(when: String,
         style: VerificationCodeButtonStyle)
    {
        self.when = when
        self.style = style
        
        super.init(frame: .zero)
        
        self.addTarget(self, action: #selector(respondsToTap), for: .touchUpInside)
        style.normalState(self)
        setATimer()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        self.when = "default"
        self.style = type(of: self).styleForStoryboard()
        
        super.init(coder: aDecoder)
        
        self.addTarget(self, action: #selector(respondsToTap), for: .touchUpInside)
        style.normalState(self)
        setATimer()
    }
    
    public func countDown(sendInterval: TimeInterval = 60) {
        localLastSending = Date()
        self.sendInterval = sendInterval
        setATimer()
    }
    
    public func toNormalState() {
        self.buttonState = .normal
    }
    
    private func setATimer() {
        if -localLastSending.timeIntervalSinceNow < sendInterval {
            
            self.buttonState = .waiting
            let timer = Timer.scheduledTimer(timeInterval: 1,
                                             target: self,
                                             selector: #selector(VerificationCodeButton.respondsToTimer(_:)),
                                             userInfo: nil,
                                             repeats: true)
            
            timer.fireDate = Date.distantPast
        }
    }
    
    private func setAttributedTitleString(string: String , forState state : UIControlState) {
        guard let oldAttStr = attributedTitle(for: state) else { return }
        let attStr = NSMutableAttributedString(attributedString: oldAttStr)
        attStr.mutableString.setString(string)
        setAttributedTitle(attStr, for: state)
    }
    
    func respondsToTap() {
        if self.buttonState == .normal {
            self.buttonState = .sending
            didTouchUpInside?()
        }
    }
    
    func respondsToTimer(_ timer: Timer) {
        let timeInterval = localLastSending.timeIntervalSinceNow + sendInterval
        if timeInterval > 0 {
            setAttributedTitleString(string: "\(Int(round(timeInterval)))秒", forState: .normal)
        } else {
            timer.invalidate()
            toNormalState()
        }
    }
}
