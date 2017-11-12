//
//  SplashViewController.swift
//  Private Concert
//
//  Created by Spoorthy Vemula on 11/10/17.
//  Copyright © 2017 Spoorthy Vemula. All rights reserved.
//

import UIKit
import Firebase

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let email = UserDefaults.standard.string(forKey: "Email") {
            if let pass = UserDefaults.standard.string(forKey: "Pass") {
                Auth.auth().signIn(withEmail: email, password: pass, completion: {(user, error) in
                    if (error == nil) {
                        self.performSegue(withIdentifier: "toListenVC", sender: self)
                    } else {
                        self.performSegue(withIdentifier: "toLoginVC", sender: self)
                        print(error.debugDescription)
                    }
                })
            } else {
                self.performSegue(withIdentifier: "toLoginVC", sender: self)
            }
        } else {
            self.performSegue(withIdentifier: "toLoginVC", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.destination is MasterViewController) {
            Global.userEmail = UserDefaults.standard.string(forKey: "Email")!
        }
    }
}
