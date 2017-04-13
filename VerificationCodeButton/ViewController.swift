//
//  ViewController.swift
//  VerificationCodeButton
//
//  Created by Aqua on 2017/4/13.
//  Copyright © 2017年 Aqua. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let button = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        button.center = view.center
        button.bounds = CGRect(x: 0, y: 0, width: 100, height: 50)
        button.setTitle("next page", for: .normal)
        button.addTarget(self, action: #selector(respondsToButton(sender:)), for: .touchUpInside)
        view.addSubview(button)
    }
    
    func respondsToButton(sender: UIButton) {
        navigationController?.pushViewController(ButtonViewController(), animated: true)
    }


}

