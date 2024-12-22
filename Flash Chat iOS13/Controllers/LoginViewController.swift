//
//  LoginViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func loginPressed(_ sender: UIButton) {
        guard let email = emailTextfield.text else {return}
        guard let password = passwordTextfield.text else {return}
        print("email: \(email), password: \(password)")
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let strongSelf = self else { return }
            if error != nil {
                print("Error: \(error!.localizedDescription)")
            } else {
                strongSelf.performSegue(withIdentifier: K.loginSegue, sender: self)
            }
        }
    }
    
}
