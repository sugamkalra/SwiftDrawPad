//
//  ViewController.swift
//  PTPDrawImageAnnotationDemo
//
//  Created by Sugam Kalra on 08/01/16.
//  Copyright © 2016 Sugam Kalra. All rights reserved.
//

import UIKit

class PTPDrawImagePadViewController: UIViewController
{
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var tempImageView: UIImageView!
    
    var lastPoint = CGPoint.zero
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    var brushWidth: CGFloat = 10.0
    var opacity: CGFloat = 1.0
    var swiped = false
    
    // This is the colors array to display various color pencils
    
    let colors: [(CGFloat, CGFloat, CGFloat)] = [
        (0, 0, 0),
        (105.0 / 255.0, 105.0 / 255.0, 105.0 / 255.0),
        (1.0, 0, 0),
        (0, 0, 1.0),
        (51.0 / 255.0, 204.0 / 255.0, 1.0),
        (102.0 / 255.0, 204.0 / 255.0, 0),
        (102.0 / 255.0, 1.0, 0),
        (160.0 / 255.0, 82.0 / 255.0, 45.0 / 255.0),
        (1.0, 102.0 / 255.0, 0),
        (1.0, 1.0, 0),
        (1.0, 1.0, 1.0),
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    // MARK: - Actions
    
    // This Method will reset the draw pad and erase all annotations made
    
    @IBAction func reset(sender: AnyObject)
    {
        mainImageView.image = UIImage(named: "Happy_Face_600x600")
    }
    
    
    
    // This method will share the image via Activity Window
    
    @IBAction func share(sender: AnyObject)
    {
        // This is the code to take a snapshot of the drawn annotation on the draw pad
        
        UIGraphicsBeginImageContext(mainImageView.bounds.size)
        mainImageView.image?.drawInRect(CGRect(x: 0, y: 0,
            width: mainImageView.frame.size.width, height: mainImageView.frame.size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Activity Window to share the image
        
        let activity = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        presentViewController(activity, animated: true, completion: nil)
    }
    
    
    // This method will provide you to press any color pencil and according to the button tag it chooses the RGB values corresponding to that color of pencil
    
    @IBAction func pencilPressed(sender: AnyObject) {
        
        var index = sender.tag ?? 0
        if index < 0 || index >= colors.count {
            index = 0
        }
        
        (red, green, blue) = colors[index]
        
        if index == colors.count - 1
        {
            opacity = 1.0
            
        }
    }
    
    
    // This is the touches began method
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        swiped = false
        if let touch = touches.first {
            lastPoint = touch.locationInView(self.view)
        }
    }
    
    
    // This method will draw the annotation on the image via connecting start to end points
    
    func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint)
    {
        
            UIGraphicsBeginImageContext(view.frame.size)
            let context = UIGraphicsGetCurrentContext()
            tempImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
            
            
            CGContextMoveToPoint(context, fromPoint.x, fromPoint.y)
            CGContextAddLineToPoint(context, toPoint.x, toPoint.y)
            
            
            CGContextSetLineCap(context, CGLineCap.Round)
            CGContextSetLineWidth(context, brushWidth)
            CGContextSetRGBStrokeColor(context, red, green, blue, 1.0)
            CGContextSetBlendMode(context, CGBlendMode.Normal)
            
            
            CGContextStrokePath(context)
            
            
            tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
            tempImageView.alpha = opacity
            UIGraphicsEndImageContext()        
        
        
    }
    
    // This method is a touches moved method to draw line from last to current point
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        swiped = true
        if let touch = touches.first {
            let currentPoint = touch.locationInView(view)
            drawLineFrom(lastPoint, toPoint: currentPoint)
            
            
            lastPoint = currentPoint
        }
    }
    
    // This method is the touches ended to merge temp image to main image
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if !swiped {
            // draw a single point
            drawLineFrom(lastPoint, toPoint: lastPoint)
        }
        
        // Merge tempImageView into mainImageView
        UIGraphicsBeginImageContext(mainImageView.frame.size)
        mainImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height), blendMode: CGBlendMode.Normal, alpha: 1.0)
        tempImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height), blendMode: CGBlendMode.Normal, alpha: opacity)
        
        mainImageView.image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        
        tempImageView.image = nil
        
    }
    
    // This is prepare for segue method to navigate to settings screen
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let settingsViewController = segue.destinationViewController as! PTPDrawImagePadSettingsViewController
        settingsViewController.delegate = self
        settingsViewController.brush = brushWidth
        settingsViewController.opacity = opacity
        settingsViewController.red = red
        settingsViewController.green = green
        settingsViewController.blue = blue
    }
    
}

// This is the settings screen delegate method to set various draw pad settings

extension PTPDrawImagePadViewController: PTPDrawImagePadSettingsViewControllerDelegate {
    func PTPDrawImagePadSettingsViewControllerFinished(settingsViewController: PTPDrawImagePadSettingsViewController) {
        self.brushWidth = settingsViewController.brush
        self.opacity = settingsViewController.opacity
        self.red = settingsViewController.red
        self.green = settingsViewController.green
        self.blue = settingsViewController.blue
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}

