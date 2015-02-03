//
//  ViewController.swift
//  E-gnite
//
//  Created by Chris Da silva on 2015-01-24.
//  Copyright (c) 2015 Chris Da silva. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

   
    @IBAction func login(sender:AnyObject) {
        self.label.alpha = 0
        var permissions = ["public_profile"]
        
        PFFacebookUtils.logInWithPermissions(permissions, {
            (user: PFUser!, error: NSError!) -> Void in
            if user == nil {
               self.label.alpha = 1
            } else if user.isNew {
              
                self.performSegueWithIdentifier("signUp", sender: self)
                
            } else {
                NSLog("User logged in through Facebook!")
            }
        })
        
        
        
    }
    @IBOutlet weak var label: UILabel!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var logo: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //Check User State
        if PFUser.currentUser() != nil {
            println("The user is logged in")
        }
        
        
        //Visuals
//        let blurEffect: UIBlurEffect = UIBlurEffect(style: .Light)
//        
//        let blurView: UIVisualEffectView = UIVisualEffectView(effect: blurEffect)
//        blurView.setTranslatesAutoresizingMaskIntoConstraints(false)
//        self.view.insertSubview(blurView, atIndex: 0)
//        
        
        
//        let vibrancyView: UIVisualEffectView = UIVisualEffectView(effect: UIVibrancyEffect(forBlurEffect: blurEffect))
//        vibrancyView.setTranslatesAutoresizingMaskIntoConstraints(false)
//                vibrancyView.contentView.insertSubview(logo, atIndex: 1)
//                vibrancyView.contentView.insertSubview(loginButton, atIndex: 1)
//       
//       
//        blurView.contentView.addSubview(vibrancyView)


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

