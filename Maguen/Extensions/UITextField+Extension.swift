//
//  UITextField+Extension.swift
//  Maguen
//
//  Created by ExpresionBinaria on 11/6/18.
//  Copyright © 2018 Expression B. All rights reserved.
//

import UIKit

extension UITextField {
    func underlinedWhenSelected(){
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.cyan.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    
    func underlineWhenNonSelected() {
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.black.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}
