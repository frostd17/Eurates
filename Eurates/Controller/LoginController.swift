//
//  LoginController.swift
//  Eurates
//
//  Created by Daniel Frost on 17/04/2018.
//  Copyright © 2018 Daniel Frost. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController {
    let INVALID_EMAIL = "The email address is badly formatted"
    let NO_USER = "There is no user record corresponding to this identifier"
    let INVALID_PASSWORD = "The password is invalid"
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isToolbarHidden = true;
        ViewController.setButton(button: loginButton, radius: 5.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        ProgressHUD.show()
        
        if emailField.text!.count == 0 || passwordField.text!.count == 0 {
            ProgressHUD.showError("Missing Email/Password")
            return
        }
        
        Auth.auth().signIn(withEmail: emailField.text!, password: passwordField.text!) { (user, error) in
            if error != nil {
                if error?.localizedDescription.range(of: self.INVALID_EMAIL) != nil {
                    ProgressHUD.showError(self.INVALID_EMAIL)
                } else if error?.localizedDescription.range(of: self.NO_USER) != nil {
                    ProgressHUD.showError(self.NO_USER)
                } else if error?.localizedDescription.range(of: self.INVALID_PASSWORD) != nil {
                    ProgressHUD.showError(self.INVALID_PASSWORD)
                }
                print("❌ \(error!)")
                return
            } else {
                print("✅ Successful login for: " + (Auth.auth().currentUser?.email)!)
                self.performSegue(withIdentifier: "gotoRatesTV", sender: self)
            }
            ProgressHUD.dismiss()
        }
    }
}
