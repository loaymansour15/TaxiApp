//
//  ContainerViewController.swift
//  TaxiApp
//
//  Created by Loay on 6/18/19.
//  Copyright © 2019 Loay Productions. All rights reserved.
//

import UIKit
import QuartzCore
import FBSDKLoginKit
import FirebaseAuth
import RevealingSplashView

class ContainerViewController: UIViewController {

// Varaibles
    
    var leftVC: LeftSidePanelViewController!
    var loginVC: LoginViewController!
    var langAndPermVC: LangAndPermissionsViewController!
    var homeVC: HomeViewController!
    var autoCompleteVC: AutoCompleteSearchViewController!
    var visaPaymentVC: VisaPaymentViewController!
    
    var centerController: UIViewController!
    var currentState: SlideOutState = .collapsed {
        
        didSet {
            let shouldShow = (currentState != .collapsed)
            shouldShowShadowForCenterViewController(status: shouldShow)
        }
    }
    
    var showVC: ShowWhichVC = .loginVC
    
    var isHidden = false
    let centerPanelOffset: CGFloat = 90
    
    var isLaunchScreenLoaded = false
    
    var tap: UITapGestureRecognizer!
    
    var animation = UIView.AnimationOptions.transitionFlipFromBottom
    
    let revealingSplashView = RevealingSplashView(iconImage: UIImage(named: "launchScreenIcon")!,iconInitialSize: CGSize(width: 80, height: 80), backgroundColor: UIColor.white)
    
// Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Start splash view
        splashViewThenOpen()
    }
    
    func checkIfUserSignedIn() {
        
        if FBSDKAccessToken.current() != nil || FirebaseAuth.Auth.auth().currentUser != nil {
            
            initCenter(screen: .homeVC)
        }else{
            
            initCenter(screen: showVC)
        }
    }
    
    func loadThisScreen(screen: ShowWhichVC) {
        
        initCenter(screen: screen)
    }
    
    func loadThisScreenWithTransition(screen: ShowWhichVC, transition: UIView.AnimationOptions) {
        
        animation = transition
        initCenter(screen: screen)
    }
    
    private func initCenter(screen: ShowWhichVC) {
        
        var presentingController: UIViewController!
        
        showVC = screen
        presentingController = getNextViewController(screen: showVC)
        let tempController: UIViewController!
        
        tempController = centerController
        
        UIView.transition(with: self.view, duration: 0.5, options: [animation], animations: {
            
            self.centerController = presentingController
            self.view.addSubview(self.centerController.view)
            self.addChild(self.centerController)
            self.centerController.didMove(toParent: self)
        }, completion: nil)
        
        if let temp = tempController{
            
            temp.view.removeFromSuperview()
            temp.removeFromParent()
        }
        
    }
    
    private func getNextViewController(screen: ShowWhichVC) -> UIViewController{
        
        var result: UIViewController?
        
        if showVC == .homeVC {
            
            self.homeVC = UIStoryboard.homeViewController()
            self.homeVC.delegate = self
            result = self.homeVC!
            
        } else if showVC == .loginVC {
            
            self.loginVC = UIStoryboard.loginViewController()
            result = self.loginVC!
            
        } else if showVC == .langAndPermVC {
            
            self.langAndPermVC = UIStoryboard.langAndPermViewController()
            result = self.langAndPermVC!
            
        } else if showVC == .visaPaymentVC {
            
            self.visaPaymentVC = UIStoryboard.visaPaymentViewController()
            result = self.visaPaymentVC!
        }
        
        return result!
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation{
        
        return UIStatusBarAnimation.slide
    }
    
    override var prefersStatusBarHidden: Bool {
        
        return isHidden
    }
    
    private func splashViewThenOpen(){
        
        //Adds the revealing splash view as a sub view
        self.view.addSubview(revealingSplashView)
        
        revealingSplashView.animationType = SplashAnimationType.popAndZoomOut
        self.revealingSplashView.startAnimation()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.55) {
            
            self.checkIfUserSignedIn()
        }
    }
    
    func getHomeViewController() -> HomeViewController {
        
        return homeVC
    }

}// End Class

// Enums

enum SlideOutState {
    
    case collapsed
    case leftPanelExpanded
}

enum ShowWhichVC {
    
    case loginVC
    case langAndPermVC
    case homeVC
    case autoCompleteVC
    case visaPaymentVC
}

// Extensions

private extension UIStoryboard {
    
    class func mainStoryboard() -> UIStoryboard{
        
        return UIStoryboard(name: "Main", bundle: Bundle.main)
    }
    
