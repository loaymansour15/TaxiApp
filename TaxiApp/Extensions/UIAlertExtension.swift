//
//  UIAlertExtension.swift
//  TaxiApp
//
//  Created by Loay on 6/20/19.
//  Copyright © 2019 Loay Productions. All rights reserved.
//

import UIKit

extension UIAlertController {
    
    // Show alet to user
    func showAlertWithTimer(title: String, msg: String, duration: Float, vc: UIViewController){
        
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        vc.present(alert, animated: true, completion: nil)
        Timer.scheduledTimer(withTimeInterval: TimeInterval(duration), repeats: false, block: { _ in alert.dismiss(animated: true, completion: nil)} )
    }
    
    func showAlert(title: String, msg: String, action: String, vc: UIViewController){
        
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: action, style: .cancel, handler: nil)
        alertController.addAction(okayAction)
        vc.present(alertController, animated: true, completion: nil)
    }
    
    func showAlertWithTimerAndSpinner(title: String, msg: String, duration: Float, vc: UIViewController, spinner: UIActivityIndicatorView){
        
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        vc.present(alert, animated: true, completion: nil)
        Timer.scheduledTimer(withTimeInterval: TimeInterval(duration), repeats: false, block: { _ in alert.dismiss(animated: true, completion: spinner.stopAnimating)} )
    }
    
    func showAlertWithSpinner(title: String, msg: String, action: String, vc: UIViewController, spinner: UIActivityIndicatorView){
        
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: action, style: .cancel, handler: nil)
        alertController.addAction(okayAction)
        vc.present(alertController, animated: true, completion: spinner.stopAnimating)
    }
}
