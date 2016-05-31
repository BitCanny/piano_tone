//
//  SettingsController.swift
//  PianoTone
//
//  Created by luv mehta on 04/01/16.
//  Copyright © 2016 luv mehta. All rights reserved.
//

import UIKit

class SettingsController: UIViewController,NIDropDownDelegate,UITextFieldDelegate {
  
   
    @IBOutlet    var baseView: UIView?
    @IBOutlet    var pageButton: UIButton?
    @IBOutlet    var amplitudeButton: UIButton?
    
    @IBOutlet    var dropDown: NIDropDown?
    @IBOutlet    var dropDownAmplitude: NIDropDown?
   
      @IBOutlet    var bgScrollView: UIScrollView?
    var isChanged : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let defaults = NSUserDefaults.standardUserDefaults()
        let mode  = defaults.objectForKey("Mode") as! String
        let level = defaults.objectForKey("Level") as! String
       
        var  totalPage = defaults.integerForKey("totalPage")
        if totalPage <= 0 {
            totalPage = 1
        }
        
        
        
        let ampLevel : Double = defaults.doubleForKey("amplitudeLevel")
        if ampLevel == 0.008 {
            amplitudeButton?.setTitle("Silence", forState: .Normal)
        
        }
        else{
            amplitudeButton?.setTitle("Some Noise", forState: .Normal)
        }
        pageButton?.setTitle(String(format: "%d",totalPage), forState: .Normal)
        
        pageButton?.layer.masksToBounds = true
        pageButton?.layer.cornerRadius = 4.0
        pageButton?.layer.borderColor = UIColor.whiteColor().CGColor
        
        
       
        
        amplitudeButton?.layer.masksToBounds = true
        amplitudeButton?.layer.cornerRadius = 4.0
        amplitudeButton?.layer.borderColor = UIColor.whiteColor().CGColor
        
       
        
    }
    func niDropDownDelegateMethod(sender :NIDropDown )->Void {
        if sender == dropDown{
        let defaults = NSUserDefaults.standardUserDefaults()
        let totalpageStr = pageButton?.titleLabel?.text
        let myNSString = totalpageStr as! NSString
        let pageNo : Int = Int(myNSString.intValue)
        defaults.setInteger(pageNo, forKey: "totalPage")
        
        defaults.synchronize()
        if isChanged == false{
            NSNotificationCenter.defaultCenter().postNotificationName("removeFromUserDefault", object: nil)
            isChanged = true
        }

    self.rel()
        }
        else{
            let defaults = NSUserDefaults.standardUserDefaults()
            let ampLevelStr = amplitudeButton?.titleLabel?.text
            if ampLevelStr == "Silence"{
                defaults.setDouble(0.008, forKey: "amplitudeLevel")
            }
            else{
                defaults.setDouble(0.03, forKey: "amplitudeLevel")
            }
            defaults.synchronize()
            if isChanged == false{
                NSNotificationCenter.defaultCenter().postNotificationName("removeFromUserDefault", object: nil)
                isChanged = true
            }
            
            self.rel()
        }
    }
    
    func rel( )->Void {
    //    [dropDown release];
    dropDown = nil;
    dropDownAmplitude = nil
    }
    override func viewDidAppear(animated: Bool) {
       
//        baseView?.layer.masksToBounds = true
//        baseView?.layer.cornerRadius = 2.0
//        baseView?.layer.borderWidth = 1.0
//        baseView?.layer.borderColor = UIColor.whiteColor().CGColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func didPageClick(button: UIButton) {
        
        if(dropDown == nil) {
         
            var f : CGFloat = self.view.frame.size.height-((baseView?.frame.origin.y)!+button.frame.origin.y)
            
            
            dropDown = NIDropDown.init()
            let numArray : [NSString] = ["1", "2", "3","4", "5", "6","7", "8", "9","10"]
            var imgArray : [UIImage] = []
            for var i = 0; i < 10; ++i{
                
                imgArray.append(UIImage(named: "apple.png")!)
            }
            dropDown?.showDropDown(button, &f, numArray,imgArray, "down")
            
            dropDown!.delegate = self;
        }
        else {
            dropDown?.hideDropDown(button)
            
            var timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("removeDropDown"), userInfo: nil, repeats: false)

            
        }
    }
    @IBAction func didAmplitudeClick(button: UIButton) {
        
        if(dropDownAmplitude == nil) {
            var f : CGFloat = self.view.frame.size.height-((baseView?.frame.origin.y)!+button.frame.origin.y)
            
            
            dropDownAmplitude = NIDropDown.init()
            let numArray : [NSString] = ["Silence", "Some Noise"]
            var imgArray : [UIImage] = []
            for var i = 0; i < 2; ++i{
                
                imgArray.append(UIImage(named: "apple.png")!)
            }
            dropDownAmplitude?.showDropDown(button, &f, numArray,imgArray, "down")
            
            dropDownAmplitude!.delegate = self;
        }
        else {
            dropDownAmplitude?.hideDropDown(button)
            
            var timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("removeDropDown"), userInfo: nil, repeats: false)
            
            
        }
    }
    func removeDropDown() {
        dropDown = nil
        dropDownAmplitude = nil
        // Something after a delay
    }
       
 
   
    @IBAction func didBackClick(button: UIButton) {
        
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
        /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
