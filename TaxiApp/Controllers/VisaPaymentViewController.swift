//
//  VisaPaymentViewController.swift
//  TaxiApp
//
//  Created by Loay on 6/25/19.
//  Copyright © 2019 Loay Productions. All rights reserved.
//

import UIKit
import Stripe
import FirebaseDatabase

class VisaPaymentViewController: UIViewController {
   
// Variables
    var paymentVC: STPAddCardViewController?
    let paymentCardTextField = STPPaymentCardTextField()
    
// Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()

        delegatePayementTF()
    }
    
    @IBAction func backButton(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
}

extension VisaPaymentViewController: STPAddCardViewControllerDelegate, STPPaymentCardTextFieldDelegate {
    
    func delegatePayementTF() {
        
        // Setup payment card text field
        paymentCardTextField.delegate = self
        
        // Add payment card text field to view
        view.addSubview(paymentCardTextField)
    }
    
    func showCard() {
        
        let config = STPPaymentConfiguration()
        config.requiredBillingAddressFields = .full
        paymentVC = STPAddCardViewController(configuration: config, theme: STPTheme.default())
        paymentVC!.delegate = self
        let nav = UINavigationController(rootViewController: paymentVC!)
        present(nav, animated: true)
    }
    
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        
        dismiss(animated: true, completion: nil)
    }
}
