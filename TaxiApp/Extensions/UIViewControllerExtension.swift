//
//  UIViewControllerExtension.swift
//  TaxiApp
//
//  Created by Loay on 6/23/19.
//  Copyright © 2019 Loay Productions. All rights reserved.
//

import UIKit

extension UIViewController {

    
    func registerKeyboardNotifications(currentView: UIViewController) {
        
        let center = NotificationCenter.default
        center.addObserver(currentView, selector: #selector(keyboardWillBeShown(notification: )), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)

        hideKeyboard(currentView)
    }
    
    func removeKeyboardNotifications(currentView: UIViewController) {
        
        let center = NotificationCenter.default
        center.removeObserver(currentView, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func keyboardWillBeShown(notification: Notification) {
        
    }
    
    func hideKeyboard(_ currentView: UIViewController) {
        
        let tap = UITapGestureRecognizer(target: currentView, action: #selector(handleScreenTap(currentView: )))
        currentView.view.addGestureRecognizer(tap)
    }
    
    @objc func handleScreenTap(currentView: UIViewController) {
        
        currentView.view.endEditing(true)
    }
}

//func animateTextFieldsVertically(_ rect: CGRect,_ currentView: UIViewController,_ constraintLine: NSLayoutConstraint) {
//
//    let const: CGFloat = 10
//
//    let offset = rect.origin.y - ((currentView.view.firstResponder()?.frame.origin.y)! + (currentView.view.firstResponder()?.frame.height)!)
//
//    self.view.layoutIfNeeded()
//    UIView.animate(withDuration: 0.25, animations: {
//
//        if offset < 0 {// field under keyboard
//            constraintLine.constant = constraintLine.constant + (offset * -1) + const
//        }
//
//        self.view.layoutIfNeeded()
//    })
//}
