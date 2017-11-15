

import UIKit


public enum VerificationCodeState {
    case sending
    case countingDown
    case normal
    case resend
    // TODO: add highlight state
}

@IBDesignable open class VerificationCodeButton: UIView {
    
    private struct Const {
        static let userDefaultsKey = "Verification-Code-Button-Dic"
    }
    
    // MARK: Properties
    
    public var titleLabel = UILabel()
    
    public var didTouchUpInside : (() -> Void)?
    
    @IBInspectable open private(set) var when: String
    
    @IBInspectable open var sendInterval: Double = 60 

    
    
    // TODO: 增加类似UIButton的 按状态设置属性的方法
    
    private lazy var backgroundImageView = UIImageView()
    
    private let style: VerificationCodeButtonStyle
    
    private var state = VerificationCodeState.normal {
        didSet{
            switch state {
            case .normal:
                style.normalState(self)
            case .countingDown:
                style.waitingState(self)
            case .sending:
                style.sendingState(self)
            case .resend:
                break
            }
        }
    }

    private var nextEnableTime: Date {
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
    
    private weak var target: AnyObject?
    private var selector: Selector?
    
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
    
        commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        self.when = "default"
        self.style = type(of: self).styleForStoryboard()
        
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    private func commonInit() {
        // TODO: add action

        let tapGestrue = UITapGestureRecognizer(target: self, action: #selector(respondsToTap(_:)))
        addGestureRecognizer(tapGestrue)
        addSubview(titleLabel)
        NSLayoutConstraint(item: titleLabel,
                           attribute: .centerX,
                           relatedBy: .equal,
                           toItem: self,
                           attribute: .centerX,
                           multiplier: 1,
                           constant: 0).isActive = true
        
        NSLayoutConstraint(item: titleLabel,
                           attribute: .centerY,
                           relatedBy: .equal,
                           toItem: self,
                           attribute: .centerY,
                           multiplier: 1,
                           constant: 0).isActive = true
        
        style.normalState(self)
    }
    
    // MARK: - Override
    
    open override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        if newWindow?.isKeyWindow == true {
            setATimer()
        } else {
            timer?.invalidate()
            timer = nil
        }
    }

    open override var intrinsicContentSize: CGSize {
        return titleLabel.intrinsicContentSize
    }
    
    // MARK: - Public methods
    
    public func set(target: AnyObject?, selector: Selector?) {
        self.target = target
        self.selector = selector
    }
    
    public func countDown() {
        nextEnableTime = Date(timeIntervalSinceNow: sendInterval)
        setATimer()
    }
    
    public func toNormalState() {
        self.state = .normal
    }
    
    open func setTitle(_ title: String?, for state: VerificationCodeState) {
        
    }
    
    open func setTitleColor(_ color: UIColor?, for state: VerificationCodeState) {
        
    }
 
    open func setBackgroundColor(_ color: UIColor?, for state: VerificationCodeState) {
        
    }
    
    open func setBackgroundImage(_ image: UIImage?, for state: VerificationCodeState) {
        
    }
    
    open func setAttributedTitle(_ title: NSAttributedString?, for state: VerificationCodeState) {
        
    }
    
    open func title(for state: VerificationCodeState) -> String? {
        return nil
    }
    
    open func titleColor(for state: VerificationCodeState) -> UIColor? {
        return nil
    }

    open func backgroundColor(for state: VerificationCodeState) -> UIColor? {
        return nil
    }
    
    open func backgroundImage(for state: VerificationCodeState) -> UIImage? {
        return nil
    }
    
    open func attributedTitle(for state: VerificationCodeState) -> NSAttributedString? {
        return nil
    }
    
    // MARK: - Private methods
    
    private func setATimer() {

        if nextEnableTime.timeIntervalSinceNow > 0 {
            
            self.state = .countingDown
            timer = Timer.scheduledTimer(timeInterval: 1,
                                         target: self,
                                         selector: #selector(VerificationCodeButton.respondsToTimer(_:)),
                                         userInfo: nil,
                                         repeats: true)
            
            timer?.fireDate = Date.distantPast
        }
    }
    
    private func setAttributedTitleString(string: String , forState state : VerificationCodeState) {
        /*
        guard let oldAttStr = attributedTitle(for: state) else { return }
        let attStr = NSMutableAttributedString(attributedString: oldAttStr)
        attStr.mutableString.setString(string)
        setAttributedTitle(attStr, for: state)
         */
    }
    
    // MARK: - Action / Callback
    
    func respondsToTap() {
        
        if state == .normal {
            state = .sending
            if target?.responds(to: selector) == true {
                let _ = target?.perform(selector)
            }
        }
    }
}

// MARK: Action / Callback
extension VerificationCodeButton {
    
    @objc fileprivate func respondsToTap(_ gesture: UITapGestureRecognizer) {
        
    }
    
    @objc fileprivate func respondsToTimer(_ timer: Timer) {
        let timeInterval = nextEnableTime.timeIntervalSinceNow
        if timeInterval > 0 {
            setAttributedTitleString(string: "\(Int(round(timeInterval)))秒", forState: .normal)
        } else {
            timer.invalidate()
            toNormalState()
        }
    }
}
