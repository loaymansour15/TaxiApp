//
//  UIButtonExtension.swift
//  TaxiApp
//
//  Created by Loay on 6/20/19.
//  Copyright © 2019 Loay Productions. All rights reserved.
//

import UIKit

extension UIButton {
    
    func paddingTitle(_ paddingVal:CGFloat) {
        
        self.titleEdgeInsets = UIEdgeInsets(top: paddingVal,left: paddingVal,bottom: paddingVal,right: paddingVal)
    }
}
