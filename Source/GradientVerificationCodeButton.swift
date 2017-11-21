//
//  GradientVerificationCodeButton.swift
//  VerificationCodeButton
//
//  Created by Aqua on 20/11/2017.
//  Copyright © 2017 Aqua. All rights reserved.
//

import UIKit

public typealias GradientConfig = (startPoint: CGPoint, endPoint: CGPoint, colors: [UIColor])

open class GradientVerificationCodeButton: VerificationCodeButton {
    
    private let gradientLayer = CAGradientLayer()
    
    private var gradients: [ButtonState: GradientConfig?] = [:]
    
    //MARK: Init / Deinit
    
    private func commonInit() {
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    public override init(when: String) {
        super.init(when: when)
        commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
    
    open override func updateView() {
        super.updateView()
        if let gradient = gradient(for: state) {
            gradientLayer.startPoint = gradient.startPoint
            gradientLayer.endPoint   = gradient.endPoint
            gradientLayer.colors     = gradient.colors.map{ $0.cgColor }
        } else {
            gradientLayer.colors     = nil
        }
    }
}

extension GradientVerificationCodeButton {
    
    open func setGradient(_ gradient: GradientConfig?, for state: ButtonState) {
        gradients[state] = gradient
        updateView()
    }

    open func gradient(for state: ButtonState) -> GradientConfig? {
        if let gradient = gradients[state] {
            return gradient
        } else if state == .resend, let gradient = gradients[.normal] {
            return gradient
        } else {
            return nil
        }
    }
}
