//
//  HistoryController.swift
//  PianoTone
//
//  Created by luv mehta on 22/12/15.
//  Copyright © 2015 luv mehta. All rights reserved.
//

import UIKit

class HistoryController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    @IBOutlet weak var mTableView: UITableView!
    var recordDBArray : NSMutableArray  = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let defaults = NSUserDefaults.standardUserDefaults()
        let  gameMode : String =  defaults.objectForKey("Mode") as! String
        let rootPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, .UserDomainMask, true)[0]
        var plistPathInDocument:String = String()
        plistPathInDocument = rootPath.stringByAppendingString("/RecordsArray.plist")
        if NSFileManager.defaultManager().fileExistsAtPath(plistPathInDocument){
            let recArray : NSArray = NSMutableArray(contentsOfFile:plistPathInDocument)!
            for dataObject : AnyObject in recArray
            {
                if let data = dataObject as? NSDictionary
                {
                    let mode : String = data["Mode"] as! String
                    if mode == gameMode{
                      recordDBArray.addObject(data)
                    }
                    
                }
            }
            
            
            mTableView.reloadData()
            
        }
       mTableView.tableFooterView = UIView(frame: CGRectZero)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func didDeleteClick(button: UIButton) {
      
        let rootPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, .UserDomainMask, true)[0]
        var plistPathInDocument:String = String()
        plistPathInDocument = rootPath.stringByAppendingString("/RecordsArray.plist")
        
        if NSFileManager.defaultManager().fileExistsAtPath(plistPathInDocument){
            do {
                try NSFileManager.defaultManager().removeItemAtPath(plistPathInDocument)
                recordDBArray.removeAllObjects()
                mTableView.reloadData()
                
            } catch {
                // ...
            }
            
            
            
            
        }
    }
        @IBAction func didBackClick(button: UIButton) {
            
             self.navigationController?.popViewControllerAnimated(true)
            
    }
    // MARK: - Table view data source
    
     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
     func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let defaults = NSUserDefaults.standardUserDefaults()
        let  gameMode : String =  defaults.objectForKey("Mode") as! String
        let  view : HeaderView = HeaderView()
        view.frame = CGRectMake(0, 0, tableView.frame.size.width, 45)
        view.drawHeaderFor(gameMode)
        return view
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recordDBArray.count
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("historyCell", forIndexPath: indexPath) as! UITableViewCell
        let dataRecord = self.recordDBArray[indexPath.row] as! NSDictionary
        let  view : HeaderView = HeaderView()
        view.frame = CGRectMake(0, 0, tableView.frame.size.width, 45)
        view.drawRowFor(dataRecord)
        self.view.addSubview(view)
        cell.addSubview(view)
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
       
    }
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true;
    }
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete{
            recordDBArray.removeObjectAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            let rootPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, .UserDomainMask, true)[0]
            var plistPathInDocument:String = String()
            plistPathInDocument = rootPath.stringByAppendingString("/RecordsArray.plist")
            //if !NSFileManager.defaultManager().fileExistsAtPath(plistPathInDocument){
            recordDBArray.writeToFile(plistPathInDocument, atomically: true)
                    
            //}
        }
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
