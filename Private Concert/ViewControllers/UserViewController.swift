//
//  UserViewController.swift
//  Private Concert
//
//  Created by Spoorthy Vemula on 11/12/17.
//  Copyright © 2017 Spoorthy Vemula. All rights reserved.
//

import UIKit
import Foundation
import Firebase

class UserViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logOut(_ sender: UIButton) {
        UserDefaults.standard.removeObject(forKey: "Email")
        UserDefaults.standard.removeObject(forKey: "Pass")
        UserDefaults.standard.synchronize()

        do {
            try Auth.auth().signOut()
        } catch {
            print("Failed Sign Out")
        }
        
        
        performSegue(withIdentifier: "logOut", sender: self)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
