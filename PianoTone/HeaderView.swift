//
//  HeaderView.swift
//  PianoTone
//
//  Created by luv mehta on 06/01/16.
//  Copyright © 2016 luv mehta. All rights reserved.
//

import UIKit

class HeaderView: UIView {
    var noOfCollumn : Int = 0
    var headArray : [String] = []
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
                super.drawRect(rect)
        let rect = self.frame
        let colWidth : CGFloat = rect.size.width / CGFloat(noOfCollumn)
        
        // Drawing code
        // Drawing the vertical line
        let cntx = UIGraphicsGetCurrentContext()
        
        CGContextSetRGBStrokeColor(cntx, 1, 1, 1, 1.0)
        CGContextSetLineWidth(cntx, 1.6)
        
        CGContextMoveToPoint(cntx, 0, 0)
        CGContextAddLineToPoint(cntx,rect.size.width , 0)
        
        CGContextMoveToPoint(cntx, 0, rect.size.height)
        CGContextAddLineToPoint(cntx,rect.size.width , rect.size.height)
        
        for var i = 0; i <= noOfCollumn; i++ {
            CGContextMoveToPoint(cntx,  colWidth * CGFloat(i),0)
            CGContextAddLineToPoint(cntx,colWidth * CGFloat(i) , rect.size.height)
            
        }
        for var i = 0; i < noOfCollumn; i++ {
            let labelFrame : CGRect = CGRectMake(colWidth * CGFloat(i)+5, 1, colWidth-5, 30)
            let label = UILabel(frame: labelFrame)
            label.font = UIFont(name: label.font.fontName, size: 17)
            label.textColor = UIColor.whiteColor()
            label.textAlignment = .Center
            label.text = headArray[i]
            label.adjustsFontSizeToFitWidth=true
            label.minimumScaleFactor=0.5
            self.addSubview(label)
            
        }
        CGContextStrokePath(cntx)

    }
    func drawHeaderFor(modeStr : String){
        //self.drawRect(self.frame)
        
       
        if modeStr == "Challenge"{
            noOfCollumn = 7
            headArray.append("Date")
            headArray.append("Right")
            headArray.append("Wrong")
            headArray.append("Remain")
            headArray.append("Score")
            headArray.append("Mode")
            headArray.append("Level")
         }
        else{
            noOfCollumn = 6
            headArray.append("Date")
            headArray.append("Right")
            
            headArray.append("Remain")
            headArray.append("Score")
            headArray.append("Mode")
            headArray.append("Level")
        }
        
        
        
    }
    func drawRowFor(rowDict : NSDictionary){
        
        let modeStr : String = rowDict["Mode"] as! String
        let levelStr : String = rowDict["Level"] as! String
        let dateRecord = rowDict["Date"] as! NSDate!
        let rightNo = rowDict["Right"] as! Int
        let wrongNo = rowDict["Wrong"] as! Int
        let remainNo = rowDict["Remain"] as! Int
        let scoreNo = rowDict["Score"] as! Int
        if modeStr == "Challenge"{
            noOfCollumn = 7
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy" // superset of OP's format
            let str = dateFormatter.stringFromDate(dateRecord)
            headArray.append(str)

            headArray.append(String(format:"%d",rightNo))
            headArray.append(String(format:"%d",wrongNo))
            headArray.append(String(format:"%d",remainNo))
            headArray.append(String(format:"%d",scoreNo))
            headArray.append(modeStr)
            headArray.append(levelStr)
        }
        else{
            noOfCollumn = 6
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy" // superset of OP's format
            let str = dateFormatter.stringFromDate(dateRecord)
            headArray.append(str)
            headArray.append(String(format:"%d",rightNo))
            
            headArray.append(String(format:"%d",remainNo))
            headArray.append(String(format:"%d",scoreNo))
            headArray.append(modeStr)
            headArray.append(levelStr)
        }
        
    // self.drawRect(self.frame)
   //  self.backgroundColor = UIColor.blackColor()
    }

}
