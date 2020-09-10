//
//  CustomButton.swift
//  WeatherApp_Simple
//
//  Created by Ozzy on 09.09.2020.
//  Copyright © 2020 Taras Motruk. All rights reserved.
//

import UIKit

class CustomButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()

        layer.borderWidth = 1/UIScreen.main.nativeScale
        contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        titleLabel?.adjustsFontForContentSizeCategory = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height/2
        layer.borderColor = isEnabled ? tintColor.cgColor : UIColor.lightGray.cgColor
    }

    func animate() {
        let shake            = CABasicAnimation(keyPath: "position")
        shake.duration       = 0.06
        shake.repeatCount    = 2
        shake.autoreverses   = true
        
        let fromPoint        = CGPoint(x: center.x - 8, y: center.y)
        let fromValue        = NSValue(cgPoint: fromPoint)
        
        let toPoint          = CGPoint(x: center.x + 16, y: center.y)
        let toValue          = NSValue(cgPoint: fromPoint)
        
        shake.fromValue      = fromValue
        shake.toValue        = toValue
        
        layer.add(shake, forKey: "position")
    }
    
}
