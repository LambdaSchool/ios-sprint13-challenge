//
//  SignInViewController.swift
//  MyExperiences
//
//  Created by Kelson Hartle on 7/10/20.
//  Copyright © 2020 Kelson Hartle. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class SignInViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.delegate = self
        
        setUpSignInButton()
    }
    
    @IBAction func googleSignIn(_ sender: Any) {
        GIDSignIn.sharedInstance()?.signIn()
    }
}

extension SignInViewController: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if let error = error {
            print("Error signing in with Google: \(error)")
            return
        }
        
        guard let authentication = user.authentication else { return }
        
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                print("Error signing in with Google: \(error)")
                return
            }
            
            DispatchQueue.main.async {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let postsNavigationController = storyboard.instantiateViewController(withIdentifier: "InitialVC")
                postsNavigationController.modalPresentationStyle = .fullScreen
                self.present(postsNavigationController, animated: false, completion: nil)
            }
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print("User disconnected")
    }
    
    func setUpSignInButton() {
        
        let button = GIDSignInButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(button)
        
        
        let buttonCenterXConstraint = button.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let buttonCenterYConstraint = button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        let buttonWidthConstraint = button.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5)
        
        view.addConstraints([buttonCenterXConstraint,
                             buttonCenterYConstraint,
                             buttonWidthConstraint])
    }
}
