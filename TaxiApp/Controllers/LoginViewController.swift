//
//  LoginViewController.swift
//  TaxiApp
//
//  Created by Loay on 6/19/19.
//  Copyright © 2019 Loay Productions. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FBSDKCoreKit
import FBSDKLoginKit
import FacebookLogin

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate, UITextFieldDelegate {
    
    // Variables
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var emailLoginButton: UIButton!
    @IBOutlet weak var facebookButton: FBSDKLoginButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    
    @IBOutlet weak var constraintLine: NSLayoutConstraint!
    
    var tempBottomConstraintConstant: CGFloat!
    
    var alert = UIAlertController()
    
    // Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        
        // Keyboard related
        keyboardReleated()
        
        // Delegate fb login button and permissions
        self.facebookButton.delegate = self
        self.facebookButton.readPermissions = ["public_profile", "email"]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(false)
        
        self.removeKeyboardNotifications(currentView: self)
    }
    
    func keyboardReleated() {
        
        tempBottomConstraintConstant = constraintLine.constant
        self.registerKeyboardNotifications(currentView: self)
        emailField.delegate = self
        passwordField.delegate = self
    }
    
    // Facebook login
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        // Empty fields before start
        self.emailField.text = ""
        self.passwordField.text = ""
        
        // Show spinner
        self.disableAll()
        
        guard let accessToken = FBSDKAccessToken.current() else {
            self.enableAll()
            return
        }
        
        let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
        // Perform login by calling Firebase APIs
        Auth.auth().signIn(with: credential) { (user, error) in
            
            if let error = error {
                self.alert.showAlert(title: "Login Error", msg: error.localizedDescription, action: "OK", vc: self)
                self.enableAll()
                return
            }else {
                
                // Check if user is already in database
                // If user is not in database call save function
                let currentUser = Auth.auth().currentUser
                if let email = currentUser!.email{
                    
                    let node = Dataservice.instance.REF_PASSENGERS
                    let ans = node.queryOrdered(byChild: "email").queryEqual(toValue: email)
                    ans.observe(.value, with:{ (snapshot) in
                        
                        if snapshot.exists() == false {
                            
                            let name = currentUser?.displayName ?? ""
                            self.saveUserToDatabase(uid: (currentUser?.uid)!, email: email, name: name)
                            
                            // Present the main view
                            AppDelegate.containerVC.loadThisScreen(screen: .langAndPermVC)
                        }else{
                            // Present the main view
                            AppDelegate.containerVC.loadThisScreen(screen: .homeVC)
                        }
                    })
                }
                
            }
        }
    }
    
    // Facebook logout
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
        if FirebaseAuth.Auth.auth().currentUser != nil {
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
            } catch let signOutError as NSError {
                
                print ("Error signing out: %@", signOutError)
            }
        }
        
        if FBSDKAccessToken.current() != nil {
            let loginManager = FBSDKLoginManager()
            loginManager.logOut()
        }
        
        // UnFreeze other buttons and textFields
        self.enableAll()
    }
    
    // Email login
    @IBAction func emailLogin(_ sender: Any) {
        
        let email = self.emailField.text!
        let password = self.passwordField.text!
        
        if (email.isEmpty == false && password.isEmpty == false) {
            
            // Show spinner
            self.disableAll()
            
            // Hide keyboard
            self.view.endEditing(true)
            
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                
                if error == nil {
                    
                    // Present the main view
                    AppDelegate.containerVC.loadThisScreen(screen: .homeVC)
                } else{// Create new user
                    
                    if let errorCode = AuthErrorCode.init(rawValue: error!._code){
                        
                        switch errorCode {
                            
                        case .invalidEmail:
                            self.alert.showAlert(title: "Login Issue", msg: "Email is Invalid", action: "OK", vc: self)
                            self.enableAll()
                        case .wrongPassword:
                            self.alert.showAlert(title: "Login Issue", msg: "Wrong Password", action: "OK", vc: self)
                            self.enableAll()
                        default:
                            let createAccountAlert = UIAlertController(title: "New Account", message: "Do you want to create a new Account?", preferredStyle: UIAlertController.Style.alert)
                            
                            createAccountAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
                                self.createNewUserWithEmail(email, password)
                            }))
                            createAccountAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
                                self.enableAll()
                                self.spinner.stopAnimating()
                            }))
                            self.present(createAccountAlert, animated: true, completion: nil)
                            
                        }
                    }
                    
                }
            }
        }else { // Empty fields
            
            self.alert.showAlert(title: "Empty Fields", msg: "Please enter your email and password", action: "OK", vc: self)
        }
    }
    
    func createNewUserWithEmail(_ email: String,_ password: String) {
        
        Auth.auth().createUser(withEmail: email, password: password) { (newUser, err) in
            if err != nil {// Email or password error
                
                if let errorCode = AuthErrorCode.init(rawValue: err!._code){
                    
                    switch errorCode {
                        
                    case .emailAlreadyInUse:
                        self.alert.showAlert(title: "Registeration Issue", msg: "Email is already registered OR re-type your password", action: "OK", vc: self)
                    case .invalidEmail:
                        self.alert.showAlert(title: "Registeration Issue", msg: "This Email is Invalid", action: "OK", vc: self)
                    case .weakPassword:
                        self.alert.showAlert(title: "Registeration Issue", msg: "Please Try a Longer Password", action: "OK", vc: self)
                    default:
                        self.alert.showAlert(title: "Registeration Issue", msg: "Something Wrong with the Registeration", action: "OK", vc: self)
                    }
                }
                
                // UnFreeze other buttons and textFields
                self.enableAll()
            } else {// Create new user
                
                let name = (newUser?.user.displayName) ?? ""
                self.saveUserToDatabase(uid: (newUser?.user.uid)!, email: email, name: name)
                
                let registeredAlert = UIAlertController(title: "Email Registered", message: "Your email has been created successfuly", preferredStyle: UIAlertController.Style.alert)
                
                registeredAlert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { (action: UIAlertAction!) in
                    AppDelegate.containerVC.loadThisScreen(screen: .langAndPermVC)
                }))
                self.present(registeredAlert, animated: true, completion: nil)
            }
            
        }
    }
    
    // Forget password
    @IBAction func forgetPasswordAction(_ sender: Any) {
        
    }
    
    func isUserSignedInWithEmail() -> Bool{
        
        return FirebaseAuth.Auth.auth().currentUser != nil;
    }
    
    // Get facebook user data and send it to see if user exists or not
    func getUserFacebookData() {
        
        FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "email, first_name, last_name"]).start {
            (connection, result, error) in
            if error != nil {
                print ("loayError", error!)
            } else if let userData = result as? NSDictionary {
                print ("loayError", "here")
                let _ = userData["first_name"] as? String
            }
        }
    }
    
    private func saveUserToDatabase(uid: String, email: String, name: String) {
    
        let userData = ["email": email, "name": name]
        Dataservice.instance.createFirebasePassenger(uid: uid, userData: userData)
    }
    
    func startSpinner() {
        
        self.spinner.isHidden = false
        self.spinner.startAnimating()
    }
    
    func enableAll() {
        
        self.spinner.stopAnimating()
        self.emailField.isEnabled = true
        self.passwordField.isEnabled = true
        self.emailLoginButton.isEnabled = true
        self.facebookButton.isEnabled = true
        self.forgotPasswordButton.isEnabled = true
    }
    
    func disableAll() {
        
        self.startSpinner()
        self.emailField.isEnabled = false
        self.passwordField.isEnabled = false
        self.emailLoginButton.isEnabled = false
        self.facebookButton.isEnabled = false
        self.forgotPasswordButton.isEnabled = false
    }
    
}// End Class

// Extensions

extension LoginViewController {
    
    // Done/Next button in keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let nextTag = (self.view.firstResponder()?.tag)! + 1
        // Try to find next responder
        let nextResponder = textField.superview?.viewWithTag(nextTag)
        
        if nextResponder != nil {
            
            // Found next responder, so set it
            nextResponder!.becomeFirstResponder()
        } else {
            
            textField.resignFirstResponder()
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: 0.95, animations: {
                self.constraintLine.constant = self.tempBottomConstraintConstant
                self.view.layoutIfNeeded()
            })
        }
        
        return true
    }
}
