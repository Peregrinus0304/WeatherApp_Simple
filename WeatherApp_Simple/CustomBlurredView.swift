//
//  CustomBlurredView.swift
//  WeatherApp_Simple
//
//  Created by Ozzy on 16.11.2020.
//  Copyright © 2020 Taras Motruk. All rights reserved.
//

import UIKit

@IBDesignable
class CustomBlurredView: UIVisualEffectView {

   
    @IBInspectable var borderColor: UIColor = UIColor.white {
    didSet {
    self.layer.borderColor = borderColor.cgColor
    }
    }
    @IBInspectable var borderWidth: CGFloat = 2.0 {
    didSet {
    self.layer.borderWidth = borderWidth
    }
    }
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
    didSet {
    self.layer.cornerRadius = cornerRadius
    }
    }
    }
    
    
