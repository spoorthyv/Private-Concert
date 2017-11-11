//
//  LoginViewController.swift
//  Private Concert
//
//  Created by Spoorthy Vemula on 11/7/17.
//  Copyright © 2017 Spoorthy Vemula. All rights reserved.
//

import UIKit
import FirebaseAuth
import Foundation

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPassTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerUnderline: UIView!
    @IBOutlet weak var signInUnderline: UIView!
    
    @IBOutlet weak var userIcon: UIImageView!
    @IBOutlet weak var passIcon: UIImageView!
    @IBOutlet weak var confirmPassIcon: UIImageView!
    
    @IBOutlet weak var loginButtonTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var confirmPassTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var confirmPassTopMargin: NSLayoutConstraint!
    
    var isRegister = true
    var confirmPassTotalHeight: CGFloat?
    
    var validEmail = false
    var validPassword = false
    var validConfirmPassword = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        confirmPassTotalHeight = confirmPassTopConstraint.constant + confirmPassTopMargin.constant
        signInUnderline.isHidden = true
//        NotificationCenter.default.addObserver(self, selector: Selector(("keyboardWillShow")), name:NSNotification.Name.UIKeyboardWillShow, object: self.view.window)
//        NotificationCenter.default.addObserver(self, selector: Selector(("keyboardWillHide")), name:NSNotification.Name.UIKeyboardWillHide, object: self.view.window)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func registerClicked(_ sender: UIButton) {
        if (!isRegister) {
            confirmPassTextField.isHidden = false
            confirmPassIcon.isHidden = false
            loginButton.setTitle("Register", for: .normal)
            isRegister = true
            registerUnderline.isHidden = false
            signInUnderline.isHidden = true
            
            loginButtonTopConstraint.constant = loginButtonTopConstraint.constant + confirmPassTotalHeight!
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
            })
            
            registerButton.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: (registerButton.titleLabel?.font.pointSize)!)
            signInButton.titleLabel?.font = UIFont(name: "Avenir-Roman", size: (registerButton.titleLabel?.font.pointSize)!)
            
            setLoginButton()
        }
    }
    
    @IBAction func signInClicked(_ sender: UIButton) {
        if(isRegister) {
            confirmPassTextField.isHidden = true
            confirmPassIcon.isHidden = true
            loginButton.setTitle("Login", for: .normal)
            isRegister = false
            registerUnderline.isHidden = true
            signInUnderline.isHidden = false
            
            loginButtonTopConstraint.constant = loginButtonTopConstraint.constant - confirmPassTotalHeight!
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
            })
            
            registerButton.titleLabel?.font = UIFont(name: "Avenir-Roman", size: (registerButton.titleLabel?.font.pointSize)!)
            signInButton.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: (registerButton.titleLabel?.font.pointSize)!)
            
            setLoginButton()
        }
    }
    
    
    @IBAction func emailChanged(_ sender: UITextField) {
        validEmail = isValidEmailAddress(emailAddressString: emailTextField.text!)
        setLoginButton()
    }
    @IBAction func passwordChanged(_ sender: UITextField) {
        validPassword = checkPassword(password: passwordTextField.text!)
        setLoginButton()
    }
    @IBAction func confirmPassChanged(_ sender: UITextField) {
        validConfirmPassword = (confirmPassTextField.text == passwordTextField.text)
        setLoginButton()
    }
    
    func setLoginButton() {
        if (isRegister) {
            if (validEmail && validPassword && validConfirmPassword) {
                setLoginButton(canLogin: true)
            } else {
                setLoginButton(canLogin: false)
            }
        } else {
            if (validEmail && validPassword) {
                setLoginButton(canLogin: true)
            } else {
                setLoginButton(canLogin: false)
            }
        }
    }
    
    func setLoginButton(canLogin: Bool) {
        if (canLogin) {
            loginButton.isEnabled = true
            loginButton.backgroundColor = UIColor.white
        } else {
            loginButton.isEnabled = false
            loginButton.backgroundColor = UIColor(displayP3Red: 183/255, green: 148/255, blue: 29/255, alpha: 1)
        }
    }
    
    func checkPassword(password: String) -> Bool {
        if (password.count > 8) {
            return true
        } else {
            return false
        }
    }
    
    func isValidEmailAddress(emailAddressString: String) -> Bool {
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = emailAddressString as NSString
            let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0
            {
                returnValue = false
            }
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        
        return  returnValue
    }

    func displayAlertMessage(messageToDisplay: String) {
        let alertController = UIAlertController(title: "Alert", message: messageToDisplay, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            print("Ok button tapped");
        }
        
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion:nil)
    }
    
    @IBAction func loginClicked(_ sender: UIButton) {
        if (isRegister) {
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: {(user, error) in
                if (user != nil) {
                    UserDefaults.standard.set(self.emailTextField.text!, forKey: "Email")
                    UserDefaults.standard.set(self.passwordTextField.text!, forKey: "Pass")
                    
                    self.performSegue(withIdentifier: "enterApp", sender: self)
                }
            })
        } else {
            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: {(user, error) in
                if (user != nil) {
                    UserDefaults.standard.set(self.emailTextField.text!, forKey: "Email")
                    UserDefaults.standard.set(self.passwordTextField.text!, forKey: "Pass")
                    
                    self.performSegue(withIdentifier: "enterApp", sender: self)
                }
            })
        }
    }
    
    func enterApp() {
        
    }
    

    
    @objc func keyboardWillShow(sender: NSNotification) {
        //let userInfo: [NSObject : AnyObject] = sender.userInfo! as [NSObject : AnyObject]
        let keyboardSize: CGSize = ((sender.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size)!
        let offset: CGSize = ((sender.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size)!
        
        if keyboardSize.height == offset.height {
            UIView.animate(withDuration: 0.1, animations: { () -> Void in
                self.view.frame.origin.y -= keyboardSize.height
            })
        } else {
            UIView.animate(withDuration: 0.1, animations: { () -> Void in
                self.view.frame.origin.y += keyboardSize.height - offset.height
            })
        }
    }
    @objc func keyboardWillHide(sender: NSNotification) {
        //let userInfo: [NSObject : AnyObject] = sender.userInfo!
        let keyboardSize: CGSize = ((sender.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size)!
        self.view.frame.origin.y += keyboardSize.height
    }
    
//    @objc func keyboardWillShow(notification: NSNotification) {
//        print("keyboard")
//        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//            if self.view.frame.origin.y == 0{
//                self.view.frame.origin.y -= keyboardSize.height
//            }
//        }
//    }
//    @objc func keyboardWillHide(notification: NSNotification) {
//        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//            if self.view.frame.origin.y != 0{
//                self.view.frame.origin.y += keyboardSize.height
//            }
//        }
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
