//
//  LeftSidePanelViewController.swift
//  TaxiApp
//
//  Created by Loay on 6/18/19.
//  Copyright © 2019 Loay Productions. All rights reserved.
//

import UIKit
import FirebaseAuth


class LeftSidePanelViewController: UIViewController {

// Variables
    
    let main = UIStoryboard(name: "Main", bundle: Bundle.main)
    
    @IBOutlet weak var pictureView: RoundImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var beCaptinButton: UIButton!
    
    var alert = UIAlertController()
    
// Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
        self.getUserNameAndPicture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    @IBAction func beCaptinAction(_ sender: Any) {
        
    }
    
    @IBAction func showPaymentAction(_ sender: Any) {
        
        let nextVC = main.instantiateViewController(withIdentifier: "visaPaymentVC") as! VisaPaymentViewController
        //present(nextVC, animated: true)
        AppDelegate.navigation.pushViewController(nextVC, animated: true)
    }
    
    func getUserNameAndPicture() {
        
        getUserName()
        getPicture()
    }
    
    func getUserName() {
        
        let currentUser = Auth.auth().currentUser
        
        if let name = currentUser?.displayName {
            
            self.nameLabel.text = name
        } else {
            
            self.nameLabel.text = "Your Name"
        }
    }
    
    func getPicture () {
        
        let currentUser = Auth.auth().currentUser
        
        if let url = currentUser?.photoURL {
            
            DispatchQueue.global(qos: .userInitiated).async {[weak self] in
                if let data = try? Data(contentsOf: url){
                    DispatchQueue.main.async {
                        
                        let image = UIImage(data: data)
                        self!.pictureView.image = image
                    }
                }
            }
        }else {
            
            self.pictureView.image = UIImage(named: "noProfilePhoto")
        }
    }
    
    func setupView() {
        
        tableView.tableFooterView = UIView()
        beCaptinButton.paddingTitle(20)
    }

}// End Class

// Extensions

extension LeftSidePanelViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 4
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell!
        
        switch indexPath.row{
            
        case 0:
            cell = tableView.dequeueReusableCell(withIdentifier: "MenuItem1", for: indexPath)
        case 1:
            cell = tableView.dequeueReusableCell(withIdentifier: "MenuItem2", for: indexPath)
        case 2:
            cell = tableView.dequeueReusableCell(withIdentifier: "MenuItem3", for: indexPath)
        case 3:
            cell = tableView.dequeueReusableCell(withIdentifier: "MenuItem4", for: indexPath)
        default:
            cell = tableView.dequeueReusableCell(withIdentifier: "MenuItem1", for: indexPath)
        }
        
        return cell
    }
    
}




