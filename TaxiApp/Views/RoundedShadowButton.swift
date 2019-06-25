//
//  RoundedShadowButton.swift
//  TaxiApp
//
//  Created by Loay on 6/18/19.
//  Copyright © 2019 Loay Productions. All rights reserved.
//

import UIKit

class RoundedShadowButton: UIButton {

// Varaible
    
    var originalSize: CGRect?
    var paddingVal:CGFloat = 10.0
    
// Functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
    }
    
    func setupView() {
        
        originalSize = self.frame
        self.layer.cornerRadius = 5.0
        
        self.layer.shadowOpacity = 0.4
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowRadius = 5.0
        self.layer.shadowOffset = CGSize(width: 0, height: 6)
        self.titleEdgeInsets = UIEdgeInsets(top: paddingVal,left: paddingVal,bottom: paddingVal,right: paddingVal)
    }

    func animateButton(_ shouldLoad: Bool,_ message: String) {
        
        if shouldLoad {
            
            loadAction(message)
        } else {
            
            unloadAction(message)
        }
    }
    
    func loadAction(_ message: String) {
        
        self.setTitle(message, for: .normal)
        
        //self.isUserInteractionEnabled = false
    }
    
    func unloadAction(_ message: String) {
        
        self.setTitle(message, for: .normal)
    }

}
