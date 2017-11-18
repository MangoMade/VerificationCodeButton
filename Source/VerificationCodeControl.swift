//
//  VerificationCodeControl.swift
//  VerificationCodeButton
//
//  Created by Aqua on 15/11/2017.
//  Copyright © 2017 Aqua. All rights reserved.
//

import UIKit


public enum VerificationCodeState {
    case normal
    case highlighted
    case sending
    case countingDown
    case resend
}

open class VerificationCodeControl: UIView {

    private struct Const {
        static let userDefaultsKey = "Verification-Code-Button-Dic"
    }
    
    private struct Default {
        static let font = UIFont.systemFont(ofSize: 14)
        static let normalText = "发送验证码"
        static let textColor = UIColor.black
        static let backgroundColor = UIColor.white
    }
    
    // MARK: Public Properties

    open var sendInterval: Double = 60

    open private(set) var status = VerificationCodeState.normal {
        didSet{
            
            updateView()
            statusDidChange(status)
        }
    }
    
    // MARK: Private Properties
    
    /// For recording status before user tapping this button.
    /// It may be .resend or .normal
    private var statusBeforeTapping = VerificationCodeState.normal
    
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
    
    private var textLabel = UILabel()
    
    private(set) var when: String
    
    private var timer : Timer?
    
    /// Action
    private weak var target: AnyObject?
    private var selector: Selector?
    
    /// Properties for style
    private var texts: [VerificationCodeState: String] = VerificationCodeControl.defaultTexts()
    private var fonts: [VerificationCodeState: UIFont] = [:]
    private var textColors: [VerificationCodeState: UIColor] = VerificationCodeControl.defaultTextColors()
    private var backgroundColors: [VerificationCodeState: UIColor] = VerificationCodeControl.defaultBackgroundColors()
    private var backgroundImages: [VerificationCodeState: UIImage] = [:]
    private var attributedStrings: [VerificationCodeState: NSAttributedString] = [:]
    
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
        
        let tapGestrue = UILongPressGestureRecognizer(target: self, action: #selector(respondsToTap(_:)))
        tapGestrue.delegate = self
        tapGestrue.minimumPressDuration = 0
        addGestureRecognizer(tapGestrue)
        
        textLabel.translatesAutoresizingMaskIntoConstraints = false
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
    
    open override var intrinsicContentSize: CGSize {
        return textLabel.intrinsicContentSize
    }
}

// MARK: - Public Methods
extension VerificationCodeControl {
    
    open func addTarget(_ target: AnyObject?, selector: Selector?) {
        self.target = target
        self.selector = selector
    }
    
    /// When servers response your request and sended sms.
    /// You should call this method to begin counting down
    open func countDown() {
        nextEnableTime = Date(timeIntervalSinceNow: sendInterval)
        setATimer()
    }
    
    open func toNormalState() {
        status = .normal
    }
    
    /// You can override this methods to update custom UI.
    /// Called automatically when status changed and you should not call this method directly
    open func statusDidChange(_ status: VerificationCodeState) {
        
    }
}

// MARK: - Style

extension VerificationCodeControl {
    
    open func text(for state: VerificationCodeState) -> String {
        if let text = texts[status] {
            return text
        } else {
            return texts[statusBeforeTapping] ?? Default.normalText
        }
    }
    
    open func textColor(for state: VerificationCodeState) -> UIColor {
        if let color = textColors[status] {
            return color
        } else {
            return textColors[VerificationCodeState.normal] ?? Default.textColor
        }
    }
    
    open func font(for state: VerificationCodeState) -> UIFont {
        if let font = fonts[status] {
            return font
        } else {
            return fonts[VerificationCodeState.normal] ?? Default.font
        }
    }
    
    open func backgroundColor(for state: VerificationCodeState) -> UIColor {
        if let color = backgroundColors[status] {
            return color
        } else {
            return backgroundColors[VerificationCodeState.normal] ?? Default.backgroundColor
        }
    }
    
    open func backgroundImage(for state: VerificationCodeState) -> UIImage? {
        return nil
    }
    
    open func attributedText(for state: VerificationCodeState) -> NSAttributedString? {
        if let attributedString = attributedStrings[status] {
            return attributedString
        } else if let attributedString = attributedStrings[VerificationCodeState.normal] {
            return attributedString
        } else {
            return nil
        }
    }
}

// MARK: - Private Methods
extension VerificationCodeControl {
    
    fileprivate func updateView() {
        
        if let attributedText = attributedText(for: status) {
            textLabel.attributedText = attributedText
        }
        textLabel.text = text(for: status)
        textLabel.font = font(for: status)
        textLabel.textColor = textColor(for: status)
        backgroundColor = backgroundColor(for: status)
    }
    
    fileprivate func setATimer() {
        
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

// MARK: - Action / Callback
extension VerificationCodeControl {
    
    @objc fileprivate func respondsToTap(_ gesture: UILongPressGestureRecognizer) {
        
        if gesture.state == .began {
            statusBeforeTapping = status
            status = .highlighted
        } else if gesture.state == .ended {
            
            /// If gesture's location is in this view
            if bounds.contains(gesture.location(in: self)) {
                status = .sending
                if target?.responds(to: selector) == true {
                    let _ = target?.perform(selector, with: self)
                }
            } else {
                
                /// Gesture's location is out of this view
                /// So button just turn to previous status
                status = statusBeforeTapping
            }
        }
    }
    
    @objc fileprivate func respondsToTimer(_ timer: Timer) {
        let timeInterval = nextEnableTime.timeIntervalSinceNow
        if timeInterval > 0 {
            updateCountingDownText(second: Int(ceil(timeInterval)))
        } else {
            timer.invalidate()
            status = .resend
        }
    }
}

// MARK: - Private Class Methods

extension VerificationCodeControl {
    
    class func defaultTexts() -> [VerificationCodeState: String] {
        return [
            .normal: Default.normalText,
            .sending: "发送中",
            .countingDown: "%d秒后重发",
            .resend: "重新发送",
        ]
    }
    
    class func defaultBackgroundColors() -> [VerificationCodeState: UIColor] {
        return [
            .normal: Default.backgroundColor,
            .sending: UIColor.lightGray,
            .countingDown: UIColor.lightGray,
        ]
    }
    
    class func defaultTextColors() -> [VerificationCodeState: UIColor] {
        return [
            .normal: Default.textColor,
            .sending: UIColor.gray,
            .countingDown: UIColor.gray,
        ]
    }
}

extension VerificationCodeControl: UIGestureRecognizerDelegate {
    
    open override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return [VerificationCodeState.normal, .resend].contains(status)
    }
}
