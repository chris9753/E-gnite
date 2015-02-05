//
//  TinderViewController.swift
//  E-gnite
//
//  Created by Chris Da silva on 2015-01-29.
//  Copyright (c) 2015 Chris Da silva. All rights reserved.
//

import UIKit

class TinderViewController: UIViewController {
    var i = 30
    var alphaX : CGFloat = 0
    var orgState : CGPoint = CGPoint()
    var  usernames = [String]()
    var userImages = [NSData]()
    var currentUser = 0
    @IBOutlet weak var frame: UIImageView!

    @IBOutlet weak var image: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
                //Getting Users Location
        PFGeoPoint.geoPointForCurrentLocationInBackground { (geopoint: PFGeoPoint!, error: NSError!) -> Void in
            
            if error == nil {
                var user = PFUser.currentUser()
                user["location"] = geopoint
                
                
                var query = PFUser.query()
                query.limit = 7
                if PFUser.currentUser()["interestedInMen"] as Bool  {
                    query.whereKey("gender", equalTo: "male")
                }
                if PFUser.currentUser()["interestedInWomen"] as Bool {
                    query.whereKey("gender", equalTo: "female")
                }
                query.whereKey("username", notEqualTo: PFUser.currentUser().username)
                query.whereKey("location", nearGeoPoint:geopoint)
                    switch PFUser.currentUser()["gender"] as String {
                    case "male":
                    query.whereKey("interestedInMen", equalTo: true)
                    default:
                        query.whereKey("interestedInWomen", equalTo: true)
                    }
                
                
                // Final list of objects
                query.findObjectsInBackgroundWithBlock({ (users, error) -> Void in
                for user in users {
                    self.usernames.append(user.username)
                    self.userImages.append(user["Image"] as NSData)
                    if users == nil {
                        println("no returned users from query")
                    }
                }
                
                    if  self.userImages.count != 0 {
                        self.addLabel(UIImage(data: self.userImages[0])!)
                    } else {
                        println("Wow, there is literally nobody ! Do you live on an Island?")
                    }

            })
                user.save()
            }
        }

        
    }
    func addLabel(imageData : UIImage) {
        //Adding the Image
        //var userImage: UIImageView = UIImageView(frame: CGRectMake(0, 0, self.view.frame.width,self.view.frame.height))
       image.contentMode = .ScaleAspectFit
        image.image = imageData
        orgState = image.center
        image.addSubview(frame)
        //self.view.insertSubview(image, atIndex: 0)
        
        //Attaching Gesture Recognition to Image
        var gesture = UIPanGestureRecognizer(target: self, action: Selector("wasDragged:"))
        image.addGestureRecognizer(gesture)
        
        
        image.userInteractionEnabled = true
       
    }
    
    
    func wasDragged(gesture : UIPanGestureRecognizer){
        //Vector Translations
        let translation = gesture.translationInView(self.view)
        alphaX += (translation.x * 3.14/180)
        var image = gesture.view!
        image.center = CGPoint(x: image.center.x + translation.x, y: image.center.y + translation.y)
        gesture.setTranslation(CGPointZero, inView: self.view)
        
        //Transformations
        var transformVar = min(abs(2/* size/speed factor decimal *//alphaX ),1)
        var rotation:CGAffineTransform = CGAffineTransformMakeRotation(alphaX/9)
        var scale: CGAffineTransform = CGAffineTransformScale(rotation, transformVar,transformVar)
        image.transform = scale
        gesture.view!.alpha = 1-(min(abs(alphaX/10),1))
        
        //StateCheck
        
        if gesture.state==UIGestureRecognizerState.Ended {
            
            if image.center.x < 100 {
                
                PFUser.currentUser().addUniqueObjectsFromArray([usernames[currentUser]], forKey:"Accepted")
                PFUser.currentUser().save()
                self.currentUser++
                
                println("Chosen")
                //refresh view/change image
                image.removeFromSuperview()
                
                if self.currentUser < userImages.count {
                    addLabel(UIImage(data: userImages[self.currentUser])!)
                } else {
                    println("Oops No more users!")
                }
              
                
                alphaX = 0
                
            } else if image.center.x > self.view.bounds.width - 90 {
                println("Not Chosen")
                PFUser.currentUser().addUniqueObjectsFromArray([usernames[currentUser]], forKey:"Rejected")
                PFUser.currentUser().save()
                 self.currentUser++
                //refresh view/change image
                image.removeFromSuperview()
                if self.currentUser < userImages.count {
                addLabel(UIImage(data: userImages[self.currentUser])!)
                } else {
                    println("Oops No more users!")
                }
                self.alphaX = 0
                
            } else {
                
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    
                    image.center = self.orgState
                    
                    image.transform = CGAffineTransformIdentity
                    self.alphaX = 0
                    
                })
                
            }
            
        }
    }
   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    

   
}
