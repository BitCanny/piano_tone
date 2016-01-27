//
//  ViewController.swift
//  PianoTone
//
//  Created by luv mehta on 25/11/15.
//  Copyright © 2015 luv mehta. All rights reserved.
//

import UIKit
import TuningFork
import BFPaperButton
import PermissionScope
import BubbleTransition
import PodsLicenseReader

class ViewController: UIViewController, UIViewControllerTransitioningDelegate, TunerDelegate {
    var delegate: AppDelegate?
     @IBOutlet    var mainDrawingView  : UIView?
     @IBOutlet    var timeLabel  : UILabel?
   @IBOutlet    var correctButton: UIButton?
    @IBOutlet    var wrongButton: UIButton?
    @IBOutlet    var generatedKeysLabel  : UILabel?
    @IBOutlet    var flashKeyLabel  : UILabel?
    @IBOutlet    var pressedKeysLabel  : UILabel?
     @IBOutlet    var durationGameLabel  : UILabel?
     @IBOutlet    var LevelGameLabel  : UILabel?
     @IBOutlet    var modeGameLabel  : UILabel?
     @IBOutlet    var correctKeyGameLabel  : UILabel?
     @IBOutlet    var wrongKeyGameLabel  : UILabel?
    @IBOutlet    var wrongKeyGameTextLabel  : UILabel?
    @IBOutlet    var finishBgView  : UIView?
    @IBOutlet    var finishGameView  : UIView?
    @IBOutlet    var startButton: UIButton?
   @IBOutlet    var resumeButton: UIButton?
    
    var result :NSString = ""
    var timer  :NSTimer?
    var toDB : Double = 0.01
    var timeForTimer : Double = 0.1
    
    var levelNo : Int = 0
    var diffFreqArray : [[Float]] = []
    var keyArray : [String] = ["C2","D2","E2","F2","A2","B2","C3","D3","E3","F3","A3","B3","C4","D4","E4","F4","A4","B4","C5","D5","E5","F5","A5","B5","C6"]
    var generatedKeyArray : [String] = []
    var PressedKeyArray : [String] = []
    var totalKeys : Int = 0
    var totalShowKeys : Int = 0
    var currentKeyNo : Int = -1
    var totalKeyCompleted : Int = 0
    var totalCorrect : Int = 0
    var totalWrong : Int = 0
    var timeH : Int  = 0
    var timeM : Int  = 0
    var timeS : Int  = 0
    var timeTaken : Int  = 0
    var indexOfSelectedKey : Int = -1
    var whichKey : Int = -1
    var totalPage : Int = 0
    var isFirstTime :Bool = true
    var isTestingMode : Bool = false
    var gameMode     : String = "Challenge"
    var gameLevel     : String = "Hard"
    var notePageArray : NSMutableArray = []
    private var running = false
    
