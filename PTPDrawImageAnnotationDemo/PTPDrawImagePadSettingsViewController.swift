//
//  AppDelegate.swift
//  DrawPad
//
//  Created by Sugam Kalra on 07/01/16.
//  Copyright © 2016 Sugam Kalra. All rights reserved.
//


import UIKit

// Protocol declaration to be fired when any setting has been changed

protocol PTPDrawImagePadSettingsViewControllerDelegate: class {
  func PTPDrawImagePadSettingsViewControllerFinished(settingsViewController: PTPDrawImagePadSettingsViewController)
}

class PTPDrawImagePadSettingsViewController: UIViewController {

  @IBOutlet weak var sliderBrush: UISlider!
  @IBOutlet weak var sliderOpacity: UISlider!

  @IBOutlet weak var imageViewBrush: UIImageView!
  @IBOutlet weak var imageViewOpacity: UIImageView!

  @IBOutlet weak var labelBrush: UILabel!
  @IBOutlet weak var labelOpacity: UILabel!

  @IBOutlet weak var sliderRed: UISlider!
  @IBOutlet weak var sliderGreen: UISlider!
  @IBOutlet weak var sliderBlue: UISlider!

  @IBOutlet weak var labelRed: UILabel!
  @IBOutlet weak var labelGreen: UILabel!
  @IBOutlet weak var labelBlue: UILabel!
  
  //  Set the default values for the settings of draw pad
    
  var brush: CGFloat = 10.0
  var opacity: CGFloat = 1.0
  var red: CGFloat = 0.0
  var green: CGFloat = 0.0
  var blue: CGFloat = 0.0
  
  // Declaration of Settings Delegate
    
  weak var delegate: PTPDrawImagePadSettingsViewControllerDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

    
  // MARK: - Actions
    
  // This is a close method to dismiss settings screen and fire delegate to draw pad screen
    
  @IBAction func close(sender: AnyObject) {
    dismissViewControllerAnimated(true, completion: nil)
    self.delegate?.PTPDrawImagePadSettingsViewControllerFinished(self)
  }
    
    
  // This is a slider delegate methods to store RGB values for the sliders

  @IBAction func colorChanged(sender: UISlider) {
    red = CGFloat(sliderRed.value / 255.0)
    labelRed.text = NSString(format: "%d", Int(sliderRed.value)) as String
    green = CGFloat(sliderGreen.value / 255.0)
    labelGreen.text = NSString(format: "%d", Int(sliderGreen.value)) as String
    blue = CGFloat(sliderBlue.value / 255.0)
    labelBlue.text = NSString(format: "%d", Int(sliderBlue.value)) as String
     
    drawPreview()
  }
    

  // This is a slider delegate methods to change RGB values for the sliders
    
  @IBAction func sliderChanged(sender: UISlider) {
    if sender == sliderBrush {
      brush = CGFloat(sender.value)
      labelBrush.text = NSString(format: "%.2f", brush.native) as String
    } else {
      opacity = CGFloat(sender.value)
      labelOpacity.text = NSString(format: "%.2f", opacity.native) as String
    }
     
    drawPreview()
  }
    
  
  // This method draws the previews of various settings changed
  
  func drawPreview() {
    UIGraphicsBeginImageContext(imageViewBrush.frame.size)
    var context = UIGraphicsGetCurrentContext()
   
    CGContextSetLineCap(context, CGLineCap.Round)
    CGContextSetLineWidth(context, brush)
   
    CGContextSetRGBStrokeColor(context, red, green, blue, 1.0)
    CGContextMoveToPoint(context, 45.0, 45.0)
    CGContextAddLineToPoint(context, 45.0, 45.0)
    CGContextStrokePath(context)
    imageViewBrush.image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
   
    UIGraphicsBeginImageContext(imageViewBrush.frame.size)
    context = UIGraphicsGetCurrentContext()
   
    CGContextSetLineCap(context, CGLineCap.Round)
    CGContextSetLineWidth(context, 20)
    CGContextMoveToPoint(context, 45.0, 45.0)
    CGContextAddLineToPoint(context, 45.0, 45.0)
   
    CGContextSetRGBStrokeColor(context, red, green, blue, opacity)
    CGContextStrokePath(context)
    imageViewOpacity.image = UIGraphicsGetImageFromCurrentImageContext()
   
    UIGraphicsEndImageContext()
  }
  
    
    
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
   
    sliderBrush.value = Float(brush)
    labelBrush.text = NSString(format: "%.1f", brush.native) as String
    sliderOpacity.value = Float(opacity)
    labelOpacity.text = NSString(format: "%.1f", opacity.native) as String
    sliderRed.value = Float(red * 255.0)
    labelRed.text = NSString(format: "%d", Int(sliderRed.value)) as String
    sliderGreen.value = Float(green * 255.0)
    labelGreen.text = NSString(format: "%d", Int(sliderGreen.value)) as String
    sliderBlue.value = Float(blue * 255.0)
    labelBlue.text = NSString(format: "%d", Int(sliderBlue.value)) as String
   
    drawPreview()
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
