//
//  RegisterViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let newAppearance = navigationController?.navigationBar.scrollEdgeAppearance?.copy()
        newAppearance?.backgroundColor = UIColor(named: "BrandLightBlue")
        navigationController?.navigationBar.scrollEdgeAppearance = newAppearance
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let newAppearance = navigationController?.navigationBar.scrollEdgeAppearance?.copy()
        newAppearance?.backgroundColor = UIColor(named: "BrandBlue")
        navigationController?.navigationBar.scrollEdgeAppearance = newAppearance
    }
    
    @IBAction func registerPressed(_ sender: UIButton) {
        guard let email = emailTextfield.text else {return}
        guard let password = passwordTextfield.text else {return}
        print("email: \(email), password: \(password)")
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let strongSelf = self else { return }
            if error != nil {
                print("Error: \(error!.localizedDescription)")
            } else {
                strongSelf.performSegue(withIdentifier: K.registerSegue, sender: self)
            }
        }
    }
    
}
