//
//  MediumGraphView.swift
//  PianoTone
//
//  Created by luv mehta on 29/01/16.
//  Copyright © 2016 luv mehta. All rights reserved.
//

import UIKit

class MediumGraphView: UIView {

    var tribleArray : [CGFloat] = []
    var bassArray : [CGFloat] = []
    var keyCenterArray : [CGFloat] = []
    var cutLineCenterArray : [CGPoint] = []
    var generetedKeyArray : [String] = []
    var buttonArray : NSMutableArray = []
    var sharpButtonArray : NSMutableArray = []
    var lineArray : NSMutableArray = []
    var redlineArray : NSMutableArray = []
    var circleArray : NSMutableArray = []
    var redcircleArray : NSMutableArray = []
    var blockHeight : CGFloat = 0
    var startKeyFromButtonNo : Int = -1
    var indexOfSelectedKey : Int = -1
    var selectedKeyView : UIView = UIView(frame: CGRectMake(0, 0, 0, 0))
    var isViewAdded : Bool = false
    var whichKey : Int = -1
    var diffrence : Int = 0
    
    var cntx = UIGraphicsGetCurrentContext()
    
    override func drawRect(rect: CGRect) {
        
        self.drawUI()
        
        super.drawRect(rect)
    }
    func decreaseSelectedIndex(){
        indexOfSelectedKey -= diffrence
    }
    func animateKey(key : String, withColor: UIColor ){
        
        
        
        
        let myNSString = key as NSString
        if myNSString.length > 2{
            let fisrtChar  = myNSString.substringWithRange(NSRange(location: 0, length: 1))
            let secondChar = myNSString.substringWithRange(NSRange(location: 2, length: 1))
            let secondNumber = Int(secondChar)
            //  NSLog("AnimatedKey=%@ secondNumber=%d", key,secondNumber!)
            if secondNumber >= 6 || secondNumber < 2  {
                return
                
            }
            var firstNumber = 0
            
            switch (fisrtChar) {
            case  "C"  :
                firstNumber = 0
                break
            case "D":
                firstNumber = 1
                break
            case "F":
                firstNumber = 2
                break
            case "G":
                firstNumber = 3
                break
                
            default:
                firstNumber = 4
                break
            }
            
            firstNumber += (secondNumber!-2)*5
            if firstNumber >= buttonArray.count  {
                return
                
            }
            
            let button : UIButton = sharpButtonArray[firstNumber] as! UIButton
            button.backgroundColor = withColor
            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.1 * Double(NSEC_PER_SEC) ))
            dispatch_after(delayTime, dispatch_get_main_queue()){
                let button : UIButton = self.sharpButtonArray[firstNumber] as! UIButton
                button.backgroundColor = UIColor.blackColor()
            }
            
            
            
            
            
        }
        else{
            let fisrtChar  = myNSString.substringWithRange(NSRange(location: 0, length: 1))
            let secondChar = myNSString.substringWithRange(NSRange(location: 1, length: 1))
            let secondNumber = Int(secondChar)
            //     NSLog("AnimatedKey=%@ secondNumber=%d", key,secondNumber!)
            if secondNumber > 6 || secondNumber < 2  {
                return
                
            }
            var firstNumber = 0
            
            switch (fisrtChar) {
            case  "C"  :
                firstNumber = 0
                break
            case "D":
                firstNumber = 1
                break
            case "E":
                firstNumber = 2
                break
            case "F":
                firstNumber = 3
                break
            case "G":
                firstNumber = 4
                break
            case "A":
                firstNumber = 5
                break
            default:
                firstNumber = 6
                break
            }
            
            firstNumber += (secondNumber!-2)*7
            if firstNumber >= buttonArray.count  {
                return
                
            }
            let button : UIButton = buttonArray[firstNumber] as! UIButton
            button.backgroundColor = withColor
            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.1 * Double(NSEC_PER_SEC) ))
            dispatch_after(delayTime, dispatch_get_main_queue()){
                let button : UIButton = self.buttonArray[firstNumber] as! UIButton
                button.backgroundColor = UIColor.whiteColor()
                
                
            }
        }
        // self.drawUI()
        
    }
    
    func deselectKey(){
        /*
        cutLineCenterArray.removeAll()
        generetedKeyArray.removeAll()
        
        for var i=0; i < circleArray.count; ++i{
        let cirlce : UIImageView = circleArray[i] as! UIImageView
        cirlce.removeFromSuperview()
        }
        circleArray.removeAllObjects()
        for var i=0; i < lineArray.count; ++i{
        let line : CAShapeLayer = lineArray[i] as! CAShapeLayer
        line.removeFromSuperlayer()
        }
        lineArray.removeAllObjects()
        for var i=0; i < redcircleArray.count; ++i{
        let cirlce : UIImageView = redcircleArray[i] as! UIImageView
        cirlce.removeFromSuperview()
        }
        redcircleArray.removeAllObjects()
        for var i=0; i < redlineArray.count; ++i{
        let line : CAShapeLayer = redlineArray[i] as! CAShapeLayer
        line.removeFromSuperlayer()
        }
        redlineArray.removeAllObjects()
        generetedKeyArray.removeAll()
        
        for var i=0; i < circleArray.count; ++i{
        let cirlce : UIImageView = circleArray[i] as! UIImageView
        cirlce.removeFromSuperview()
        }
        circleArray.removeAllObjects()
        for var i=0; i < lineArray.count; ++i{
        let line : CAShapeLayer = lineArray[i] as! CAShapeLayer
        line.removeFromSuperlayer()
        }
        lineArray.removeAllObjects()
        
        
        indexOfSelectedKey = 0
        */
        
        
    }
    func selectKey(key : String){
        
      //  NSLog("IndexOfKey=%d", generetedKeyArray.indexOf(key)!)
        
        
        let myNSString = key as NSString
        let fisrtChar  = myNSString.substringWithRange(NSRange(location: 0, length: 1))
        let secondChar = myNSString.substringWithRange(NSRange(location: 1, length: 1))
        let secondNumber = Int(secondChar)
        var firstNumber = 0
        
        switch (fisrtChar) {
        case  "C"  :
            firstNumber = 0
            break
        case "D":
            firstNumber = 1
            break
        case "E":
            firstNumber = 2
            break
        case "F":
            firstNumber = 3
            break
        case "G":
            firstNumber = 4
            break
        case "A":
            firstNumber = 5
            break
        default:
            firstNumber = 6
            break
        }
        
        firstNumber += (secondNumber!-2)*7
        // NSLog("WhichKey=%d,%d", whichKey,indexOfSelectedKey)
        if whichKey == 4 || whichKey == 8{
            ++indexOfSelectedKey;
            diffrence = 3
        }
        else{
            
            diffrence = 2
        }
        ++whichKey
        UIView.animateWithDuration(0.1, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            
            self.selectedKeyView.center = CGPointMake(self.keyCenterArray[self.indexOfSelectedKey + self.startKeyFromButtonNo], self.selectedKeyView.center.y)
            }, completion: nil)
        
        
        if isViewAdded == true{
            
        }
        else{
            self.addSubview(selectedKeyView)
            isViewAdded = true
        }
        
        indexOfSelectedKey += 2
        
    }
    func drawKeysWithArray(keyArray : [String]){
        
        generetedKeyArray.removeAll()
        generetedKeyArray = keyArray
        NSLog("Array=%@", keyArray)
        //whichKey = 0
        for var i=0; i < circleArray.count; ++i{
            let cirlce : UIImageView = circleArray[i] as! UIImageView
            cirlce.removeFromSuperview()
        }
        circleArray.removeAllObjects()
        for var i=0; i < lineArray.count; ++i{
            let line : CAShapeLayer = lineArray[i] as! CAShapeLayer
            line.removeFromSuperlayer()
        }
        lineArray.removeAllObjects()
        let rect = self.frame
        var blockWidth : CGFloat = (rect.size.width-30)/29
        var blockWidth1 : CGFloat = (rect.size.height-blockHeight*24-5)
        NSLog("Index=%d", startKeyFromButtonNo)
        var sequenceIndex = startKeyFromButtonNo
        indexOfSelectedKey = 0
        for var i = 0; i < keyArray.count; ++i{
            var keyStr = keyArray[i]
            let myNSString = keyStr as NSString
            let fisrtChar  = myNSString.substringWithRange(NSRange(location: 0, length: 1))
            let secondChar = myNSString.substringWithRange(NSRange(location: 1, length: 1))
            let secondNumber = Int(secondChar)
            var firstNumber = 0
            var rowIndex = 0
            switch (fisrtChar) {
            case  "C"  :
                firstNumber = 0
                break
            case "D":
                firstNumber = 1
                break
            case "E":
                firstNumber = 2
                break
            case "F":
                firstNumber = 3
                break
            case "G":
                firstNumber = 4
                break
            case "A":
                firstNumber = 5
                break
            default:
                firstNumber = 6
                break
            }
            
            firstNumber += (secondNumber!-2)*7
            
            
            let imageName = "notes.png"
            let image = UIImage(named: imageName)
            let imageView = UIImageView(image: image!)
            imageView.frame = CGRect(x: 0, y: 0, width: 9*blockWidth/16, height: 9*blockWidth/16)
            imageView.center = getNoteCenter(firstNumber,sequenceNo: sequenceIndex)
            sequenceIndex += 2
            self.addSubview(imageView)
            circleArray.addObject(imageView)
            let shape = CAShapeLayer()
            
            self.layer.addSublayer(shape)
            shape.opacity = 1.0
            shape.lineWidth = 2
            shape.lineJoin = kCALineJoinMiter
            
            shape.strokeColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).CGColor
            shape.fillColor = UIColor.clearColor().CGColor
            
            let path = UIBezierPath()
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            if appDelegate.isMediumOnTrible == false{
            if firstNumber < 8 || firstNumber == 17 || firstNumber == 18 || firstNumber == 19  {
                path.moveToPoint(CGPointMake(imageView.frame.origin.x+imageView.frame.size.width-1, imageView.center.y-3*blockHeight))
                path.addLineToPoint(CGPointMake(imageView.frame.origin.x+imageView.frame.size.width-1,  imageView.center.y))
            }
            else{
                path.moveToPoint(CGPointMake(imageView.frame.origin.x,  imageView.center.y))
                path.addLineToPoint(CGPointMake(imageView.frame.origin.x, imageView.center.y+3*blockHeight ))
            }
            }
            else{
                if firstNumber < 8 || (firstNumber >= 12 && firstNumber <= 19 )  {
                    path.moveToPoint(CGPointMake(imageView.frame.origin.x+imageView.frame.size.width-1, imageView.center.y-3*blockHeight))
                    path.addLineToPoint(CGPointMake(imageView.frame.origin.x+imageView.frame.size.width-1,  imageView.center.y))
                }
                else{
                    path.moveToPoint(CGPointMake(imageView.frame.origin.x,  imageView.center.y))
                    path.addLineToPoint(CGPointMake(imageView.frame.origin.x, imageView.center.y+3*blockHeight ))
                }
            }
            
            
            for var i = 0; i < cutLineCenterArray.count; ++i{
                var lineCenter : CGPoint = cutLineCenterArray[i]
                path.moveToPoint(CGPointMake(lineCenter.x - imageView.frame.size.width/2-2,  lineCenter.y))
                path.addLineToPoint(CGPointMake( lineCenter.x + imageView.frame.size.width/2 + 3,  lineCenter.y ))
            }
            shape.path = path.CGPath
            
            lineArray.addObject(shape)
            let shape1 = CAShapeLayer()
            
            self.layer.addSublayer(shape1)
            shape1.opacity = 1
            shape1.lineWidth = 2
            shape1.lineDashPhase = 1.0
            shape1.lineJoin = kCALineJoinMiter
            
            shape1.strokeColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4).CGColor
            shape1.fillColor = UIColor.clearColor().CGColor
           
            let path1 = UIBezierPath()
            // CGRectMake(0, 2,blockWidth, self.frame.size.height-blockWidth1-9)
            if i==3 || i==7{
                sequenceIndex += 1
                let nextCenter : CGPoint = getNoteCenter(firstNumber,sequenceNo: sequenceIndex)
                let fromX : CGFloat = (imageView.center.x+nextCenter.x)/2
                if firstNumber < 14 {
                    path1.moveToPoint(CGPointMake(fromX,  2))
                    path1.addLineToPoint(CGPointMake(fromX,  self.frame.size.height-blockWidth1-9 ))
                    
                    
                    //                    path1.moveToPoint(CGPointMake(fromX,  12*blockHeight))
                    //                    path1.addLineToPoint(CGPointMake(fromX,  20*blockHeight ))
                    
                    
                }
                else{
                    path1.moveToPoint(CGPointMake(fromX,  2))
                    path1.addLineToPoint(CGPointMake(fromX,  self.frame.size.height-blockWidth1-9 ))
                    //                    path1.moveToPoint(CGPointMake(fromX,  blockHeight))
                    //                    path1.addLineToPoint(CGPointMake(fromX,  9*blockHeight ))
                    
                }
                
                
            }
            shape1.path = path1.CGPath
            lineArray.addObject(shape1)

            
            
        }
        NSLog("Good")
        
        
    }
    
    func drawUI(){
        for var i=0; i < circleArray.count; ++i{
            let cirlce : UIImageView = circleArray[i] as! UIImageView
            cirlce.removeFromSuperview()
        }
        circleArray.removeAllObjects()
        for var i=0; i < buttonArray.count; ++i{
            let button : UIButton = buttonArray[i] as! UIButton
            button.removeFromSuperview()
        }
        buttonArray.removeAllObjects()
        tribleArray.removeAll()
        bassArray.removeAll()
        keyCenterArray.removeAll()
        let rect = self.frame
        // Drawing code
        // Drawing the vertical line
        cntx = UIGraphicsGetCurrentContext()
        //        CGContextSetRGBStrokeColor(cntx, 179.0/255, 179.0/255, 179.0/255, 1.0)
        CGContextSetRGBStrokeColor(cntx, 0, 0, 0, 1.0)
        CGContextSetLineWidth(cntx, 1.6)
        blockHeight = rect.size.height/(9+2+9+12)
        tribleArray.append( blockHeight * CGFloat(0))
        for var i = 1; i < 10; i++ {
            
            tribleArray.append( blockHeight * CGFloat(i))
        }
        
        for var i = 3; i < 8; i++ {
            CGContextMoveToPoint(cntx, 0, blockHeight * CGFloat(i))
            CGContextAddLineToPoint(cntx,rect.size.width , blockHeight * CGFloat(i))
            
        }
        let imageName = "tribble.png"
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        // imageView.backgroundColor = UIColor.grayColor()
        
        let imgWidth = CGFloat((blockHeight * CGFloat(8)-blockHeight * CGFloat(2)))*((image?.size.width)!/(image?.size.height)!)
        
        imageView.frame = CGRect(x: 20, y: blockHeight * CGFloat(2), width: imgWidth , height: blockHeight * CGFloat(8)-blockHeight * CGFloat(2))
        //imageView.contentMode = UIViewContentMode.ScaleAspectFit
        self.addSubview(imageView)
        bassArray.append( blockHeight * CGFloat(0))
        for var i = 12; i < 21; i++ {
            
            bassArray.append( blockHeight * CGFloat(i))
        }
        for var i = 14; i < 19; i++ {
            CGContextMoveToPoint(cntx, 0, blockHeight * CGFloat(i))
            CGContextAddLineToPoint(cntx,rect.size.width , blockHeight * CGFloat(i))
            
        }
        let imageName1 = "bass.png"
        let image1 = UIImage(named: imageName1)
        let imageView1 = UIImageView(image: image1)
        // imageView1.backgroundColor = UIColor.grayColor()
        let imgWidth1 = CGFloat((blockHeight * CGFloat(6.3)-blockHeight * CGFloat(3)))*((image1?.size.width)!/(image1?.size.height)!)
        imageView1.frame = CGRect(x: 20, y: blockHeight * CGFloat(13.9), width: imgWidth1, height: blockHeight * CGFloat(17.3)-blockHeight * CGFloat(14))
        // imageView1.contentMode = UIViewContentMode.ScaleAspectFit
        self.addSubview(imageView1)
        let  diffWidth = (imageView1.frame.size.width - imageView.frame.size.width) as CGFloat
        if diffWidth != 0{
            var rect = imageView.frame as CGRect
            rect.origin.x += diffWidth
            imageView.frame = rect
            
        }
        let deviceText = UIDevice.currentDevice().model
        NSLog("Device = %@", deviceText)
        
        if (UIDevice.currentDevice().model.rangeOfString("iPad") != nil) {
            print("I AM IPAD!")
            var rect = imageView.frame as CGRect
            rect.origin.x -= 8
            imageView.frame = rect
            
            rect = imageView1.frame as CGRect
            rect.origin.x -= 8
            imageView1.frame = rect
        } else {
            
            print("I AM IPHONE")
            var rect = imageView.frame as CGRect
            rect.origin.x -= 10
            imageView.frame = rect
            
            rect = imageView1.frame as CGRect
            rect.origin.x -= 10
            imageView1.frame = rect
        }
        var blockWidth : CGFloat = (rect.size.width-30)/29
        var blockWidth1 : CGFloat = (rect.size.height-blockHeight*24-5)
        
        //selectedKeyView = UIView(frame: CGRectMake(0, 2,blockWidth, self.frame.size.height-blockWidth1-9))
        selectedKeyView.frame = CGRectMake(0, 2,blockWidth, self.frame.size.height-blockWidth1-9)
        selectedKeyView.backgroundColor = UIColor.lightGrayColor()
        selectedKeyView.alpha = 0.3
        selectedKeyView.tag = -1
        selectedKeyView.layer.cornerRadius = 5
        selectedKeyView.layer.borderWidth = 3
        selectedKeyView.layer.borderColor = UIColor.darkGrayColor().CGColor
        for var i = 0; i < 29; i++ {
            let button   = UIButton(type: UIButtonType.System) as UIButton
            button.frame = CGRectMake(CGFloat(15.0)+blockWidth*CGFloat((i)), blockHeight*24, blockWidth, blockWidth1)
            
            button.backgroundColor = UIColor.whiteColor()
            button.layer.cornerRadius = 5
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.blackColor().CGColor
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
            button.titleLabel!.font.fontWithSize(5)
            
            self.addSubview(button)
            buttonArray.addObject(button)
            var label = UILabel(frame: CGRectMake(button.frame.origin.x+10, button.frame.origin.y+blockWidth1-30, blockWidth1/2, 20))
            label.font = UIFont(name: label.font.fontName, size: 10)
            //label.backgroundColor = UIColor.redColor()
            //label.textAlignment = NSTextAlignment.Center
            label.text = getKeyTitle(i)
            label.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI/2))
            label.center = CGPointMake(button.center.x, button.center.y+blockWidth1/4-5)
            keyCenterArray.append(button.center.x)
            self.addSubview(label)
            
        }
        for var i = 0; i < keyCenterArray.count; ++i{
            let btnCenter = keyCenterArray[i]
            if btnCenter > imgWidth1{
                startKeyFromButtonNo = i + 2
                break
            }
        }
        if (UIDevice.currentDevice().model.rangeOfString("iPad") != nil) {
            startKeyFromButtonNo -= 1
        }
        for var i = 1; i < 29; i++ {
            if i==3 || i==7 || i==10 || i==14 || i==17 || i==21 || i==24 || i==28 {
                continue
            }
            let button   = UIButton(type: UIButtonType.System) as UIButton
            button.frame = CGRectMake(15+blockWidth*CGFloat((i))-3*blockWidth/8, blockHeight*24, 3*blockWidth/4, blockWidth1/2)
            button.backgroundColor = UIColor.blackColor()
            button.layer.cornerRadius = 5
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.blackColor().CGColor
            sharpButtonArray.addObject(button)
            self.addSubview(button)
            
        }
        
        CGContextStrokePath(cntx)
        
        
    }
    func getKeyTitle(keyNo : Int)->String{
        
        let keyNameNo = keyNo % 7
        let keySuffixNo = keyNo / 7 + 2
        var keyName : String = ""
        
        switch (keyNameNo) {
        case 0:
            keyName = String(format: "C%d",keySuffixNo)
            break
        case 1:
            keyName = String(format: "D%d",keySuffixNo)
            break
        case 2:
            keyName = String(format: "E%d",keySuffixNo)
            break
        case 3:
            keyName = String(format: "F%d",keySuffixNo)
            break
        case 4:
            keyName = String(format: "G%d",keySuffixNo)
            break
        case 5:
            keyName = String(format: "A%d",keySuffixNo)
            break
        default:
            keyName = String(format: "B%d",keySuffixNo)
            break
        }
        
        return keyName
    }
    func getNoteCenter(keyNo : Int,sequenceNo : Int)->CGPoint{
        
      let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if appDelegate.isMediumOnTrible == false{
        var keyCenter : CGPoint = CGPointZero
        var cutLineArray : [CGPoint] = []
        switch (keyNo) {
            
        case 0:
            keyCenter = CGPointMake(keyCenterArray[sequenceNo], bassArray[9])
            cutLineArray.append(CGPointMake(keyCenterArray[sequenceNo], bassArray[9]))
            cutLineArray.append(CGPointMake(keyCenterArray[sequenceNo], bassArray[8]))
            break
        case 1:
            keyCenter = CGPointMake(keyCenterArray[sequenceNo], (bassArray[9]+bassArray[8])/2)
            cutLineArray.append(CGPointMake(keyCenterArray[sequenceNo], bassArray[8]))
            break
        case 2:
            keyCenter = CGPointMake(keyCenterArray[sequenceNo], bassArray[8])
            cutLineArray.append(CGPointMake(keyCenterArray[sequenceNo], bassArray[8]))
            break
        case 3:
            keyCenter = CGPointMake(keyCenterArray[sequenceNo], (bassArray[8]+bassArray[7])/2)
            break
        case 4:
            keyCenter = CGPointMake(keyCenterArray[sequenceNo], bassArray[7])
            break
        case 5:
            keyCenter = CGPointMake(keyCenterArray[sequenceNo], (bassArray[7]+bassArray[6])/2)
            break
        case 6:
            keyCenter = CGPointMake(keyCenterArray[sequenceNo], bassArray[6])
            break
        case 7:
            keyCenter = CGPointMake(keyCenterArray[sequenceNo], (bassArray[6]+bassArray[5])/2)
            break
        case 8:
            keyCenter = CGPointMake(keyCenterArray[sequenceNo], bassArray[5])
            break
        case 9:
            keyCenter = CGPointMake(keyCenterArray[sequenceNo], (bassArray[5]+bassArray[4])/2)
            break
        case 10:
            keyCenter = CGPointMake(keyCenterArray[sequenceNo], bassArray[4])
            break
        case 11:
            keyCenter = CGPointMake(keyCenterArray[sequenceNo], (bassArray[4]+bassArray[3])/2)
            break
        case 12:
            keyCenter = CGPointMake(keyCenterArray[sequenceNo], bassArray[3])
            break
        case 13:
            keyCenter = CGPointMake(keyCenterArray[sequenceNo], (bassArray[3]+bassArray[2])/2)
            break
            
        case 14:
            keyCenter = CGPointMake(keyCenterArray[sequenceNo], bassArray[2])
            cutLineArray.append(CGPointMake(keyCenterArray[sequenceNo], bassArray[2]))
            break
        case 15:
             keyCenter = CGPointMake(keyCenterArray[sequenceNo], (bassArray[2]+bassArray[1])/2)
            cutLineArray.append(CGPointMake(keyCenterArray[sequenceNo], bassArray[2]))
            break
        case 16:
             keyCenter = CGPointMake(keyCenterArray[sequenceNo], bassArray[1])
            cutLineArray.append(CGPointMake(keyCenterArray[sequenceNo], bassArray[2]))
             cutLineArray.append(CGPointMake(keyCenterArray[sequenceNo], bassArray[1]))
            break
        case 17:
            keyCenter = CGPointMake(keyCenterArray[sequenceNo], (tribleArray[7]+tribleArray[6])/2)
            break
        case 18:
            keyCenter = CGPointMake(keyCenterArray[sequenceNo], tribleArray[6])
            break
        case 19:
            keyCenter = CGPointMake(keyCenterArray[sequenceNo], (tribleArray[6]+tribleArray[5])/2)
            break
        case 20:
            keyCenter = CGPointMake(keyCenterArray[sequenceNo], tribleArray[5])
            break
        case 21:
            keyCenter = CGPointMake(keyCenterArray[sequenceNo], (tribleArray[5]+tribleArray[4])/2)
            break
        case 22:
            keyCenter = CGPointMake(keyCenterArray[sequenceNo], tribleArray[4])
            break
        case 23:
            keyCenter = CGPointMake(keyCenterArray[sequenceNo], (tribleArray[4]+tribleArray[3])/2)
            break
        case 24:
            keyCenter = CGPointMake(keyCenterArray[sequenceNo], tribleArray[3])
            break
        case 25:
            keyCenter = CGPointMake(keyCenterArray[sequenceNo], (tribleArray[3]+tribleArray[2])/2)
            break
        case 26:
            keyCenter = CGPointMake(keyCenterArray[sequenceNo], tribleArray[2])
            cutLineArray.append(CGPointMake(keyCenterArray[sequenceNo], tribleArray[2]))
            break
        case 27:
            keyCenter = CGPointMake(keyCenterArray[sequenceNo], (tribleArray[2]+tribleArray[1])/2)
            cutLineArray.append(CGPointMake(keyCenterArray[sequenceNo], tribleArray[2]))
            break
            
        default:
            keyCenter = CGPointMake(keyCenterArray[sequenceNo], tribleArray[1] )
            cutLineArray.append(CGPointMake(keyCenterArray[sequenceNo], tribleArray[1]))
            cutLineArray.append(CGPointMake(keyCenterArray[sequenceNo], tribleArray[2]))
            break
            
        }
        cutLineCenterArray.removeAll()
        if cutLineArray.count > 0{
            for i in 0...cutLineArray.count-1 {
                cutLineCenterArray.append(cutLineArray[i])
            }
        }
        return keyCenter
        }
        else{
            var keyCenter : CGPoint = CGPointZero
            var cutLineArray : [CGPoint] = []
            switch (keyNo) {
                
            case 0:
                keyCenter = CGPointMake(keyCenterArray[sequenceNo], bassArray[9])
                cutLineArray.append(CGPointMake(keyCenterArray[sequenceNo], bassArray[9]))
                cutLineArray.append(CGPointMake(keyCenterArray[sequenceNo], bassArray[8]))
                break
            case 1:
                keyCenter = CGPointMake(keyCenterArray[sequenceNo], (bassArray[9]+bassArray[8])/2)
                cutLineArray.append(CGPointMake(keyCenterArray[sequenceNo], bassArray[8]))
                break
            case 2:
                keyCenter = CGPointMake(keyCenterArray[sequenceNo], bassArray[8])
                cutLineArray.append(CGPointMake(keyCenterArray[sequenceNo], bassArray[8]))
                break
            case 3:
                keyCenter = CGPointMake(keyCenterArray[sequenceNo], (bassArray[8]+bassArray[7])/2)
                break
            case 4:
                keyCenter = CGPointMake(keyCenterArray[sequenceNo], bassArray[7])
                break
            case 5:
                keyCenter = CGPointMake(keyCenterArray[sequenceNo], (bassArray[7]+bassArray[6])/2)
                break
            case 6:
                keyCenter = CGPointMake(keyCenterArray[sequenceNo], bassArray[6])
                break
            case 7:
                keyCenter = CGPointMake(keyCenterArray[sequenceNo], (bassArray[6]+bassArray[5])/2)
                break
            case 8:
                keyCenter = CGPointMake(keyCenterArray[sequenceNo], bassArray[5])
                break
            case 9:
                keyCenter = CGPointMake(keyCenterArray[sequenceNo], (bassArray[5]+bassArray[4])/2)
                break
            case 10:
                keyCenter = CGPointMake(keyCenterArray[sequenceNo], bassArray[4])
                break
            case 11:
                keyCenter = CGPointMake(keyCenterArray[sequenceNo], (bassArray[4]+bassArray[3])/2)
                break
            case 12:
                keyCenter = CGPointMake(keyCenterArray[sequenceNo], tribleArray[9])
                cutLineArray.append(CGPointMake(keyCenterArray[sequenceNo], tribleArray[9]))
                cutLineArray.append(CGPointMake(keyCenterArray[sequenceNo], tribleArray[8]))
                break
            case 13:
                keyCenter = CGPointMake(keyCenterArray[sequenceNo], (tribleArray[9]+tribleArray[8])/2)
                cutLineArray.append(CGPointMake(keyCenterArray[sequenceNo], tribleArray[8]))
                break
                
            case 14:
                keyCenter = CGPointMake(keyCenterArray[sequenceNo], tribleArray[8])
                cutLineArray.append(CGPointMake(keyCenterArray[sequenceNo], tribleArray[8]))
                break
            case 15:
                keyCenter = CGPointMake(keyCenterArray[sequenceNo], (tribleArray[8]+tribleArray[7])/2)
                
                break
            case 16:
                keyCenter = CGPointMake(keyCenterArray[sequenceNo], tribleArray[7])
                break
            case 17:
                keyCenter = CGPointMake(keyCenterArray[sequenceNo], (tribleArray[7]+tribleArray[6])/2)
                break
            case 18:
                keyCenter = CGPointMake(keyCenterArray[sequenceNo], tribleArray[6])
                break
            case 19:
                keyCenter = CGPointMake(keyCenterArray[sequenceNo], (tribleArray[6]+tribleArray[5])/2)
                break
            case 20:
                keyCenter = CGPointMake(keyCenterArray[sequenceNo], tribleArray[5])
                break
            case 21:
                keyCenter = CGPointMake(keyCenterArray[sequenceNo], (tribleArray[5]+tribleArray[4])/2)
                break
            case 22:
                keyCenter = CGPointMake(keyCenterArray[sequenceNo], tribleArray[4])
                break
            case 23:
                keyCenter = CGPointMake(keyCenterArray[sequenceNo], (tribleArray[4]+tribleArray[3])/2)
                break
            case 24:
                keyCenter = CGPointMake(keyCenterArray[sequenceNo], tribleArray[3])
                break
            case 25:
                keyCenter = CGPointMake(keyCenterArray[sequenceNo], (tribleArray[3]+tribleArray[2])/2)
                break
            case 26:
                keyCenter = CGPointMake(keyCenterArray[sequenceNo], tribleArray[2])
                cutLineArray.append(CGPointMake(keyCenterArray[sequenceNo], tribleArray[2]))
                break
            case 27:
                keyCenter = CGPointMake(keyCenterArray[sequenceNo], (tribleArray[2]+tribleArray[1])/2)
                cutLineArray.append(CGPointMake(keyCenterArray[sequenceNo], tribleArray[2]))
                break
                
            default:
                keyCenter = CGPointMake(keyCenterArray[sequenceNo], tribleArray[1] )
                cutLineArray.append(CGPointMake(keyCenterArray[sequenceNo], tribleArray[1]))
                cutLineArray.append(CGPointMake(keyCenterArray[sequenceNo], tribleArray[2]))
                break
                
            }
            cutLineCenterArray.removeAll()
            if cutLineArray.count > 0{
                for i in 0...cutLineArray.count-1 {
                    cutLineCenterArray.append(cutLineArray[i])
                }
            }
            return keyCenter

        }
        //return CGPointZero
    }
    func getRedNoteCenter(keyNo : Int,sequenceNo : Int)->CGPoint{
        
        var keyCenter : CGPoint = CGPointZero
        
        switch (keyNo) {
            
        case 0:
            keyCenter = CGPointMake(keyCenterArray[sequenceNo], bassArray[9])
            
            break
        case 1:
            keyCenter = CGPointMake(keyCenterArray[sequenceNo], (bassArray[9]+bassArray[8])/2)
            
            break
        case 2:
            keyCenter = CGPointMake(keyCenterArray[sequenceNo], bassArray[8])
            
            break
        case 3:
            keyCenter = CGPointMake(keyCenterArray[sequenceNo], (bassArray[8]+bassArray[7])/2)
            break
        case 4:
            keyCenter = CGPointMake(keyCenterArray[sequenceNo], bassArray[7])
            break
        case 5:
            keyCenter = CGPointMake(keyCenterArray[sequenceNo], (bassArray[7]+bassArray[6])/2)
            break
        case 6:
            keyCenter = CGPointMake(keyCenterArray[sequenceNo], bassArray[6])
            break
        case 7:
            keyCenter = CGPointMake(keyCenterArray[sequenceNo], (bassArray[6]+bassArray[5])/2)
            break
        case 8:
            keyCenter = CGPointMake(keyCenterArray[sequenceNo], bassArray[5])
            break
        case 9:
            keyCenter = CGPointMake(keyCenterArray[sequenceNo], (bassArray[5]+bassArray[4])/2)
            break
        case 10:
            keyCenter = CGPointMake(keyCenterArray[sequenceNo], bassArray[4])
            break
        case 11:
            keyCenter = CGPointMake(keyCenterArray[sequenceNo], (bassArray[4]+bassArray[3])/2)
            break
        case 12:
            keyCenter = CGPointMake(keyCenterArray[sequenceNo], bassArray[3])
            break
        case 13:
            keyCenter = CGPointMake(keyCenterArray[sequenceNo], (bassArray[3]+bassArray[2])/2)
            break
        case 14:
            keyCenter = CGPointMake(keyCenterArray[sequenceNo], tribleArray[8])
            
            break
        case 15:
            keyCenter = CGPointMake(keyCenterArray[sequenceNo], (tribleArray[8]+tribleArray[7])/2)
            break
        case 16:
            keyCenter = CGPointMake(keyCenterArray[sequenceNo], tribleArray[7])
            break
        case 17:
            keyCenter = CGPointMake(keyCenterArray[sequenceNo], (tribleArray[7]+tribleArray[6])/2)
            break
        case 18:
            keyCenter = CGPointMake(keyCenterArray[sequenceNo], tribleArray[6])
            break
        case 19:
            keyCenter = CGPointMake(keyCenterArray[sequenceNo], (tribleArray[6]+tribleArray[5])/2)
            break
        case 20:
            keyCenter = CGPointMake(keyCenterArray[sequenceNo], tribleArray[5])
            break
        case 21:
            keyCenter = CGPointMake(keyCenterArray[sequenceNo], (tribleArray[5]+tribleArray[4])/2)
            break
        case 22:
            keyCenter = CGPointMake(keyCenterArray[sequenceNo], tribleArray[4])
            break
        case 23:
            keyCenter = CGPointMake(keyCenterArray[sequenceNo], (tribleArray[4]+tribleArray[3])/2)
            break
        case 24:
            keyCenter = CGPointMake(keyCenterArray[sequenceNo], tribleArray[3])
            break
        case 25:
            keyCenter = CGPointMake(keyCenterArray[sequenceNo], (tribleArray[3]+tribleArray[2])/2)
            break
        case 26:
            keyCenter = CGPointMake(keyCenterArray[sequenceNo], tribleArray[2])
            
            break
        case 27:
            keyCenter = CGPointMake(keyCenterArray[sequenceNo], (tribleArray[2]+tribleArray[1])/2)
            
            break
            
        default:
            keyCenter = CGPointMake(keyCenterArray[sequenceNo], tribleArray[1] )
            
            break
            
        }
        return keyCenter
    }


}
