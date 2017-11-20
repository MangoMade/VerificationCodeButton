//
//  VerificationCodeButton.swift
//  VerificationCodeButton
//
//  Created by Aqua on 15/11/2017.
//  Copyright © 2017 Aqua. All rights reserved.
//

import UIKit


public enum ButtonState {
    case normal
    case highlighted
    case sending
    case countingDown
    case resend
}

open class VerificationCodeButton: UIView {

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

    open private(set) var state = ButtonState.normal {
        didSet{
            
            updateView()
            stateDidChange(state)
        }
    }
    
    public private(set) lazy var backgroundImageView = setUpBackgroundImageView()
    
    // MARK: Private Properties
    
    /// For recording state before user tapping this button.
    /// It may be .resend or .normal
    private var stateBeforeTapping = ButtonState.normal
    
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
    private var texts: [ButtonState: String] = VerificationCodeButton.defaultTexts()
    private var fonts: [ButtonState: UIFont] = [:]
    private var textColors: [ButtonState: UIColor] = VerificationCodeButton.defaultTextColors()
    private var backgroundColors: [ButtonState: UIColor] = VerificationCodeButton.defaultBackgroundColors()
    private var backgroundImages: [ButtonState: UIImage] = [:]
    private var attributedStrings: [ButtonState: NSAttributedString] = [:]
    
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
extension VerificationCodeButton {
    
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
        state = .normal
    }
    
    /// You can override this methods to update custom UI.
    /// Called automatically when state changed and you should not call this method directly
    open func stateDidChange(_ state: ButtonState) {
 
    }
}

// MARK: - Style

extension VerificationCodeButton {
    
    open func setText(_ text: String?, for state: ButtonState) {
        texts[state] = text
        updateView()
    }
    
    open func setTextColor(_ color: UIColor?, for state: ButtonState) {
        textColors[state] = color
        updateView()
    }
    
    open func setFont(_ font: UIFont?, for state: ButtonState) {
        fonts[state] = font
        updateView()
    }
    
    open func setImage(_ image: UIImage?, for state: ButtonState) {
        backgroundImages[state] = image
        updateView()
    }
    
    open func setBackgroundImage(_ image: UIImage?, for state: ButtonState) {
        backgroundImages[state] = image
        updateView()
    }
    
    open func setAttributedText(_ text: NSAttributedString?, for state: ButtonState) {
        attributedStrings[state] = text
        updateView()
    }
    
    
    open func text(for state: ButtonState) -> String {
        if let text = texts[self.state] {
            return text
        } else {
            return texts[stateBeforeTapping] ?? Default.normalText
        }
    }
    
    open func textColor(for state: ButtonState) -> UIColor {
        if let color = textColors[self.state] {
            return color
        } else {
            return textColors[ButtonState.normal] ?? Default.textColor
        }
    }
    
    open func font(for state: ButtonState) -> UIFont {
        if let font = fonts[self.state] {
            return font
        } else {
            return fonts[ButtonState.normal] ?? Default.font
        }
    }
    
    open func backgroundColor(for state: ButtonState) -> UIColor {
        if let color = backgroundColors[self.state] {
            return color
        } else {
            return backgroundColors[ButtonState.normal] ?? Default.backgroundColor
        }
    }
    
    open func backgroundImage(for state: ButtonState) -> UIImage? {
        if let image = backgroundImages[self.state] {
            return image
        } else if let image = backgroundImages[ButtonState.normal] {
            return image
        } else {
            return nil
        }
    }
    
    open func attributedText(for state: ButtonState) -> NSAttributedString? {
        if let attributedString = attributedStrings[self.state] {
            return attributedString
        } else if let attributedString = attributedStrings[ButtonState.normal] {
            return attributedString
        } else {
            return nil
        }
    }
}

// MARK: - Private Methods
extension VerificationCodeButton {
    
    fileprivate func updateView() {
        
        if let attributedText = attributedText(for: state) {
            textLabel.attributedText = attributedText
        }
        textLabel.text      = text(for: state)
        textLabel.font      = font(for: state)
        textLabel.textColor = textColor(for: state)
        backgroundColor     = backgroundColor(for: state)
        backgroundImageView.image = backgroundImage(for: state)
    }
    
    fileprivate func setATimer() {
        
        if nextEnableTime.timeIntervalSinceNow > 0 {
            
            state = .countingDown
            timer = Timer.scheduledTimer(timeInterval: 1,
                                         target: self,
                                         selector: #selector(VerificationCodeButton.respondsToTimer(_:)),
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
    
    
    fileprivate func setUpBackgroundImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = true
        insertSubview(imageView, at: 0)
        let edges = [NSLayoutAttribute.top, .left, .right, .bottom]
        edges.forEach { (edge) in
            NSLayoutConstraint(item: imageView,
                               attribute: edge,
                               relatedBy: .equal,
                               toItem: self,
                               attribute: edge,
                               multiplier: 1,
                               constant: 0).isActive = true
        }
        return imageView
    }
}

// MARK: - Action / Callback
extension VerificationCodeButton {
    
    @objc fileprivate func respondsToTap(_ gesture: UILongPressGestureRecognizer) {
        
        if gesture.state == .began {
            
            stateBeforeTapping = state
            state = .highlighted
        } else if gesture.state == .ended {
            
            /// If gesture's location is in this view
            if bounds.contains(gesture.location(in: self)) {
                
                state = .sending
                if target?.responds(to: selector) == true {
                    let _ = target?.perform(selector, with: self)
                }
            } else {
                
                /// Gesture's location is out of this view
                /// So button just turn to previous state
                state = stateBeforeTapping
            }
        }
    }
    
    @objc fileprivate func respondsToTimer(_ timer: Timer) {
        let timeInterval = nextEnableTime.timeIntervalSinceNow
        if timeInterval > 0 {
            updateCountingDownText(second: Int(ceil(timeInterval)))
        } else {
            timer.invalidate()
            state = .resend
        }
    }
}

// MARK: - Private Class Methods

extension VerificationCodeButton {
    
    class func defaultTexts() -> [ButtonState: String] {
        return [
            .normal: Default.normalText,
            .sending: "发送中",
            .countingDown: "%d秒后重发",
            .resend: "重新发送",
        ]
    }
    
    class func defaultBackgroundColors() -> [ButtonState: UIColor] {
        return [
            .normal: Default.backgroundColor,
            .sending: UIColor.lightGray,
            .countingDown: UIColor.lightGray,
        ]
    }
    
    class func defaultTextColors() -> [ButtonState: UIColor] {
        return [
            .normal: Default.textColor,
            .sending: UIColor.gray,
            .countingDown: UIColor.gray,
        ]
    }
}

extension VerificationCodeButton: UIGestureRecognizerDelegate {
    
    open override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return [ButtonState.normal, .resend].contains(state)
    }
}
