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

    let button = VerificationCodeControl(when: "login")

    override func viewDidLoad() {
        super.viewDidLoad()
  
        view.backgroundColor = UIColor.white
        button.center = view.center
        button.bounds = CGRect(x: 0, y: 0, width: 100, height: 50)
      
        button.addTarget(self, selector: #selector(countDown(_:)))
        button.sendInterval = 10
        view.addSubview(button)
        
    }

    @objc func countDown(_ sender: VerificationCodeControl) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
            sender.countDown()
        }
    }
    
    @objc func didTap() {
        print(#function)
    }
}


