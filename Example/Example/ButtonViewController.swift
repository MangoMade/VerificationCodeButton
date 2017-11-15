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

    let button = VerificationCodeButton(when: "login", style: LoginVerificationCodeButtonStyle())
    
    let testButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        view.backgroundColor = UIColor.white
        button.center = view.center
        button.bounds = CGRect(x: 0, y: 0, width: 100, height: 50)
        button.backgroundColor = UIColor.gray
      
        button.didTouchUpInside = { [weak self] in
            guard let `self` = self else {
                return
            }
            self.perform(#selector(ButtonViewController.countDown), with: self.button, afterDelay: 3)
        }
        button.set(target: self, selector: #selector(didTap))
        view.addSubview(button)
        
        testButton.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
//        testButton.setAttributedTitle(NSAttributedString.init(string: "123"), for: .highlighted)
        testButton.setTitle("test", for: .normal)
        
        print(testButton.title(for: .highlighted))
        view.addSubview(testButton)
    }

    @objc func countDown(sender: VerificationCodeButton) {
        DispatchQueue.main.async {
            sender.countDown()
        }
    }

    @IBAction func buttonTaped(_ sender: Any) {
        if let sender = sender as? VerificationCodeButton {
            perform(#selector(ButtonViewController.countDown), with: sender, afterDelay: 3)
        }
    }
    
    @objc func didTap() {
        print(#function)
    }
}

class TestButton: VerificationCodeButton {
    override class func styleForStoryboard() -> VerificationCodeButtonStyle {
        return LoginVerificationCodeButtonStyle1()
    }
}

public struct LoginVerificationCodeButtonStyle1: VerificationCodeButtonStyle {
    
    public init () {}
    
    private let disenabledColor = UIColor.lightGray.withAlphaComponent(0.5)
    private let enabledColor = UIColor.white
    
    public func normalState(_ button: VerificationCodeButton) {
        let attString = NSMutableAttributedString(string: "获取验证码1",
                                                  attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15),
                                                               NSAttributedStringKey.foregroundColor: UIColor.black])
        
        button.backgroundColor = enabledColor
        button.setAttributedTitle(attString, for: .normal)
    }
    
    public func waitingState(_ button: VerificationCodeButton) {
        /*
        if let currentAttributedTitle = button.currentAttributedTitle {
            let attString = NSMutableAttributedString(attributedString: currentAttributedTitle)
            attString.addAttribute(NSForegroundColorAttributeName,
                                   value: UIColor.gray,
                                   range: NSRange(location: 0, length: attString.length))
            
            button.setAttributedTitle(attString, for: .normal)
            button.backgroundColor = disenabledColor
        }
         */
    }
    
    public func sendingState(_ button: VerificationCodeButton) {
        let attString = NSMutableAttributedString(string: "发送中..",
                                                  attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15) ,
                                                               NSAttributedStringKey.foregroundColor : UIColor.black])
        
        button.setAttributedTitle(attString, for: .normal)
        button.backgroundColor = disenabledColor
    }
}
