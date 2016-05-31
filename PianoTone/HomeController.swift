//
//  HomeController.swift
//  PianoTone
//
//  Created by luv mehta on 21/12/15.
//  Copyright © 2015 luv mehta. All rights reserved.
//

import UIKit

class HomeController: UIViewController {
    @IBOutlet    var startButton: UIButton?
    @IBOutlet    var resumeButton: UIButton?
    @IBOutlet    var settingView: UIView?
    @IBOutlet    var trainingButton: UIButton?
    @IBOutlet    var challengeButton: UIButton?
    @IBOutlet    var easyButton: UIButton?
    @IBOutlet    var hardButton: UIButton?
    @IBOutlet    var mediumButton: UIButton?
    @IBOutlet    var preKeyButton: UIButton?
  
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
    var levelNo : Int = 0
    var indexOfSelectedKey : Int = -1
    var whichKey : Int = -1
    var gameMode     : String = "Challenge"
    var gameLevel     : String = "Hard"
//    var keyArray : [String] = ["C2","D2","E2","F2","A2","B2","C3","D3","E3","F3","A3","B3","C4","D4","E4","F4","A4","B4","C5","D5","E5","F5","A5","B5","C6"]
   var keyArray : [String] = ["C2","D2","E2","F2","G2","A2","B2","C3","D3","E3","F3","G3","A3","B3"]
    var keyArrayTrible : [String] = ["C4","D4","E4","F4","G4","A4","B4","C5","D5","E5","F5","G5","A5","B5","C6"]
    
