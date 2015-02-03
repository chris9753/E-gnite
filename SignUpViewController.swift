//
//  SignUpViewController.swift
//  E-gnite
//
//  Created by Chris Da silva on 2015-01-27.
//  Copyright (c) 2015 Chris Da silva. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    var userGender = ""
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var theWay: UILabel!
    var womanIsSelected : Bool = false
    var manIsSelected : Bool = false
    @IBOutlet weak var man: UIButton!
    @IBOutlet weak var woman: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var FBSession = PFFacebookUtils.session()
        
        var accessToken = FBSession.accessTokenData.accessToken
        let url = NSURL(string: "https://graph.facebook.com/me/picture?type=large&return_ssl&access_token=\(accessToken)")
        
        let urlRequest =  NSURLRequest(URL: url!)
        
        var user = PFUser.currentUser()
        
        
        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue.mainQueue(), completionHandler: {
            response,data,error in
           
           let image = UIImage(data: data)
            
            self.profilePic.image = image
            
            user["Image"] = data
            user.save()
            
            //Gender
            FBRequestConnection.startForMeWithCompletionHandler({
                connection,result,error in
                user["gender"] = result["gender"]
                user["name"] = result["name"]
                user.save()
                self.userGender = result["gender"] as String
            })
        })
        
    }
    
    
    
    @IBAction func signUp(sender: AnyObject) {
        
    }

    
    
    @IBAction func womanSelected(sender: AnyObject) {
       
        
       let womanImage = UIImage(named: "womanselected.png")
        let womanDefault = UIImage(named: "woman.png")
        var user = PFUser.currentUser()
        if !womanIsSelected {
            woman.setImage(womanImage, forState: .Normal)
        womanIsSelected = true
            user["interestedInWomen"] = true
        } else {
            woman.setImage(womanDefault, forState: .Normal)
            womanIsSelected = false
            user["interestedInWomen"] = false
        }
        user.save()
        stateCheck(userGender)
    }
    
    
    
    func stateCheck(gender: String) {
        switch gender {
        case "male" :
        
        if womanIsSelected {
            theWay.text = " By the Book"
        }
       if manIsSelected {
            theWay.text = "You Rebel"
        }
        if womanIsSelected && manIsSelected {
            theWay.text = "Both ways"
        }
        default :
            if womanIsSelected {
                theWay.text = " You Rebel"
            }
            if manIsSelected {
                theWay.text = "By the Book"
            }
            if womanIsSelected && manIsSelected {
                theWay.text = "Both ways"
            }
        }

    }
    
    
    
    @IBAction func manSelcted(sender: AnyObject) {
        let manImage = UIImage(named: "menselected.png")
         let manDefault = UIImage(named: "men.png")
        var user = PFUser.currentUser()
        if !manIsSelected {
            man.setImage(manImage, forState: .Normal)
            manIsSelected = true
            user["interestedInMen"] = true
        } else {
            man.setImage(manDefault, forState: .Normal)
            manIsSelected = false
            user["interestedInMen"] = false
        }
        user.save()
        stateCheck(userGender)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
