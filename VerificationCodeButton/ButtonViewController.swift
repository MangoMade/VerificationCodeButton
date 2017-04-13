//
//  ButtonViewController.swift
//  VerificationCodeButton
//
//  Created by Aqua on 2017/4/13.
//  Copyright © 2017年 Aqua. All rights reserved.
//

import UIKit

class ButtonViewController: UIViewController {

    let button = VerificationCodeButton(when: "login", style: LoginVerificationCodeButtonStyle())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        button.center = view.center
        button.bounds = CGRect(x: 0, y: 0, width: 100, height: 50)
        button.setTitle("next page", for: .normal)
        
        
        button.didTouchUpInside = { [weak self] in
            guard let `self` = self else {
                return
            }
            self.perform(#selector(ButtonViewController.countDown), with: 0, afterDelay: 3)
        }
        
        view.addSubview(button)
    }

    func countDown() {
        DispatchQueue.main.async {
            self.button.countDown()
        }
    }

}
