//
//  SplashViewController.swift
//  Private Concert
//
//  Created by Spoorthy Vemula on 11/10/17.
//  Copyright © 2017 Spoorthy Vemula. All rights reserved.
//

import UIKit
import FirebaseAuth

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if let email = UserDefaults.standard.string(forKey: "Email") {
            if let pass = UserDefaults.standard.string(forKey: "Pass") {
                Auth.auth().signIn(withEmail: email, password: pass, completion: {(user, error) in
                    self.performSegue(withIdentifier: "toListenVC", sender: self)
                })
            }
        }
        self.performSegue(withIdentifier: "toLoginVC", sender: self)
        // Do any additional setup after loading the view.
    }

}
