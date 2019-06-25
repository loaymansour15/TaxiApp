//
//  RoundedCorner.swift
//  TaxiApp
//
//  Created by Loay on 6/19/19.
//  Copyright © 2019 Loay Productions. All rights reserved.
//

import UIKit

class RoundedCornerTextField: UITextField {

// Variables
    
    let padding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)

// Functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
    }
    
    func setupView() {
        
        self.layer.cornerRadius = self.frame.height / 4
        self.clipsToBounds = true
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

}
