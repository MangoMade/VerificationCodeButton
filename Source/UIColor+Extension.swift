//
//  UIColor+Extension.swift
//  VerificationCodeButton
//
//  Created by Aqua on 20/11/2017.
//  Copyright © 2017 Aqua. All rights reserved.
//

import UIKit

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
}

