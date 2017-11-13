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
                
        // corner radius
        containerView.subviews[0].layer.cornerRadius = 10
        //containerView.subviews.clipsToBounds = true
        
        // shadow
        
        containerView.subviews[0].layer.shadowColor = UIColor.black.cgColor
        containerView.subviews[0].layer.shadowOffset = CGSize(width: 3, height: 3)
        containerView.subviews[0].layer.shadowOpacity = 0.7
        containerView.subviews[0].layer.shadowRadius = 10
        
        for item in tabbar.items! {
            item.image = item.image?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        }
        
        containerView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 14)
        containerView.dropShadow(color: UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.57), offSet: CGSize(width: 0, height: 0), radius: 4, scale: true)
    }
    
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch item.tag {
            case 0:
                let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "ListenVC")
                newViewController!.view.translatesAutoresizingMaskIntoConstraints = false
                self.cycleFromViewController(oldViewController: self.currentViewController!, toViewController: newViewController!)
                self.currentViewController = newViewController
            case 2:
                let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "RecordVC")
                newViewController!.view.translatesAutoresizingMaskIntoConstraints = false
                self.cycleFromViewController(oldViewController: self.currentViewController!, toViewController: newViewController!)
                self.currentViewController = newViewController
            case 3:
                let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "UserVC")
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

extension UIView {

    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
        self.layer.masksToBounds = true
    }

    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offSet
        self.layer.shadowRadius = radius

        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}