    weak var hConstraint: NSLayoutConstraint!
    private let permissions = PermissionScope()
    private let transition = BubbleTransition()
    private var tuner: Tuner?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationController?.navigationBarHidden = true
        delegate?.mainViewController=self;
        tuner = Tuner()
        tuner?.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "saveData",
            name: "saveData",
            object: nil)
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "check",
            name: "check",
            object: nil)
        resumeButton?.enabled = false
       
       mainDrawingView?.hidden = true
        isFirstTime = true
        timeLabel?.text = "00 : 00"
        correctButton!.setTitle("0", forState: UIControlState.Normal)
        wrongButton!.setTitle("0", forState: UIControlState.Normal)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        totalPage = defaults.integerForKey("totalPage")
        if totalPage <= 0 {
            totalPage = 1
        }
        toDB = defaults.doubleForKey("amplitudeLevel")
        if toDB <= 0 {
            toDB = 0.02
        }
        
        timeForTimer = defaults.doubleForKey("timerTime")
        
        
        finishGameView?.layer.masksToBounds = true
        finishGameView?.layer.borderWidth = 2.0
        finishGameView?.layer.borderColor = UIColor.whiteColor().CGColor
        
        
     //   NSLog("Mode=%@,Level=%@", gameMode,gameLevel)
       if gameMode=="Training"{
        wrongButton?.hidden = true
        correctButton?.hidden = false
        
        }
     
        
       
    }
    override func viewDidAppear(animated: Bool) {
        timeLabel?.translatesAutoresizingMaskIntoConstraints = false
        var rect1 : CGRect = (timeLabel?.frame)!
        rect1.size.height = rect1.size.width
        timeLabel?.frame = rect1
//        timeLabel?.layer.masksToBounds = true
//        timeLabel?.layer.cornerRadius = (timeLabel?.frame.size.width)!/2
//        timeLabel?.layer.borderWidth = 1.0
//        timeLabel?.layer.borderColor = UIColor.whiteColor().CGColor
//        timeLabel?.setNeedsDisplay()
                mainDrawingView?.backgroundColor = UIColor.whiteColor()
        if isFirstTime == true{
            
            for var i = 1; i <= totalPage; ++i{
               let  pianoPage : lineView = lineView()
                pianoPage.frame = CGRectMake(CGFloat((i-1))*(self.view.frame.size.width), 0, (self.view.frame.size.width), (mainDrawingView?.frame.size.height)!)
                pianoPage.indexOfSelectedKey = indexOfSelectedKey
                pianoPage.whichKey = whichKey
                mainDrawingView?.addSubview(pianoPage)
                notePageArray.addObject(pianoPage)
                pianoPage.backgroundColor = UIColor.whiteColor()
            }
         
        mainDrawingView?.hidden = false
            
            UIView.animateWithDuration(0.05, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                let  pianoPage : lineView = self.notePageArray[self.levelNo-1] as! lineView
                var rectView : CGRect = (pianoPage.frame)
                rectView.origin.x = 0
                pianoPage.frame = rectView
                
                }, completion:  { finished in
                    let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64( Double(NSEC_PER_SEC) ))
                    dispatch_after(delayTime, dispatch_get_main_queue()){
                        self.startGame()
                        self.startButton?.enabled = false
                        self.resumeButton?.enabled = true
                    }
        
            
                })

            
            //  NSLog("LevelN0=%d", levelNo)
            isFirstTime = false
        drawUI()
          
        }
        
        
       
    }
    func pianoView()->lineView{
        return notePageArray[levelNo-1] as! lineView
        
    }
    func drawUI(){
        
    //    NSLog("LevelNo=%d", levelNo)
        
        let thisLineView : lineView = pianoView()
        if thisLineView.startKeyFromButtonNo == -1 {
         self.performSelector(Selector("drawUI"), withObject: nil, afterDelay: 0.1)
            
        }
        else{
        //thisLineView.drawRect(thisLineView.frame)
        thisLineView.indexOfSelectedKey = indexOfSelectedKey
        thisLineView.whichKey = whichKey
        thisLineView.drawKeysWithArray(generatedKeyArray)
            
        }
    }
    func check(){
        self.navigationController?.popViewControllerAnimated(true) 
}
    func removeDataFromUserDefault(){
        let defaults = NSUserDefaults.standardUserDefaults()
        
        defaults.setBool(false, forKey: "isCurrentGame")
        defaults.setInteger(0, forKey: "totalKeys")
        defaults.setInteger(0, forKey: "totalShowKeys")
        defaults.setInteger(0, forKey: "currentKeyNo")
        defaults.setInteger(0, forKey: "totalKeyCompleted")
        defaults.setInteger(0, forKey: "totalCorrect")
        defaults.setInteger(0, forKey: "totalWrong")
        defaults.setInteger(0, forKey: "timeS")
        defaults.setInteger(0, forKey: "timeM")
        defaults.setInteger(0, forKey: "timeH")
        defaults.removeObjectForKey("generatedKeyArray")
        defaults.removeObjectForKey("PressedKeyArray")
        defaults.synchronize()

    }
     func saveData(){
        let thisLineView : lineView = pianoView()
        if generatedKeyArray.count > 0 {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(true, forKey: "isCurrentGame")
        defaults.setInteger(totalKeys, forKey: "totalKeys")
        defaults.setInteger(totalShowKeys, forKey: "totalShowKeys")
        defaults.setInteger(currentKeyNo, forKey: "currentKeyNo")
        defaults.setInteger(totalKeyCompleted, forKey: "totalKeyCompleted")
        defaults.setInteger(totalCorrect, forKey: "totalCorrect")
        defaults.setInteger(totalWrong, forKey: "totalWrong")
        defaults.setInteger(timeS, forKey: "timeS")
        defaults.setInteger(timeM, forKey: "timeM")
        defaults.setInteger(timeH, forKey: "timeH")
        defaults.setInteger(levelNo, forKey: "levelNo")
        indexOfSelectedKey = (thisLineView.indexOfSelectedKey)
        indexOfSelectedKey -= thisLineView.diffrence
        whichKey = (thisLineView.whichKey)
        whichKey -= 1
       // NSLog("WhichKey=%d", whichKey)
        defaults.setInteger(indexOfSelectedKey, forKey: "indexOfSelectedKey")
        defaults.setInteger(whichKey, forKey: "whichKey")
        defaults.setObject(generatedKeyArray, forKey: "generatedKeyArray")
        defaults.setObject(PressedKeyArray, forKey: "PressedKeyArray")
        defaults.setObject(gameLevel, forKey: "LevelCurrent")
        defaults.setObject(gameMode, forKey: "ModeCurrent")
        defaults.synchronize()
        }
        self.stopTuner()
        timer?.invalidate()
        
    }
    func resumeGame(){
        
        self.stopTuner()
        timer?.invalidate()
        timer = nil
        
        UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            
            let thisLineView : lineView = self.pianoView()
            thisLineView.decreaseSelectedIndex()
            self.indexOfSelectedKey = (thisLineView.indexOfSelectedKey)
            self.whichKey = (thisLineView.whichKey)
            self.whichKey -= 1
            thisLineView.selectedKeyView.center = CGPointMake(-100, thisLineView.selectedKeyView.center.y)
            }, completion: nil)
        
        
        
    }
    func startGame(){
        
        let thisLineView : lineView = pianoView()
        if  indexOfSelectedKey <= -1{
            indexOfSelectedKey = 0
        }
          // NSLog("index =%d", indexOfSelectedKey)
            thisLineView.indexOfSelectedKey = indexOfSelectedKey
            thisLineView.whichKey = whichKey
            thisLineView.selectKey(self.generatedKeyArray[self.currentKeyNo])
            flashKeyLabel?.text = generatedKeyArray[currentKeyNo]
         
            dispatch_async(dispatch_get_main_queue()) {
            var minTime : String = String(format: "%d",self.timeM)
            var secTime : String = String(format: "%d",self.timeS)
            if self.timeM < 10{
                   minTime = String(format: "0%d",self.timeM)
                }
            if self.timeS < 10{
                    secTime = String(format: "0%d",self.timeS)
                }
            self.timeLabel?.text = String(format: "%@ : %@",minTime,secTime)
           
            self.generatedKeysLabel?.text = self.generatedKeyArray.joinWithSeparator(",")
            if self.PressedKeyArray.count > 0{
                self.pressedKeysLabel?.text = self.PressedKeyArray.joinWithSeparator(",")
            }
            
            self.flashKeyLabel?.text = self.generatedKeyArray[self.currentKeyNo]
            self.correctButton!.setTitle( String(format: "%d",self.totalCorrect), forState: UIControlState.Normal)
            self.wrongButton!.setTitle(String(format: "%d",self.totalWrong), forState: UIControlState.Normal)
            
            
            }
        
        
           self.startTuner()
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.1 * Double(NSEC_PER_SEC) ))
        dispatch_after(delayTime, dispatch_get_main_queue()){
            
            self.tuner?.isDataToBeSent = true
           // self.tuner?.microphone.start()
        }
        
          timer   =    NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "update", userInfo: nil, repeats: true)
    }
    // MARK: UIButton
    @IBAction func closeButtonClick(button: UIButton) {
        
        
        self.check()
        
        
        
        
        
        
    }
    @IBAction func didTouchUpInsideButton(button: UIButton) {
        
      
            self.startGame()
            startButton?.enabled = false
            resumeButton?.enabled = true
            
            
        
        
        
        
    }
    @IBAction func didResumeButton(button: UIButton) {
        
        self.resumeGame()
        startButton?.enabled = true
        resumeButton?.enabled = false
              
        
    }
    @IBAction func didStopButton(button: UIButton) {
        tuner?.stop()
        timer?.invalidate()
        timer = nil
        let alert = UIAlertController(title: "Alert", message: "Do you want to stop?", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler:    {(alert :UIAlertAction!) in
           self.saveData()
           self.navigationController?.popViewControllerAnimated(true)
            
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Default, handler:    {(alert :UIAlertAction!) in
            self.timer   =    NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "update", userInfo: nil, repeats: true)
            self.tuner?.start()
            self.tuner?.isDataToBeSent = true
           // self.tuner?.microphone.start()
            
        }))
        
        
        
        self.presentViewController(alert, animated: true, completion: nil)
        
       
        
        
    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .Default
    }
    
   
    
    private func showMicrophoneAccessAlert() {
        let alert = UIAlertController(title: "Microphone Access", message: "Piano requires access to your microphone; please enable access in your device's settings.", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        // lineView1?.drawUI()
    }

   func nextUI(){
        
   
    
        if totalKeyCompleted == totalPage*totalKeys {
            
            let defaults = NSUserDefaults.standardUserDefaults()
            
            defaults.setBool(false, forKey: "isCurrentGame")
            defaults.setInteger(0, forKey: "totalKeys")
            defaults.setInteger(0, forKey: "totalShowKeys")
            defaults.setInteger(0, forKey: "currentKeyNo")
            defaults.setInteger(0, forKey: "totalKeyCompleted")
            defaults.setInteger(0, forKey: "totalCorrect")
            defaults.setInteger(0, forKey: "totalWrong")
            defaults.setInteger(0, forKey: "timeS")
            defaults.setInteger(0, forKey: "timeM")
            defaults.setInteger(0, forKey: "timeH")
            
            defaults.setInteger(0, forKey: "levelNo")
            defaults.removeObjectForKey("generatedKeyArray")
            defaults.removeObjectForKey("PressedKeyArray")
            defaults.synchronize()
            
            let currentDateTime = NSDate()
            
            let     recordDict =  ["Date": currentDateTime,"Right": totalCorrect,"Wrong": totalWrong,"Remain": totalPage*totalKeys - totalCorrect,"Score": timeH * 3600 + timeM * 60 + timeS,"Level" : gameLevel,"Mode" : gameMode]
            let recordArray = [recordDict]
            let recArray = NSMutableArray(array: recordArray)
            
            let rootPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, .UserDomainMask, true)[0]
            var plistPathInDocument:String = String()
            plistPathInDocument = rootPath.stringByAppendingString("/RecordsArray.plist")
            if !(totalCorrect == 0 && totalWrong == 0){
            if !NSFileManager.defaultManager().fileExistsAtPath(plistPathInDocument){
               recArray.writeToFile(plistPathInDocument, atomically: true)
               
            }
            else{
                let recordDBArray = NSMutableArray(contentsOfFile:plistPathInDocument)
                
                recordDBArray?.addObject(recordDict)
                
                recordDBArray?.writeToFile(plistPathInDocument, atomically: true)
                
            }
            }
            totalKeyCompleted = 0
            totalKeys=4
            totalShowKeys=4
            totalKeyCompleted=0
            generatedKeyArray.removeAll()
            PressedKeyArray.removeAll()
            
            generatedKeysLabel?.text = ""
            currentKeyNo=0;
            
            flashKeyLabel?.text = ""
            
            self.totalWrong = 0
            self.totalCorrect = 0
            
            self.timeH = 0
            self.timeM = 0
            self.timeS = 0
            
            dispatch_async(dispatch_get_main_queue()) {
                self.timeLabel?.text = String(format: "00 : 00")
                
                self.generatedKeysLabel?.text = ""
                self.pressedKeysLabel?.text = "Completed"
                
                self.flashKeyLabel?.text = ""
                self.correctButton!.setTitle("0", forState: UIControlState.Normal)
                self.wrongButton!.setTitle("0", forState: UIControlState.Normal)
               
                
            }
            
            self.stopTuner()
            timer?.invalidate()
            running = false
            
            durationGameLabel?.text = timeLabel?.text
            LevelGameLabel?.text = gameLevel
            modeGameLabel?.text = gameMode
            correctKeyGameLabel?.text = correctButton?.titleLabel?.text
            wrongKeyGameLabel?.text = wrongButton?.titleLabel?.text
            finishBgView?.tag = 100
            finishGameView?.translatesAutoresizingMaskIntoConstraints = false
            self.finishBgView?.hidden = false
            self.view.bringSubviewToFront(self.finishBgView!)
            let frameBaseView : CGRect = (finishGameView?.frame)!
            finishGameView?.frame = CGRectZero
            UIView.animateWithDuration(0.7, delay: 0.0, usingSpringWithDamping: 0.5,
                initialSpringVelocity: 0.5, options: [], animations: {
                    finishGameView?.frame = frameBaseView
                }, completion: { finished in
                  finishGameView?.center = CGPointMake((finishBgView?.frame.size.width)!/2, (finishBgView?.frame.size.height)!/2)
            });
//            UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
//                self.finishBgView?.hidden = false
//                self.view.bringSubviewToFront(self.finishBgView!)
//                }, completion : nil)
            
           // self.navigationController?.popViewControllerAnimated(true)
            
        }
        else{
            ++levelNo;
            var keyArray : [String] = ["C2","D2","E2","F2","A2","B2","C3","D3","E3","F3","A3","B3"]
            var keyArrayTrible : [String] = ["C4","D4","E4","F4","A4","B4","C5","D5","E5","F5","A5","B5","C6"]
            var keyArrayEassy : [String] = ["C3","D3","E3","F3","A3","B3"]
            var keyArrayTribleEassy : [String] = ["C4","D4","E4","F4","A4","B4"]
            if isTestingMode == true{
                generatedKeyArray.removeAll()
                let tempAray : [String] = PressedKeyArray
                PressedKeyArray.removeAll()
                generatedKeyArray = tempAray
                
            }
            else{
            generatedKeyArray.removeAll()
            PressedKeyArray.removeAll()
            
            if gameLevel == "Hard"{
                for var j = 0; j < totalShowKeys/4; ++j{
                    srand(UInt32(time(nil)))
                    let groupNo = Int(arc4random_uniform(UInt32( 2)))
                    srand(UInt32(time(nil)))
                    if groupNo == 1 {
                        for var j=0;j < totalShowKeys/3;++j{
                            let i = Int(arc4random_uniform(UInt32( keyArray.count)))
                            
                            generatedKeyArray.append( keyArray[i])
                            
                        }
                    }
                    else{
                        for var j=0;j<totalShowKeys/3;++j{
                            let i = Int(arc4random_uniform(UInt32( keyArrayTrible.count)))
                            
                            generatedKeyArray.append( keyArrayTrible[i])
                            
                        }
                    }
                  //  NSLog("Array=%@", generatedKeyArray)
                }
            }
            else{
                for var j = 0; j < totalShowKeys/4; ++j{
                    srand(UInt32(time(nil)))
                    let groupNo = Int(arc4random_uniform(UInt32( 2)))
                    srand(UInt32(time(nil)))
                    if groupNo == 1 {
                        for var j=0;j < totalShowKeys/3;++j{
                            let i = Int(arc4random_uniform(UInt32( keyArrayEassy.count)))
                            
                            generatedKeyArray.append( keyArrayEassy[i])
                            
                        }
                    }
                    else{
                        for var j=0;j<totalShowKeys/3;++j{
                            let i = Int(arc4random_uniform(UInt32( keyArrayTribleEassy.count)))
                            
                            generatedKeyArray.append( keyArrayTribleEassy[i])
                            
                        }
                    }
                   // NSLog("Array=%@", generatedKeyArray)
                }
            }
            }

            currentKeyNo = 0
            indexOfSelectedKey=0
            whichKey = 0
            self.drawUI()
            let thisLineView : lineView = pianoView()
           
        //    NSLog("index =%d", indexOfSelectedKey)
            thisLineView.indexOfSelectedKey = indexOfSelectedKey
//            thisLineView.selectKey(self.generatedKeyArray[self.currentKeyNo])
//            flashKeyLabel?.text = generatedKeyArray[currentKeyNo]
            
            dispatch_async(dispatch_get_main_queue()) {
                
                var minTime : String = String(format: "%d",self.timeM)
                var secTime : String = String(format: "%d",self.timeS)
                if self.timeM < 10{
                    minTime = String(format: "0%d",self.timeM)
                    if self.timeM == 0{
                       minTime = String(format: "00")
                    }
                }
                if self.timeS < 10{
                    secTime = String(format: "0%d",self.timeS)
                    if self.timeS == 0{
                        secTime = String(format: "00")
                    }
                }
                self.timeLabel?.text = String(format: "%@ : %@",minTime,secTime)
              //  NSLog( "%d:%d:%d",self.timeH,self.timeM,self.timeS)
                self.generatedKeysLabel?.text = self.generatedKeyArray.joinWithSeparator(",")
                if self.PressedKeyArray.count > 0{
                    self.pressedKeysLabel?.text = self.PressedKeyArray.joinWithSeparator(",")
                }
                
                self.flashKeyLabel?.text = self.generatedKeyArray[self.currentKeyNo]
                self.correctButton!.setTitle( String(format: "%d",self.totalCorrect), forState: UIControlState.Normal)
                self.wrongButton!.setTitle(String(format: "%d",self.totalWrong), forState: UIControlState.Normal)
               
                
            }
            UIView.animateWithDuration(0.05, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                let  pianoPage : lineView = self.notePageArray[self.levelNo-1] as! lineView
                var rectView : CGRect = pianoPage.frame
                rectView.origin.x = 0
                
               
                pianoPage.frame = rectView
                
                }, completion : { finished in
                    self.startButton?.enabled = false
                    self.resumeButton?.enabled = true
                    self.running = true
//                    self.tuner?.timerTime = self.timeForTimer
                    self.tuner?.timerTime = 0.1
                   // self.tuner?.cutoffAmplitude = 0.01
                    
                    self.tuner?.cutoffAmplitude = Float( self.toDB)
                    
                    self.tuner?.start()
                    
                    self.timer   =    NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "update", userInfo: nil, repeats: true)
                    
                    if  self.indexOfSelectedKey <= -1{
                        self.indexOfSelectedKey = 0
                    }
                 //   NSLog("index =%d", self.indexOfSelectedKey)
                    thisLineView.indexOfSelectedKey = self.indexOfSelectedKey
                    thisLineView.whichKey = self.whichKey
                    thisLineView.selectKey(self.generatedKeyArray[self.currentKeyNo])
                    let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.1 * Double(NSEC_PER_SEC) ))
                    dispatch_after(delayTime, dispatch_get_main_queue()){
                        
                        self.tuner?.isDataToBeSent = true
                       // self.tuner?.microphone.start()
                        
                    }
                    self.flashKeyLabel?.text = self.generatedKeyArray[self.currentKeyNo]
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        var minTime : String = String(format: "%d",self.timeM)
                        var secTime : String = String(format: "%d",self.timeS)
                        if self.timeM < 10{
                            minTime = String(format: "0%d",self.timeM)
                        }
                        if self.timeS < 10{
                            secTime = String(format: "0%d",self.timeS)
                        }
                        self.timeLabel?.text = String(format: "%@ : %@",minTime,secTime)
                        
                        self.generatedKeysLabel?.text = self.generatedKeyArray.joinWithSeparator(",")
                        if self.PressedKeyArray.count > 0{
                            self.pressedKeysLabel?.text = self.PressedKeyArray.joinWithSeparator(",")
                        }
                        
                        self.flashKeyLabel?.text = self.generatedKeyArray[self.currentKeyNo]
                        self.correctButton!.setTitle( String(format: "%d",self.totalCorrect), forState: UIControlState.Normal)
                        self.wrongButton!.setTitle(String(format: "%d",self.totalWrong), forState: UIControlState.Normal)
                        
                        
                    }
                    
                })
                }
}
    
    func update() {
        // Something cool
        ++self.timeS
        if self.timeS >= 60{
            self.timeS = 0
            ++self.timeM
            if self.timeM >= 60{
                self.timeM = 0
                ++self.timeH
            }
        }
        
        dispatch_async(dispatch_get_main_queue()) {
            var minTime : String = String(format: "%d",self.timeM)
            var secTime : String = String(format: "%d",self.timeS)
            if self.timeM < 10{
                minTime = String(format: "0%d",self.timeM)
                if self.timeM == 0{
                    minTime = String(format: "00")
                }
            }
            if self.timeS < 10{
                secTime = String(format: "0%d",self.timeS)
                if self.timeS == 0{
                    secTime = String(format: "00")
                }
            }
            self.timeLabel?.text = String(format: "%@ : %@",minTime,secTime)
         //   NSLog( "%d:%d:%d",self.timeH,self.timeM,self.timeS)
            
        }
        
    }
    
   
       override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
       @IBAction func sliderValueChanged(sender: UISlider) {
        
        self.timeForTimer = Double(sender.value)/10
        
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        
        
    }
    public func startTuner() {
        if !running {
            running = true
//            tuner?.timerTime = self.timeForTimer
            tuner?.timerTime = 0.1
            //tuner?.cutoffAmplitude = 0.01
            tuner?.cutoffAmplitude = Float( self.toDB)
            tuner?.start()
            
           
        
        }
    }
    
    public func stopTuner() {
        if running {
            running = false
            tuner?.stop()
            
        }
    }
    
    // MARK: TunerDelegate
    
    func tunerDidUpdate(tuner: Tuner, output: TunerOutput) {
        let thisLineView : lineView = pianoView()
    let key = output.pitch + "\(output.octave)"
        self.tuner?.microphone
        //lineView1?.animateKey(key)
        NSLog("Key=%@,True Key=%@", key,generatedKeyArray[currentKeyNo])
    if key .isEqual(generatedKeyArray[currentKeyNo]) == true{
        
           ++totalCorrect
           correctButton!.setTitle(String(format: "%d",totalCorrect), forState: UIControlState.Normal)
           if currentKeyNo == generatedKeyArray.count-1 {
            PressedKeyArray.append( generatedKeyArray[currentKeyNo++])
            ++totalKeyCompleted
            self.pressedKeysLabel?.text = PressedKeyArray.joinWithSeparator(",")
            thisLineView.animateKey(key, withColor: UIColor.blueColor())
            self.flashKeyLabel?.text = ""
            startButton?.enabled = true
            resumeButton?.enabled = false
            timer?.invalidate()
            self.stopTuner()
            self.nextUI()
            
            
               }
           else{
                    PressedKeyArray.append( generatedKeyArray[currentKeyNo++])
                    ++totalKeyCompleted
                     var  result1 : String = ""
                      for var j=0;j<PressedKeyArray.count;++j{
                                    if result1.isEmpty{
                                        result1 = PressedKeyArray[j]
                                    }
                                    else{
                                        result1 = result1 + " ," + PressedKeyArray[j]
                                    }
                                }
                                thisLineView.animateKey(key, withColor: UIColor.blueColor())
                                self.pressedKeysLabel?.text = result1
                                thisLineView.selectKey(self.generatedKeyArray[self.currentKeyNo])
                               let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.1 * Double(NSEC_PER_SEC) ))
                               dispatch_after(delayTime, dispatch_get_main_queue()){
                
                                 self.tuner?.isDataToBeSent = true
                               // self.tuner?.microphone.start()
                                
                               }
                                self.flashKeyLabel?.text = self.generatedKeyArray[self.currentKeyNo]
                                
                                
                            }
                            
         }
    else{
                          let myNSString = key as NSString
                          if myNSString.length > 2{
                            let fisrtChar  = myNSString.substringWithRange(NSRange(location: 0, length: 1))
                            let secondChar = myNSString.substringWithRange(NSRange(location: 2, length: 1))
                              let secondNumber = Int(secondChar)
                           //  NSLog("AnimatedKey=%@ secondNumber=%d", key,secondNumber!)
                            if secondNumber > 6 || secondNumber < 2  {
                                let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.1 * Double(NSEC_PER_SEC) ))
                                dispatch_after(delayTime, dispatch_get_main_queue()){
                                    
                                    self.tuner?.isDataToBeSent = true
                                   // self.tuner?.microphone.start()
                                    NSLog("Wrong")
                                }
                                return
                
                            }
                         }
                          else{
                            let fisrtChar  = myNSString.substringWithRange(NSRange(location: 0, length: 1))
                            let secondChar = myNSString.substringWithRange(NSRange(location: 1, length: 1))
                            let secondNumber = Int(secondChar)
                           // NSLog("AnimatedKey=%@ secondNumber=%d", key,secondNumber!)
                            if secondNumber > 6 || secondNumber < 2  {
                                let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.1 * Double(NSEC_PER_SEC) ))
                                dispatch_after(delayTime, dispatch_get_main_queue()){
                                    
                                    self.tuner?.isDataToBeSent = true
                                    //self.tuner?.microphone.start()
                                    NSLog("Wrong")
                                }

                                return
                                
                            }
                           }
                           thisLineView.animateKey(key, withColor: UIColor.redColor())
                           ++totalWrong
                           wrongButton!.setTitle(String(format: "%d",totalWrong), forState: UIControlState.Normal)
                          let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.1 * Double(NSEC_PER_SEC) ))
                          dispatch_after(delayTime, dispatch_get_main_queue()){
                          
                                self.tuner?.isDataToBeSent = true
                               // self.tuner?.microphone.start()
                            NSLog("Wrong")
                          }
        
        
                        }
                        
    }
    
   
}

