//
//  VerificationCodeControl.swift
//  VerificationCodeButton
//
//  Created by Aqua on 15/11/2017.
//  Copyright © 2017 Aqua. All rights reserved.
//

import UIKit


class VerificationCodeControl: UIControl {

    private struct Const {
        static let userDefaultsKey = "Verification-Code-Button-Dic"
    }
    
    private struct Default {
        static let font = UIFont.systemFont(ofSize: 14)
        static let normalText = "发送验证码"
        static let countingDownText = "%d秒后重发"
        static let resendingText = "重新发送"
        static let textColor = UIColor.black
        static let backgroundColor = UIColor.black
    }
    
    // MARK: Properties
    
    var textLabel = UILabel()

    private(set) var when: String
    
    var sendInterval: Double = 60
    
    // TODO: 增加类似UIButton的 按状态设置属性的方法

    private var status = VerificationCodeState.normal {
        didSet{
            updateView()
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
    
    private var texts: [VerificationCodeState: String] = [.normal: Default.normalText,
                                                          .countingDown: Default.countingDownText]
    private var fonts: [VerificationCodeState: UIFont] = [:]
    private var textColors: [VerificationCodeState: UIColor] = [:]
    private var backgroundColors: [VerificationCodeState: UIColor] = [:]
    private var backgroundImages: [VerificationCodeState: UIImage] = [:]
    private var attributedStrings: [VerificationCodeState: NSAttributedString] = [:]
    
    // MARK: - Class Method
    
    private func updateView() {

        if let attributedText = attributedText(for: status) {
            textLabel.attributedText = attributedText
        }
        textLabel.text = text(for: status)
        textLabel.font = font(for: status)
        textLabel.textColor = textColor(for: status)
        backgroundColor = backgroundColor(for: status)
    }
    
    func text(for state: VerificationCodeState) -> String {
        if let text = texts[status] {
            return text
        } else {
            return texts[VerificationCodeState.normal] ?? Default.normalText
        }
    }
    
    func textColor(for state: VerificationCodeState) -> UIColor {
        if let color = textColors[status] {
            return color
        } else {
            return textColors[VerificationCodeState.normal] ?? Default.textColor
        }
    }
    
    func font(for state: VerificationCodeState) -> UIFont {
        if let font = fonts[status] {
            return font
        } else {
            return fonts[VerificationCodeState.normal] ?? Default.font
        }
    }
    
    func backgroundColor(for state: VerificationCodeState) -> UIColor {
        if let color = backgroundColors[status] {
            return color
        } else {
            return backgroundColors[VerificationCodeState.normal] ?? Default.backgroundColor
        }
    }
    
    func backgroundImage(for state: VerificationCodeState) -> UIImage? {
        return nil
    }
    
    func attributedText(for state: VerificationCodeState) -> NSAttributedString? {
        if let attributedString = attributedStrings[status] {
            return attributedString
        } else if let attributedString = attributedStrings[VerificationCodeState.normal] {
            return attributedString
        } else {
            return nil
        }
    }

    // MARK: - Initialization
    
    public init(when: String)
    {
        self.when = when
        super.init(frame: .zero)
        
        commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        self.when = "default"

        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    private func commonInit() {
        // TODO: add action
        
        let tapGestrue = UITapGestureRecognizer(target: self, action: #selector(respondsToTap(_:)))
        addGestureRecognizer(tapGestrue)
        addSubview(textLabel)
        NSLayoutConstraint(item: textLabel,
                           attribute: .centerX,
                           relatedBy: .equal,
                           toItem: self,
                           attribute: .centerX,
                           multiplier: 1,
                           constant: 0).isActive = true
        
        NSLayoutConstraint(item: textLabel,
                           attribute: .centerY,
                           relatedBy: .equal,
                           toItem: self,
                           attribute: .centerY,
                           multiplier: 1,
                           constant: 0).isActive = true
        
        updateView()
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
    
    override var intrinsicContentSize: CGSize {
        return textLabel.intrinsicContentSize
    }
    
    // MARK: - Public methods
    
    func set(target: AnyObject?, selector: Selector?) {
        self.target = target
        self.selector = selector
    }
    
    func countDown() {
        nextEnableTime = Date(timeIntervalSinceNow: sendInterval)
        setATimer()
    }
    
    func toNormalState() {
        status = .normal
    }
    
    // MARK: - Private methods
    
    private func setATimer() {
        
        if nextEnableTime.timeIntervalSinceNow > 0 {
            
            status = .countingDown
            timer = Timer.scheduledTimer(timeInterval: 1,
                                         target: self,
                                         selector: #selector(VerificationCodeControl.respondsToTimer(_:)),
                                         userInfo: nil,
                                         repeats: true)
            
            timer?.fireDate = Date.distantPast
        }
    }
    
    private func setattributedTextString(string: String , forState state : VerificationCodeState) {
        /*
         guard let oldAttStr = attributedText(for: state) else { return }
         let attStr = NSMutableAttributedString(attributedString: oldAttStr)
         attStr.mutableString.setString(string)
         setattributedText(attStr, for: state)
         */
    }
    
    // MARK: - Action / Callback
    
    func respondsToTap() {
        
        if status == .normal {
            status = .sending
            if target?.responds(to: selector) == true {
                let _ = target?.perform(selector)
            }
        }
    }
    
    fileprivate func updateCountingDownText(second: Int) {
        if let attributedText = attributedText(for: .countingDown) {
            let text = String(format: attributedText.string, second)
            textLabel.attributedText = NSAttributedString(string: text, attributes: attributedText.attributes(at: 0, effectiveRange: nil))
        } else {
            let text = String(format: self.text(for: .countingDown), second)
            textLabel.text = text
        }
    }
}

// MARK: Action / Callback
extension VerificationCodeControl {
    
    @objc fileprivate func respondsToTap(_ gesture: UITapGestureRecognizer) {
        
    }
    
    @objc fileprivate func respondsToTimer(_ timer: Timer) {
        let timeInterval = nextEnableTime.timeIntervalSinceNow
        if timeInterval > 0 {
            setattributedTextString(string: "\(Int(round(timeInterval)))秒", forState: .normal)
        } else {
            timer.invalidate()
            status = .resend
        }
    }
}
