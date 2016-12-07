//
//  ViewController.swift
//  devslopes-social
//
//  Created by Mary Béds on 06/12/16.
//  Copyright © 2016 Maria Eugênia Teixeira. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase

class SignInVC: UIViewController {
    
    
    @IBOutlet weak var emailField: FancyField!
    @IBOutlet weak var passwordField: FancyField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func facebookBtnTapped(_ sender: Any) {
        
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print("MB: Unable to authenticate with Facebook - \(error)")
                
            } else if result?.isCancelled == true {
                print("MB: User cancelled Facebook authentication")
                
            } else {
                print("MB: Successfully authenticated with Facebook")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
            
        }
        
    }
    
    func firebaseAuth(_ credential: FIRAuthCredential) {
        
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("MB: Unable to authenticate with Firebase - \(error)")
                
            } else {
                print("MB: Successfully authenticate with Firebase")
            }
            
        })
    }
    
    @IBAction func signInTapped(_ sender: Any) {
        
        if let email = emailField.text, let pwd = passwordField.text {
            
            FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: { (user, error) in
                if error == nil {
                    print("MB: Email user authenticated with FIrebase")
                    
                } else {
                    FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: { (user, error) in
                        if error != nil {
                            print("MC: Unable to authenticate with Firebase using email")
                            
                        } else {
                            print("MB: Successfully authenticated with Firebase")
                        }
                        
                    })
                }
                
            })
        }
    }
    

}

