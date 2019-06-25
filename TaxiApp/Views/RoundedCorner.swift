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
    
    var textRectOffset: CGFloat = 20

// Functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
    }
    
    func setupView() {
        
        self.layer.cornerRadius = self.frame.height / 2
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        
        return CGRect(x: 0 + textRectOffset, y: 0 + (textRectOffset/2), width: self.frame.width - textRectOffset, height: self.frame.height + textRectOffset)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        
        return CGRect(x: 0 + textRectOffset, y: 0 + (textRectOffset/2), width: self.frame.height - textRectOffset, height: self.frame.height + textRectOffset)
    }

}
