//
//  RoundedShadowPickerView.swift
//  TaxiApp
//
//  Created by Loay on 6/19/19.
//  Copyright © 2019 Loay Productions. All rights reserved.
//

import UIKit

class RoundedPickerView: UIPickerView {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
    }
    
    func setupView() {
        
        self.layer.cornerRadius = 10.0
        self.layer.shadowColor = UIColor.red.cgColor
        self.layer.shadowOpacity = 0.7
        self.layer.shadowRadius = 5.0
        self.layer.shadowOffset = CGSize(width: 0, height: 5)
    }

}
