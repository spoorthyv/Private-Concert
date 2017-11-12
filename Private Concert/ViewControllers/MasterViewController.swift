//
//  TabBarController.swift
//  Private Concert
//
//  Created by Spoorthy Vemula on 11/10/17.
//  Copyright © 2017 Spoorthy Vemula. All rights reserved.
//

import UIKit

struct Global {
    static var userEmail = ""
}

class MasterViewController: UIViewController, UITabBarDelegate {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var tabbar: UITabBar!
    weak var currentViewController: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.currentViewController = self.storyboard?.instantiateViewController(withIdentifier: "ListenVC")
        self.currentViewController!.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChildViewController(self.currentViewController!)
        self.addSubview(subView: self.currentViewController!.view, toView: self.containerView)
        tabbar.selectedItem = tabbar.items![0]
        
        //tabbar.tintColor = UIColor.white
        
        for item in tabbar.items! {
            item.image = item.image?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        }
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch item.tag {
            case 0:
                let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "ListenVC")
                newViewController!.view.translatesAutoresizingMaskIntoConstraints = false
                self.cycleFromViewController(oldViewController: self.currentViewController!, toViewController: newViewController!)
                self.currentViewController = newViewController
            case 1:
                let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "RecordVC")
                newViewController!.view.translatesAutoresizingMaskIntoConstraints = false
                self.cycleFromViewController(oldViewController: self.currentViewController!, toViewController: newViewController!)
                self.currentViewController = newViewController
            default:
                print("default")
            break
            
        }
    }
    
    func cycleFromViewController(oldViewController: UIViewController, toViewController newViewController: UIViewController) {
        oldViewController.willMove(toParentViewController: nil)
        self.addChildViewController(newViewController)
        self.addSubview(subView: newViewController.view, toView:self.containerView!)
        // TODO: Set the starting state of your constraints here
        newViewController.view.layoutIfNeeded()
        
        // TODO: Set the ending state of your constraints here
        
        UIView.animate(
            withDuration: 0.5,
            animations: { newViewController.view.layoutIfNeeded() },
            completion: {
                finished in
                oldViewController.view.removeFromSuperview()
                oldViewController.removeFromParentViewController()
                newViewController.didMove(toParentViewController: self)
            }
        )
    }
    
    func addSubview(subView:UIView, toView parentView:UIView) {
        parentView.addSubview(subView)
        
        var viewBindingsDict = [String: AnyObject]()
        viewBindingsDict["subView"] = subView
        parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[subView]|", options: [], metrics: nil, views: viewBindingsDict))
        parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[subView]|", options: [], metrics: nil, views: viewBindingsDict))
    }
    
}
