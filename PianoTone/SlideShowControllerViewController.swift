//
//  SlideShowControllerViewController.swift
//  PianoTone
//
//  Created by luv mehta on 01/02/16.
//  Copyright © 2016 luv mehta. All rights reserved.
//

import UIKit

class SlideShowControllerViewController: UIViewController,UIScrollViewDelegate {
    @IBOutlet    var slideScrollView: UIScrollView?
    @IBOutlet    var leftButton: UIButton?
    @IBOutlet    var rightButton: UIButton?
    @IBOutlet    var doneButton: UIButton?
    @IBOutlet    var loadingLabel: UILabel?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       
        leftButton?.hidden = true
        rightButton?.hidden = true
        doneButton?.layer.masksToBounds = true
        doneButton?.layer.cornerRadius = 5.0
        doneButton?.layer.borderWidth = 1.0
        doneButton?.layer.borderColor = UIColor.whiteColor().CGColor
    }
    override func viewDidAppear(animated: Bool){
        
        doneButton?.layer.masksToBounds = true
        doneButton?.layer.cornerRadius = 5.0
        doneButton?.layer.borderWidth = 1.0
        doneButton?.layer.borderColor = UIColor.whiteColor().CGColor
        slideScrollView!.translatesAutoresizingMaskIntoConstraints = false
        for i in 0 ..< 6{
            
            
            if i == 0{
                let imageName1 = "p.jpg"
                let image1 = UIImage(named: imageName1)
                let imgView : UIImageView = UIImageView(image:image1!)
                imgView.contentMode = UIViewContentMode.ScaleAspectFit
                imgView.frame = CGRectMake((slideScrollView?.frame.size.width)! * CGFloat( i) , 0, (slideScrollView?.frame.size.width)!, (slideScrollView?.frame.size.height)!)
                slideScrollView?.addSubview(imgView)
                // NSLog("SelfSize=%@,Size=%@", NSStringFromCGSize(<#T##size: CGSize##CGSize#>))
            }
                
            else{
                let imageName1 = String(format: "p%d.jpg", i)
                let image1 = UIImage(named: imageName1)
                let imgView : UIImageView = UIImageView(image:image1)
                 imgView.contentMode = UIViewContentMode.ScaleAspectFit
                imgView.frame = CGRectMake((slideScrollView?.frame.size.width)! * CGFloat( i) , 0, (slideScrollView?.frame.size.width)!, (slideScrollView?.frame.size.height)!)
                slideScrollView?.addSubview(imgView)
            }
        }
        slideScrollView?.contentSize = CGSizeMake((slideScrollView?.frame.size.width)! * CGFloat( 6), (slideScrollView?.frame.size.height)! )
        slideScrollView?.contentOffset = CGPoint(x: 0, y: 0)
        loadingLabel?.hidden = true
        rightButton?.hidden = false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: resizeImage method
     func scaleUIImageToSize(let image: UIImage, let size: CGSize) -> UIImage {
        let hasAlpha = false
        let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
        
        UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
        image.drawInRect(CGRect(origin: CGPointZero, size: size))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage
    }
    @IBAction func didBackClick(button: UIButton) {
        
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    @IBAction func didLeftClick(button: UIButton) {
        
        let screenNo : Int = Int(slideScrollView!.contentOffset.x / slideScrollView!.frame.size.width) - 1
        
        if screenNo < 0 {
            return
        }
        UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            
            self.slideScrollView?.contentOffset = CGPoint(x: CGFloat( screenNo) * self.slideScrollView!.frame.size.width  , y: 0)
            }, completion: nil)

        
    }
    @IBAction func didRightClick(button: UIButton) {
        
        let screenNo : Int = Int(slideScrollView!.contentOffset.x / slideScrollView!.frame.size.width) + 1
        
        if screenNo > 5 {
            return
        }
        UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            
            self.slideScrollView?.contentOffset = CGPoint(x: CGFloat( screenNo) * self.slideScrollView!.frame.size.width  , y: 0)
            }, completion: nil)

       
        
        
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        var screenNo = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        
        if screenNo == 0{
          leftButton?.hidden = true
          rightButton?.hidden = false
        }
        else if screenNo == 5{
            leftButton?.hidden = false
            rightButton?.hidden = true
        }
        else if screenNo > 0 && screenNo < 5{
            leftButton?.hidden = false
            rightButton?.hidden = false
            
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
