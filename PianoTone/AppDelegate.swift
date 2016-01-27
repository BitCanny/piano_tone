//
//  AppDelegate.swift
//  PianoTone
//
//  Created by luv mehta on 25/11/15.
//  Copyright © 2015 luv mehta. All rights reserved.
//

import UIKit
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var mainViewController: ViewController?
    
    var generatedEasyKeyArray : [String] = ["D3","B3","E3","D3","F4","D4","D4","D4","E4","D4","A4","E4"]
    
//    var generatedHardKeyArray : [String] = ["E4","B5","F4","C6","F4","C4","F4","C6","E5","C6","A4","F5"]
    var generatedHardKeyArray : [String] = ["C2","D2","E2","F2","G2","A2","B2","C3","D3","E3","F3","G3"]
    var keyArray : [String] = ["C2","D2","E2","F2","A2","B2","C3","D3","E3","F3","A3","B3"]
    var keyArrayTrible : [String] = ["C4","D4","E4","F4","A4","B4","C5","D5","E5","F5","A5","B5","C6"]
    
    var keyArrayEassy : [String] = ["C3","D3","E3","F3","A3","B3"]
    var keyArrayTribleEassy : [String] = ["C4","D4","E4","F4","A4","B4"]
    var isPreGeneratedKeys : Bool = false
    var hardArrayIndex : Int = -1
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        let defaults = NSUserDefaults.standardUserDefaults()
       // defaults.setBool(true, forKey: "isUsePreKeys")
        let isMode = defaults.boolForKey("isMode")
        if isMode == false{
             defaults.setBool(true, forKey: "isMode")
            defaults.setObject("Challenge", forKey: "Mode")
            
            

        }
        let isLevel = defaults.boolForKey("isLevel")
        if isLevel == false{
            defaults.setBool(true, forKey: "isLevel")
            defaults.setObject("Hard", forKey: "Level")

        }
        let isTimerTime = defaults.boolForKey("isTimerTime")
        if isTimerTime == false{
            defaults.setBool(true, forKey: "isTimerTime")
            defaults.setDouble(0.1, forKey: "timerTime")
            
        }
        let toDB = defaults.doubleForKey("amplitudeLevel")
        if toDB <= 0 {
           defaults.setDouble(0.006, forKey: "amplitudeLevel")
        }
        defaults.synchronize()
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
          //  self.mainViewController?.saveData()
        NSNotificationCenter.defaultCenter().postNotificationName("saveData", object: nil)
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        NSNotificationCenter.defaultCenter().postNotificationName("saveData", object: nil)
        //self.mainViewController?.saveData()
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        NSNotificationCenter.defaultCenter().postNotificationName("check", object: nil)
       // self.mainViewController?.UIInit()
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        NSNotificationCenter.defaultCenter().postNotificationName("saveData", object: nil)
        
    }
    func getHardKeyArray()->[String]{
      ++hardArrayIndex
       
        switch (hardArrayIndex) {
        case  0  :
            generatedHardKeyArray.removeAll()
            generatedHardKeyArray = ["C2","C2","D2","D2","E2","E2","F2","F2","G2","G2","A2","A2"]
            
            break
        case 1:
            generatedHardKeyArray.removeAll()
            generatedHardKeyArray = ["B2","B2","C3","C3","D3","D3","E3","E3","F3","F3","G3","G3"]
            break
        case 2:
            generatedHardKeyArray.removeAll()
            generatedHardKeyArray = ["A3","A3","B3","B3","C4","C4","D4","D4","E4","E4","F4","F4"]
            break
        case 3:
            generatedHardKeyArray.removeAll()
            generatedHardKeyArray = ["G4","G4","A4","A4","B4","B4","C5","C5","D5","D5","E5","E5"]
            break
       
        default:
            
            generatedHardKeyArray.removeAll()
            generatedHardKeyArray = ["F5","F5","G5","G5","A5","A5","B5","B5","C6","C2","D2","D2"]
            hardArrayIndex = -1
            break
        }
       
        return generatedHardKeyArray
    }
    func getEasyKeyArray()->[String]{
        ++hardArrayIndex
        
        switch (hardArrayIndex) {
        case  0  :
            generatedHardKeyArray.removeAll()
            generatedHardKeyArray = ["C2","C2","D2","D2","E2","E2","F2","F2","G2","G2","A2","A2"]
            
            break
        case 1:
            generatedHardKeyArray.removeAll()
            generatedHardKeyArray = ["B2","B2","C3","C3","D3","D3","E3","E3","F3","F3","G3","G3"]
            break
        case 2:
            generatedHardKeyArray.removeAll()
            generatedHardKeyArray = ["A3","A3","B3","B3","C4","C4","D4","D4","E4","E4","F4","F4"]
            break
        case 3:
            generatedHardKeyArray.removeAll()
            generatedHardKeyArray = ["G4","G4","A4","A4","B4","B4","C5","C5","D5","D5","E5","E5"]
            break
            
        default:
            
            generatedHardKeyArray.removeAll()
            generatedHardKeyArray = ["F5","F5","G5","G5","A5","A5","B5","B5","C6","C2","D2","D2"]
            hardArrayIndex = -1
            break
        }
        
        return generatedHardKeyArray
    }
    }

