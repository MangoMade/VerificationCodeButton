//
//  ButtonViewController.swift
//  VerificationCodeButton
//
//  Created by Aqua on 2017/4/13.
//  Copyright © 2017年 Aqua. All rights reserved.
//

import UIKit
import VerificationCodeButton

class ButtonViewController: UIViewController {

    private let button = VerificationCodeButton(when: "login")
    private let styleButton = VerificationCodeButton(when: "register")
    private let gradientButton = GradientVerificationCodeButton(when: "gradient")

    override func viewDidLoad() {
        super.viewDidLoad()
  
        view.backgroundColor = UIColor.white
        button.center = view.center
        button.bounds = CGRect(x: 0, y: 0, width: 100, height: 50)
      
        button.addTarget(self, selector: #selector(countDown(_:)))
        button.sendInterval = 20
        view.addSubview(button)
        
        styleButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(styleButton)
        NSLayoutConstraint(item: styleButton,
                           attribute: .centerX,
                           relatedBy: .equal,
                           toItem: self.view,
                           attribute: .centerX,
                           multiplier: 1,
                           constant: 0).isActive = true
        
        NSLayoutConstraint(item: styleButton,
                           attribute: .centerY,
                           relatedBy: .equal,
                           toItem: self.view,
                           attribute: .centerY,
                           multiplier: 1,
                           constant: -150).isActive = true
        styleButton.addTarget(self, selector: #selector(countDown(_:)))
        view.addSubview(styleButton)
        
        styleButton.setText("获取验证码", for: .normal)
        styleButton.setText("正在发送...", for: .sending)
        let backgroundColor = UIColor(red: 0.96, green: 0.97, blue: 0.98, alpha: 1)
        styleButton.setBackgroundColor(backgroundColor, for: .sending)
        styleButton.setBackgroundColor(backgroundColor, for: .countingDown)
        
        var gradientButtonCenter = view.center
        gradientButtonCenter.y += 150
        gradientButton.center = gradientButtonCenter
        gradientButton.bounds = CGRect(x: 0, y: 0, width: 100, height: 50)
        
        gradientButton.addTarget(self, selector: #selector(countDown(_:)))
        gradientButton.sendInterval = 10
        let gradientConfig = (CGPoint(x: 0, y: 0.5), CGPoint(x: 1, y: 0.5), [UIColor.gradientOrange, UIColor.gradientPeach])
        gradientButton.setGradient(gradientConfig, for: .normal)
        gradientButton.setTextColor(.white, for: .normal)
        gradientButton.setBackgroundColor(.lightGray, for: .normal)
        view.addSubview(gradientButton)
    }

    @objc func countDown(_ sender: VerificationCodeButton) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            sender.countDown()
        }
    }
    
    @objc func didTap() {
        print(#function)
    }
}

extension UIColor {
    
    /**
     eg. UIColor.hexColor(0x000000)
     
     */
    
    convenience init(hex hexValue: Int, alpha: CGFloat = 1) {
        let redValue   = CGFloat((hexValue & 0xFF0000) >> 16) / 255.0
        let greenValue = CGFloat((hexValue & 0xFF00) >> 8) / 255.0
        let blueValue  = CGFloat(hexValue & 0xFF) / 255.0
        self.init(red: redValue, green: greenValue, blue: blueValue, alpha: alpha)
    }
    
    static var gradientOrange: UIColor {
        return UIColor(hex: 0xF77062)
    }
    
    static var gradientPeach: UIColor {
        return UIColor(hex: 0xFE5196)
    }
}
