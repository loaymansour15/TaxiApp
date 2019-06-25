//
//  LangAndPermissionsViewController.swift
//  TaxiApp
//
//  Created by Loay on 6/20/19.
//  Copyright © 2019 Loay Productions. All rights reserved.
//

import UIKit

class LangAndPermissionsViewController: UIViewController {

// Variables
    
    @IBOutlet weak var langPicker: UIPickerView!
    @IBOutlet weak var doneButton: UIButton!
    
    var languages = ["English", "Arabic"]
    
// Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func doneAction(_ sender: Any) {
        
        AppDelegate.containerVC.loadThisScreen(screen: .homeVC)
    }
    
}// End Class

// Extension
extension LangAndPermissionsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        
        return languages.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return languages[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
    }
}