    class func leftViewController() -> LeftSidePanelViewController? {
        
        return mainStoryboard().instantiateViewController(withIdentifier: "LeftSidePanelVC") as? LeftSidePanelViewController
    }
    
    class func loginViewController() -> LoginViewController? {
        
        return mainStoryboard().instantiateViewController(withIdentifier: "LoginVC") as? LoginViewController
    }
    
    class func langAndPermViewController() -> LangAndPermissionsViewController? {
        
        return mainStoryboard().instantiateViewController(withIdentifier: "LangAndPerm") as? LangAndPermissionsViewController
    }
    
    class func homeViewController() -> HomeViewController? {
        
        return mainStoryboard().instantiateViewController(withIdentifier: "HomeVC") as? HomeViewController
    }
    
    class func autoCompleteSearchViewController() -> AutoCompleteSearchViewController? {
        
        return mainStoryboard().instantiateViewController(withIdentifier: "autoSearchVC") as? AutoCompleteSearchViewController
    }
    
    class func visaPaymentViewController() -> VisaPaymentViewController? {
        
        return mainStoryboard().instantiateViewController(withIdentifier: "visaPaymentVC") as? VisaPaymentViewController
    }
    
}// End Extension

extension ContainerViewController: CenterViewControllerDelegate {
    
    func toogleLeftPanel() {
        
        let notAlreadyExpanded = (currentState != .leftPanelExpanded)
        
        if notAlreadyExpanded {
            
            addLeftPanelViewController()
        }
        animateLeftPanel(shouldExpand: notAlreadyExpanded)
    }
    
    func removeLeftSidePaneFromParentView() {
        
        if self.leftVC != nil {
            
            self.leftVC.view.removeFromSuperview()
            self.leftVC.removeFromParent()
            self.leftVC = nil
        }
    }
    
    internal func addLeftPanelViewController() {
        
        if leftVC == nil {
            
            leftVC = UIStoryboard.leftViewController()
            addChildSidePanelViewController(leftVC!)
        }
    }
    
    @objc internal func animateLeftPanel(shouldExpand: Bool) {
        
        isHidden = !isHidden
        animateStatusBar()
        
        if shouldExpand {
            
            self.setUpWhiteCoverView()
            self.currentState = .leftPanelExpanded
            self.animateCenterPanelPosition(targetPos: centerController.view.frame.width - centerPanelOffset)
        } else {
            
            self.hideWhiteCoverView()
            animateCenterPanelPosition(targetPos: 0, completion: {( finished) in
                self.currentState = .collapsed
                self.animateCenterPanelOut()
            })
        }
    }
    
    private func addChildSidePanelViewController(_ sidePanelController: LeftSidePanelViewController) {
        
        view.insertSubview(sidePanelController.view, at: 0)
        addChild(sidePanelController)
        sidePanelController.didMove(toParent: self)
    }
    
    private func animateCenterPanelPosition(targetPos: CGFloat, completion: ((Bool) -> Void)! = nil) {
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.centerController.view.frame.origin.x = targetPos
        }, completion: completion)
    }
    
    private func animateCenterPanelOut() {
        
        UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.centerController.view.frame.origin.x = 0
        }, completion: nil)
    }
    
    private func animateStatusBar() {
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.setNeedsStatusBarAppearanceUpdate()
        })
    }
    
    private func shouldShowShadowForCenterViewController(status: Bool) {
        
        if status {
            
            centerController.view.layer.shadowOpacity = 0.6
        } else {
            
            centerController.view.layer.shadowOpacity = 0.0
        }
    }
    
    private func setUpWhiteCoverView() {
        
        let whiteCoverView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        whiteCoverView.alpha = 0.0
        whiteCoverView.backgroundColor = UIColor.black
        whiteCoverView.tag = 25
        
        self.centerController.view.addSubview(whiteCoverView)
        UIView.animate(withDuration: 0.2, animations: {
            whiteCoverView.alpha = 0.50
        })
        
        tap = UITapGestureRecognizer(target: self, action: #selector(animateLeftPanel(shouldExpand:)))
        tap.numberOfTapsRequired = 1
        self.centerController.view.addGestureRecognizer(tap)
    }
    
    private func hideWhiteCoverView() {
        centerController.view.removeGestureRecognizer(tap)
        for subView in self.centerController.view.subviews {
            
            if subView.tag == 25 {
                
                UIView.animate(withDuration: 0.2, animations: {
                    subView.alpha = 0.0
                }, completion: {(finished) in
                    subView.removeFromSuperview()
                })
            }
        }
    }
}// End Extension