    var keyArrayEassy : [String] = ["C3","D3","E3","F3","G3","A3","B3"]
    var keyArrayTribleEassy : [String] = ["C4","D4","E4","F4","G4","A4","B4"]

    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "removeFromUserDefault",
            name: "removeFromUserDefault",
            object: nil)
        
        
        self.navigationController?.navigationBarHidden = true
        
    }
    func removeFromUserDefault(){
        let defaults = NSUserDefaults.standardUserDefaults()
        var isFound = false
        if defaults.boolForKey("isCurrentGame") {
            let keys: NSArray = defaults.arrayForKey("generatedKeyArray")!
            if  keys.count > 0{
                
                isFound = true
            }
            else{
                isFound = false
            }
        }
        else{
            isFound = false
        }
        
        if  isFound == true{
            
            let totalKeys1 : Int = defaults.integerForKey("totalKeys")
           
            
            let totalKeyCompleted1 : Int = defaults.integerForKey("totalKeyCompleted")
            let totalCorrect1 : Int = defaults.integerForKey("totalCorrect")
            let totalWrong1 : Int = defaults.integerForKey("totalWrong")
            let timeS1 : Int = defaults.integerForKey("timeS")
            let timeM1 : Int = defaults.integerForKey("timeM")
            let timeH1 : Int = defaults.integerForKey("timeH")
            
            let gameMode1 : String  =  defaults.objectForKey("ModeCurrent") as! String
            let gameLevel1 : String =  defaults.objectForKey("LevelCurrent") as! String
            NSLog("%d,%d,%d,%d,%d,%d,(%d:%d:%d)", totalKeys,totalShowKeys,currentKeyNo,totalKeyCompleted,totalCorrect,totalWrong,timeS,timeM,timeH)
            
            
            let  totalPage : Int = defaults.integerForKey("totalPage")
            
            let currentDateTime = NSDate()
            
            let     recordDict =  ["Date": currentDateTime,"Right": totalCorrect1,"Wrong": totalWrong1,"Remain": totalPage*totalKeys1 - totalCorrect1,"Score": timeH1 * 3600 + timeM1 * 60 + timeS1,"Level" : gameLevel1,"Mode" : gameMode1]
            let recordArray = [recordDict]
            let recArray = NSMutableArray(array: recordArray)
            
            let rootPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, .UserDomainMask, true)[0]
            var plistPathInDocument:String = String()
            plistPathInDocument = rootPath.stringByAppendingString("/RecordsArray.plist")
           if !(totalCorrect1 == 0 && totalWrong1 == 0){
            if !NSFileManager.defaultManager().fileExistsAtPath(plistPathInDocument){
                recArray.writeToFile(plistPathInDocument, atomically: true)
                
            }
            else{
                let recordDBArray = NSMutableArray(contentsOfFile:plistPathInDocument)
                
                recordDBArray?.addObject(recordDict)
                
                recordDBArray?.writeToFile(plistPathInDocument, atomically: true)
                
            }
            }
           self.removeDataFromUserDefault()
            
        }
        
        
    }
    override func viewDidAppear(animated: Bool) {
       
        startButton?.layer.masksToBounds = true
        startButton?.layer.cornerRadius = 10.0
        startButton?.layer.borderWidth = 1.0
        startButton?.layer.borderColor = UIColor.whiteColor().CGColor
        
        resumeButton?.layer.masksToBounds = true
        resumeButton?.layer.cornerRadius = 2.0
        resumeButton?.layer.borderWidth = 1.0
        resumeButton?.layer.borderColor = UIColor.whiteColor().CGColor
        
        settingView?.layer.masksToBounds = true
        settingView?.layer.cornerRadius = 10.0
        settingView?.layer.borderWidth = 1.0
        settingView?.layer.borderColor = UIColor.whiteColor().CGColor
        //settingView?.backgroundColor = UIColor(patternImage: UIImage(named: "bgImage.png")!)
        
        trainingButton?.layer.masksToBounds = true
        trainingButton?.layer.cornerRadius = 20.0
        trainingButton?.layer.borderWidth = 1.0
        trainingButton?.layer.borderColor = UIColor.whiteColor().CGColor
        
        challengeButton?.layer.masksToBounds = true
        challengeButton?.layer.cornerRadius = 20.0
        challengeButton?.layer.borderWidth = 1.0
        challengeButton?.layer.borderColor = UIColor.whiteColor().CGColor
        
        easyButton?.layer.masksToBounds = true
        easyButton?.layer.cornerRadius = 20.0
        easyButton?.layer.borderWidth = 1.0
        easyButton?.layer.borderColor = UIColor.whiteColor().CGColor
        
        hardButton?.layer.masksToBounds = true
        hardButton?.layer.cornerRadius = 20.0
        hardButton?.layer.borderWidth = 1.0
        hardButton?.layer.borderColor = UIColor.whiteColor().CGColor
        
        mediumButton?.layer.masksToBounds = true
        mediumButton?.layer.cornerRadius = 20.0
        mediumButton?.layer.borderWidth = 1.0
        mediumButton?.layer.borderColor = UIColor.whiteColor().CGColor
        
        
        let defaults = NSUserDefaults.standardUserDefaults()
       
        let isPreKey : Bool = defaults.boolForKey("isUsePreKeys")
        if isPreKey == true{
           
            if let image = UIImage(named: "chk.png") {
                preKeyButton!.setImage(image, forState: .Normal)
            }
        }
        else{
            if let image = UIImage(named: "unchk.png") {
                preKeyButton!.setImage(image, forState: .Normal)
            }
        }
        // defaults.setBool(true, forKey: "isUsePreKeys")
        let mode  = defaults.objectForKey("Mode") as! String
        let level = defaults.objectForKey("Level") as! String
        
        if mode.caseInsensitiveCompare("Training") == NSComparisonResult.OrderedSame {
            trainingButton?.backgroundColor = UIColor.whiteColor()
            challengeButton?.backgroundColor = UIColor.clearColor()
            
            trainingButton?.titleLabel?.textColor = UIColor.blackColor()
            challengeButton?.titleLabel?.textColor = UIColor.whiteColor()
            
        }
        else{
            trainingButton?.backgroundColor = UIColor.clearColor()
            challengeButton?.backgroundColor = UIColor.whiteColor()
            
            challengeButton?.titleLabel?.textColor = UIColor.blackColor()
            trainingButton?.titleLabel?.textColor = UIColor.whiteColor()

        }
        
        if level.caseInsensitiveCompare("Easy") == NSComparisonResult.OrderedSame {
            easyButton?.backgroundColor = UIColor.whiteColor()
            easyButton?.titleLabel?.textColor = UIColor.blackColor()
            
            hardButton?.backgroundColor = UIColor.clearColor()
            hardButton?.titleLabel?.textColor = UIColor.whiteColor()
            
            mediumButton?.backgroundColor = UIColor.clearColor()
            mediumButton?.titleLabel?.textColor = UIColor.whiteColor()
           
            
        }
        else if level.caseInsensitiveCompare("Medium") == NSComparisonResult.OrderedSame {
            
            easyButton?.backgroundColor = UIColor.clearColor()
            easyButton?.titleLabel?.textColor = UIColor.whiteColor()
            
            hardButton?.backgroundColor = UIColor.clearColor()
            hardButton?.titleLabel?.textColor = UIColor.whiteColor()
            
            mediumButton?.backgroundColor = UIColor.whiteColor()
            mediumButton?.titleLabel?.textColor = UIColor.blackColor()
        }
        else{
            easyButton?.backgroundColor = UIColor.clearColor()
            easyButton?.titleLabel?.textColor = UIColor.whiteColor()
            
            hardButton?.backgroundColor = UIColor.whiteColor()
            hardButton?.titleLabel?.textColor = UIColor.blackColor()
            
            mediumButton?.backgroundColor = UIColor.clearColor()
            mediumButton?.titleLabel?.textColor = UIColor.whiteColor()
        }
      
        
        
        
      
        
//        if let facetimeURL:NSURL = NSURL(string: "facetime://+919038879171") {
//            let application:UIApplication = UIApplication.sharedApplication()
//            if (application.canOpenURL(facetimeURL)) {
//                application.openURL(facetimeURL);
//            }
//        }
        
        
    }
    override func viewWillAppear(animated: Bool) {
        // Do any additional setup after loading the view.
        let defaults = NSUserDefaults.standardUserDefaults()
        gameMode =  defaults.objectForKey("Mode") as! String
        gameLevel =  defaults.objectForKey("Level") as! String
        NSLog("Mode=%@,Level=%@", gameMode,gameLevel)
      
        check()
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func check(){
        let defaults = NSUserDefaults.standardUserDefaults()
        var isFound = false
        if defaults.boolForKey("isCurrentGame") {
            let keys: NSArray = defaults.arrayForKey("generatedKeyArray")!
            if  keys.count > 0{
                
                isFound = true
            }
            else{
                isFound = false
            }
        }
        else{
            isFound = false
        }
        
        if  isFound == true{
            
            resumeButton?.hidden = false
        }
        else{
            resumeButton?.hidden = true
        }
        
        startButton!.setTitle("Start", forState: .Normal)
       
      
        
    }
    func saveData(){
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
            defaults.setObject(generatedKeyArray, forKey: "generatedKeyArray")
            defaults.setObject(PressedKeyArray, forKey: "PressedKeyArray")
            defaults.setObject(--whichKey, forKey: "whichKey")
            defaults.setObject(gameLevel, forKey: "Level")
            defaults.setObject(gameMode, forKey: "Mode")
            defaults.synchronize()
        }
       
        
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
        defaults.setInteger(0, forKey: "levelNo")
        defaults.setInteger(0, forKey: "whichKey")
        defaults.removeObjectForKey("generatedKeyArray")
        defaults.removeObjectForKey("PressedKeyArray")
        defaults.setInteger(0, forKey: "indexOfSelectedKey")
        defaults.removeObjectForKey("ModeCurrent")
        defaults.removeObjectForKey("LevelCurrent")
       
        defaults.synchronize()
        resumeButton?.hidden = true
        
    }
    func resumeGame(){
        let defaults = NSUserDefaults.standardUserDefaults()
        totalKeys = defaults.integerForKey("totalKeys")
        totalShowKeys =  defaults.integerForKey("totalShowKeys")
        currentKeyNo = defaults.integerForKey("currentKeyNo")
        totalKeyCompleted = defaults.integerForKey("totalKeyCompleted")
        totalCorrect = defaults.integerForKey("totalCorrect")
        totalWrong = defaults.integerForKey("totalWrong")
        timeS = defaults.integerForKey("timeS")
        timeM = defaults.integerForKey("timeM")
        timeH = defaults.integerForKey("timeH")
        indexOfSelectedKey = defaults.integerForKey("indexOfSelectedKey")
        levelNo = defaults.integerForKey("levelNo")
        whichKey = defaults.integerForKey("whichKey")
        gameMode =  defaults.objectForKey("ModeCurrent") as! String
        gameLevel =  defaults.objectForKey("LevelCurrent") as! String
         NSLog("%d,%d,%d,%d,%d,%d,%d,(%d:%d:%d)",levelNo, totalKeys,totalShowKeys,currentKeyNo,totalKeyCompleted,totalCorrect,totalWrong,timeS,timeM,timeH)
            
            if let keys: NSArray = defaults.arrayForKey("generatedKeyArray"){
                
                generatedKeyArray = keys as! [String]
                
                
            }
            if let keys: NSArray = defaults.arrayForKey("PressedKeyArray"){
                
                PressedKeyArray = keys as! [String]
                
            }
       
        resumeButton?.hidden = true
         moveToPianoController()
        
    }
    func moveToPianoController(){
         let defaults = NSUserDefaults.standardUserDefaults()
        let pianoController = self.storyboard?.instantiateViewControllerWithIdentifier("ViewController") as? ViewController
        pianoController?.currentKeyNo = currentKeyNo
        pianoController?.generatedKeyArray = generatedKeyArray
        pianoController?.PressedKeyArray = PressedKeyArray
        pianoController?.totalKeys = totalKeys
        pianoController?.totalShowKeys = totalShowKeys
        pianoController?.totalKeyCompleted = totalKeyCompleted
        pianoController?.totalCorrect = totalCorrect
        pianoController?.totalWrong = totalWrong
        pianoController?.timeH = timeH
        pianoController?.timeM = timeM
        pianoController?.timeS = timeS
        pianoController!.indexOfSelectedKey = indexOfSelectedKey
        pianoController?.levelNo = self.levelNo
        pianoController?.whichKey = self.whichKey
        pianoController!.gameMode = gameMode
        pianoController!.gameLevel = gameLevel
        if defaults.boolForKey("isUsePreKeys") == true{
            pianoController!.isTestingMode = true
        }
        else{
            pianoController!.isTestingMode = false
        }
        
         NSLog("Mode=%@,Level=%@", gameMode,gameLevel)
        self.navigationController?.pushViewController(pianoController!, animated: true)
        //pianoController?.drawUI()
    }
    func startGame(){
        let defaults = NSUserDefaults.standardUserDefaults()
        var isFound = false
        if defaults.boolForKey("isCurrentGame") {
            let keys: NSArray = defaults.arrayForKey("generatedKeyArray")!
            if  keys.count > 0{
                
                isFound = true
            }
            else{
                isFound = false
            }
        }
        else{
            isFound = false
        }
        
        if  isFound == true{
            
            totalKeys = defaults.integerForKey("totalKeys")
            totalShowKeys =  defaults.integerForKey("totalShowKeys")
            currentKeyNo = defaults.integerForKey("currentKeyNo")
            totalKeyCompleted = defaults.integerForKey("totalKeyCompleted")
            totalCorrect = defaults.integerForKey("totalCorrect")
            totalWrong = defaults.integerForKey("totalWrong")
            timeS = defaults.integerForKey("timeS")
            timeM = defaults.integerForKey("timeM")
            timeH = defaults.integerForKey("timeH")
            levelNo = defaults.integerForKey("levelNo")
            whichKey = defaults.integerForKey("whichKey")
            gameMode =  defaults.objectForKey("ModeCurrent") as! String
            gameLevel =  defaults.objectForKey("LevelCurrent") as! String
            NSLog("%d,%d,%d,%d,%d,%d,(%d:%d:%d)", totalKeys,totalShowKeys,currentKeyNo,totalKeyCompleted,totalCorrect,totalWrong,timeS,timeM,timeH)
            
            if let keys: NSArray = defaults.arrayForKey("generatedKeyArray"){
                
                generatedKeyArray = keys as! [String]
                
                
            }
            if let keys: NSArray = defaults.arrayForKey("PressedKeyArray"){
                
                PressedKeyArray = keys as! [String]
                
                
            }
            let  totalPage : Int = defaults.integerForKey("totalPage")
            
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
            
            
        }
        
        totalKeys = 12
        totalShowKeys = 12
        
        generatedKeyArray.removeAll()
        PressedKeyArray.removeAll()
       if defaults.boolForKey("isUsePreKeys") == true{
        if gameLevel == "Easy"{
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.hardArrayIndex = -1
            generatedKeyArray = appDelegate.getEasyKeyArray()
        }
        else  if gameLevel == "Medium"{
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.hardArrayIndex = -1
            
            generatedKeyArray = appDelegate.getMediumKeyArray()
        }
        else{
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.hardArrayIndex = -1
            generatedKeyArray = appDelegate.getHardKeyArray()
            
        }
        
        }
       else{
       if gameLevel == "Hard"{
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
         generatedKeyArray = appDelegate.HardKeyArray()
       }
        else if gameLevel == "Medium"{
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        generatedKeyArray = appDelegate.MediumKeyArray()
       }
       else{
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
          generatedKeyArray = appDelegate.EasyKeyArray()
        }
        }
        
        currentKeyNo=0;
        totalKeyCompleted = 0
        self.totalWrong = 0
        self.totalCorrect = 0
        self.timeH = 0
        self.timeM = 0
        self.timeS = 0
        self.levelNo = 1
        self.whichKey = 0
        gameMode =  defaults.objectForKey("Mode") as! String
        gameLevel =  defaults.objectForKey("Level") as! String
        moveToPianoController()
        
        
  }
    @IBAction func didPreButton(button: UIButton) {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        let isPreKey : Bool = defaults.boolForKey("isUsePreKeys")
        if isPreKey == true{
            
            if let image = UIImage(named: "unchk.png") {
                preKeyButton!.setImage(image, forState: .Normal)
            }
            defaults.setBool(false, forKey: "isUsePreKeys")
        }
        else{
            if let image = UIImage(named: "chk.png") {
                preKeyButton!.setImage(image, forState: .Normal)
            }
            defaults.setBool(true, forKey: "isUsePreKeys")
        }
        defaults.synchronize()
        
        
    }
    @IBAction func didTouchUpInsideButton(button: UIButton) {
        
     startGame()
        
        
    }
    @IBAction func didTestClick(button: UIButton) {
         let defaults = NSUserDefaults.standardUserDefaults()
       
        
        generatedKeyArray.removeAll()
        PressedKeyArray.removeAll()
        
        totalKeys = 12
        totalShowKeys = 12
        
        currentKeyNo=0;
        totalKeyCompleted = 0
        self.totalWrong = 0
        self.totalCorrect = 0
        self.timeH = 0
        self.timeM = 0
        self.timeS = 0
        self.levelNo = 1
        self.whichKey = 0
        gameMode =  defaults.objectForKey("Mode") as! String
        gameLevel =  defaults.objectForKey("Level") as! String
        let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if gameLevel == "Easy"{
             generatedKeyArray = appDelegate.getEasyKeyArray()
        }
        else  if gameLevel == "Medium"{
            generatedKeyArray = appDelegate.getMediumKeyArray()
        }
        else{
             generatedKeyArray = appDelegate.getHardKeyArray()
        }
       
        let pianoController = self.storyboard?.instantiateViewControllerWithIdentifier("ViewController") as? ViewController
        pianoController?.currentKeyNo = currentKeyNo
        pianoController?.generatedKeyArray = generatedKeyArray
        pianoController?.PressedKeyArray = PressedKeyArray
        pianoController?.totalKeys = totalKeys
        pianoController?.totalShowKeys = totalShowKeys
        pianoController?.totalKeyCompleted = totalKeyCompleted
        pianoController?.totalCorrect = totalCorrect
        pianoController?.totalWrong = totalWrong
        pianoController?.timeH = timeH
        pianoController?.timeM = timeM
        pianoController?.timeS = timeS
        pianoController!.indexOfSelectedKey = indexOfSelectedKey
        pianoController?.levelNo = self.levelNo
        pianoController?.whichKey = self.whichKey
        pianoController!.gameMode = gameMode
        pianoController!.gameLevel = gameLevel
        pianoController!.isTestingMode = true
        
        self.navigationController?.pushViewController(pianoController!, animated: true)

        

        
        
    }
    @IBAction func didResumeButton(button: UIButton) {
        
      resumeGame()    
        
        
    }
    @IBAction func didHistoryClick(button: UIButton) {
        
        let historyController = self.storyboard?.instantiateViewControllerWithIdentifier("HistoryController") as? HistoryController
        
        self.navigationController?.pushViewController(historyController!, animated: true)
        
        
        
    }
    @IBAction func didSettingsClick(button: UIButton) {
        
        let pianoController = self.storyboard?.instantiateViewControllerWithIdentifier("SettingsController") as? SettingsController
        
        self.navigationController?.pushViewController(pianoController!, animated: true)
        
        
        
    }
    
    
    @IBAction func didHardClick(button: UIButton) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject("Hard", forKey: "Level")
        defaults.synchronize()
        easyButton?.backgroundColor = UIColor.clearColor()
        easyButton?.titleLabel?.textColor = UIColor.whiteColor()
        
        hardButton?.backgroundColor = UIColor.whiteColor()
        hardButton?.titleLabel?.textColor = UIColor.blackColor()
        
        mediumButton?.backgroundColor = UIColor.clearColor()
        mediumButton?.titleLabel?.textColor = UIColor.whiteColor()
    }
    @IBAction func didMediumClick(button: UIButton) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject("Medium", forKey: "Level")
        defaults.synchronize()
        easyButton?.backgroundColor = UIColor.clearColor()
        easyButton?.titleLabel?.textColor = UIColor.whiteColor()
        
        hardButton?.backgroundColor = UIColor.clearColor()
        hardButton?.titleLabel?.textColor = UIColor.whiteColor()
        
        mediumButton?.backgroundColor = UIColor.whiteColor()
        mediumButton?.titleLabel?.textColor = UIColor.blackColor()
        
    }
    @IBAction func didEasyClick(button: UIButton) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject("Easy", forKey: "Level")
        defaults.synchronize()
        easyButton?.backgroundColor = UIColor.whiteColor()
        easyButton?.titleLabel?.textColor = UIColor.blackColor()
        
        hardButton?.backgroundColor = UIColor.clearColor()
        hardButton?.titleLabel?.textColor = UIColor.whiteColor()
        
        mediumButton?.backgroundColor = UIColor.clearColor()
        mediumButton?.titleLabel?.textColor = UIColor.whiteColor()
        
    }
    
    @IBAction func didChallengeClick(button: UIButton) {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject("Challenge", forKey: "Mode")
        defaults.synchronize()
        
        trainingButton?.backgroundColor = UIColor.clearColor()
        challengeButton?.backgroundColor = UIColor.whiteColor()
        
        challengeButton?.titleLabel?.textColor = UIColor.blackColor()
        trainingButton?.titleLabel?.textColor = UIColor.whiteColor()
        
    }
    @IBAction func didTrainingClick(button: UIButton) {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject("Training", forKey: "Mode")
        defaults.synchronize()
        trainingButton?.backgroundColor = UIColor.whiteColor()
        challengeButton?.backgroundColor = UIColor.clearColor()
        
        trainingButton?.titleLabel?.textColor = UIColor.blackColor()
        challengeButton?.titleLabel?.textColor = UIColor.whiteColor()
        
    }
    @IBAction func didInfoClick(button: UIButton) {
        
        let pianoController = self.storyboard?.instantiateViewControllerWithIdentifier("SlideShowControllerViewController") as? SlideShowControllerViewController
        
        self.navigationController?.pushViewController(pianoController!, animated: true)
        
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
