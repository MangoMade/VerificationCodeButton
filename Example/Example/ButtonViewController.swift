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

    let button = VerificationCodeButton(when: "login")

    override func viewDidLoad() {
        super.viewDidLoad()
  
        view.backgroundColor = UIColor.white
        button.center = view.center
        button.bounds = CGRect(x: 0, y: 0, width: 100, height: 50)
        button.backgroundColor = UIColor.gray
      

        button.set(target: self, selector: #selector(didTap))
        view.addSubview(button)
        
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


