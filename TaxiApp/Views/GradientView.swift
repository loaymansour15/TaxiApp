//
//  GradientView.swift
//  TaxiApp
//
//  Created by Loay on 6/18/19.
//  Copyright © 2019 Loay Productions. All rights reserved.
//

import UIKit

class GradientView: UIView {

// Varaibles
    
    let gradient = CAGradientLayer()

// Functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupGradientView()
    }
    
    func setupGradientView() {
        
        gradient.startPoint = CGPoint.zero
        gradient.endPoint = CGPoint(x: 0, y: 1)
        gradient.colors = [UIColor.white.cgColor, UIColor.init(white: 1.0, alpha: 0.0).cgColor]
        gradient.locations = [0.7, 1.0]
        gradient.frame = self.bounds
        self.layer.addSublayer(gradient)
    }

}// End Class
