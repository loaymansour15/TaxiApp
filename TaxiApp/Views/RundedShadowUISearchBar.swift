//
//  RundedShadowUISearchBar.swift
//  TaxiApp
//
//  Created by Loay on 6/24/19.
//  Copyright © 2019 Loay Productions. All rights reserved.
//

import UIKit

class RoundedShadowSearchBar: UISearchBar {
    
    // Variables
    
    
    // Functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
    }
    
    func setupView() {
        
        self.searchBarStyle = .minimal
        
        self.layer.shadowOpacity = 0.4
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowRadius = 5.0
        self.layer.shadowOffset = CGSize(width: 0, height: 6)
    }
}
