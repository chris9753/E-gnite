//
//  Settings.swift
//  E-gnite
//
//  Created by Chris Da silva on 2015-02-03.
//  Copyright (c) 2015 Chris Da silva. All rights reserved.
//



import UIKit



/*  NSUSERDEFAULTS to display local settings
in ViewDid Load


You should only use parse to update settings (if user changes them)
to limit the amount of requests.


*/


class Settings: UIViewController {

    
    var userDistance:Int? = NSUserDefaults.standardUserDefaults().objectForKey("distance") as? Int
    var userAgeRange1: Int? = NSUserDefaults.standardUserDefaults().objectForKey("ageRange1") as Int?
    var userAgeRange2: Int? = NSUserDefaults.standardUserDefaults().objectForKey("ageRange2") as  Int?
    var userInterestWomen : Bool? = NSUserDefaults.standardUserDefaults().objectForKey("interestWomen") as? Bool
    var userInterestMen : Bool? = NSUserDefaults.standardUserDefaults().objectForKey("interestMen") as? Bool
    
    @IBOutlet weak var firstAge: UILabel!
    @IBOutlet weak var finalAge: UILabel!
    
    @IBOutlet weak var kmDistance: UILabel!
    @IBOutlet weak var men: UISwitch!
    @IBOutlet weak var women: UISwitch!
    @IBOutlet weak var sliderVal: UISlider!
    
    @IBAction func range(sender: UISlider) {
        var num = Int(sender.value)
        kmDistance.text = "\(num) KM"
        
        NSUserDefaults.standardUserDefaults().setObject(num, forKey: "distance")
    }
    
    @IBAction func save(sender: AnyObject) {
        //NSUSER DEFAULTS (MINIMIZES QUERIES FOR PERSISTENT SETTINGS)
            //Set Objects
        
        var user = PFUser.currentUser()
        
        user["distance"] = userDistance
        var num1 : Int
        var num2 : Int
      
        if userAgeRange1 == nil {
            num1 = 18
        } else {
            num1 = userAgeRange1!
        }
        if userAgeRange2 == nil {
            num2 = 24
        } else {
            num2 = userAgeRange2!
        }
        
        
        
        var arr = [num1,num2]
        user["range"] = arr
        
        if women.on {
            user["interestedInWomen"] = true
            NSUserDefaults.standardUserDefaults().setObject(user["interestedInWomen"], forKey: "interestWomen")
        } else {
            user["interestedInWomen"] = false
            NSUserDefaults.standardUserDefaults().setObject(user["interestedInWomen"], forKey: "interestWomen")
        }
        
        if men.on {
            user["interestedInMen"] = true
            NSUserDefaults.standardUserDefaults().setObject(user["interestedInMen"], forKey: "interestMen")
        } else {
            user["interestedInMen"] = false
            NSUserDefaults.standardUserDefaults().setObject(user["interestedInMen"], forKey: "interestMen")
        }
        user.saveInBackgroundWithBlock { (success : Bool, error : NSError!) -> Void in
            if success {
                
            }
        }

    }
    
    
    @IBAction func secondValue(sender: UISlider) {
        
        var num = Int(sender.value)
        finalAge.text = "\(num)"
        var numToSend = finalAge.text?.toInt()
           NSUserDefaults.standardUserDefaults().setObject(num, forKey: "ageRange1")
        
    }
    
    @IBAction func value(sender: UISlider) {
        var num = Int(sender.value)
        firstAge.text = "\(num)"
        var numToSend = firstAge.text?.toInt()
        
            NSUserDefaults.standardUserDefaults().setObject(num, forKey: "ageRange1")
        
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // This check would not be needed if the objects were set at sign up
        if userInterestMen != nil || userInterestWomen != nil  || userDistance != nil {
        if userInterestWomen == true {
            women.setOn(true, animated: true)
        } else {
            women.setOn(false, animated: true)
        }
        
        if userInterestMen == true  {
            men.setOn(true, animated: true)
        } else {
            men.setOn(false, animated: true)
        }
           var savedDistance : Int = userDistance!
            kmDistance.text = "\(savedDistance) KM"
            sliderVal.value = Float(savedDistance)
        } else {
            var user = PFUser.currentUser()
            //Parse save settings/First Settings load.
            if user["interestedInWomen"] as Bool {
                women.setOn(true, animated: true)
            } else {
                women.setOn(false, animated: true)
            }
            
            if user["interestedInMen"] as Bool {
                men.setOn(true, animated: true)
            } else {
                men.setOn(false, animated: true)
            }
            
            var savedDistance : Int = user["distance"] as Int
            kmDistance.text = "\(savedDistance) KM"
            sliderVal.value = Float(savedDistance)
            
            
            
            
        }
        
        
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
}
