//
//  RoundImageView.swift
//  TaxiApp
//
//  Created by Loay on 6/18/19.
//  Copyright © 2019 Loay Productions. All rights reserved.
//

import UIKit

class RoundImageView: UIImageView {

// Functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
    }
    
    func setupView() {
        
        self.layer.cornerRadius = self.frame.width / 2
        self.clipsToBounds = true
        self.layer.borderWidth = 2.0
        self.layer.borderColor = UIColor.black.cgColor
    }

}
