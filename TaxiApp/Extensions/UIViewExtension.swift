//
//  UIViewExtension.swift
//  TaxiApp
//
//  Created by Loay on 6/19/19.
//  Copyright © 2019 Loay Productions. All rights reserved.
//

import UIKit

extension UIView {
    
    func fadeTo(alphaValue: CGFloat, withDuration duration: TimeInterval) {
        
        UIView.animate(withDuration: duration, animations: {
            
            self.alpha = alphaValue
        })
    }
    
    func firstResponder() -> UIView? {
        
        if self.isFirstResponder {
            return self
        }
        
        for subview in self.subviews {
            if let firstResponder = subview.firstResponder() {
                return firstResponder
            }
        }
        
        return nil
    }
    
    func gredientView() {
        
        let gradient = CAGradientLayer()
        self.backgroundColor = UIColor.clear
        gradient.colors = [UIColor.white.cgColor, UIColor.init(white: 1.0, alpha: 0.0).cgColor]
        gradient.locations = [0.8, 1.0]
        gradient.startPoint = CGPoint.zero
        gradient.endPoint = CGPoint(x: 0, y: 1)
        gradient.frame = self.bounds
        self.layer.addSublayer(gradient)
    }
}
