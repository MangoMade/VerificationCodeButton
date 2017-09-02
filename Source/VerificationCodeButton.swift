

import UIKit

@IBDesignable open class VerificationCodeButton: UIView {
    
    public enum VerificationCodeState {
        case sending
        case waiting
        case normal
    }
    
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
    
    private var buttonState = VerificationCodeState.normal {
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
//        addTarget(self, action: #selector(respondsToTap), for: .touchUpInside)
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
    
    public func countDown() {
        nextEnableTime = Date(timeIntervalSinceNow: sendInterval)
        setATimer()
    }
    
    public func toNormalState() {
        self.buttonState = .normal
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
            
            self.buttonState = .waiting
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
        if self.buttonState == .normal {
            self.buttonState = .sending
            didTouchUpInside?()
        }
    }
    
    func respondsToTimer(_ timer: Timer) {
        let timeInterval = nextEnableTime.timeIntervalSinceNow
        if timeInterval > 0 {
            setAttributedTitleString(string: "\(Int(round(timeInterval)))秒", forState: .normal)
        } else {
            timer.invalidate()
            toNormalState()
        }
    }
}
