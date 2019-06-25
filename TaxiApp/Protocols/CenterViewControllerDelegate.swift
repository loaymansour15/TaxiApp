//
//  CenterViewControllerDelegate.swift
//  TaxiApp
//
//  Created by Loay on 6/18/19.
//  Copyright © 2019 Loay Productions. All rights reserved.
//

import UIKit

protocol CenterViewControllerDelegate {
    
    func toogleLeftPanel()
    func removeLeftSidePaneFromParentView()
    func addLeftPanelViewController()
    func animateLeftPanel(shouldExpand: Bool)
    
}// End Protocol


