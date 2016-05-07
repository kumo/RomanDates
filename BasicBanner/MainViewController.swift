//
//  MainViewController.swift
//  RomanDates
//
//  Created by Robert Clarke on 29/10/2015.
//
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var dateOrder: NSLocale.DateOrder = .DayFirst

    private var date = NSDate() {
        didSet {
            let parts = date.dateInRoman()
            
            switch dateOrder {
            case .DayFirst:
                dateLabel.text = parts.day + "\u{200B}·\u{200B}" + parts.month + "\u{200B}·\u{200B}" + parts.year
            case .MonthFirst:
                dateLabel.text = parts.month + "\u{200B}·\u{200B}" + parts.day + "\u{200B}·\u{200B}" + parts.year
            case .YearFirst:
                dateLabel.text = parts.year + "\u{200B}·\u{200B}" + parts.month + "\u{200B}·\u{200B}" + parts.day
            }
            
            if let accessibilityText = dateLabel.text?.stringByReplacingOccurrencesOfString("\u{200B}·\u{200B}", withString: " - ") {
                dateLabel.accessibilityLabel = accessibilityText.characters.reduce("",
                    combine: {String($0) + String($1) + ". "})
                
                UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, dateLabel.accessibilityLabel)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewWillAppear(animated: Bool) {
        dateOrder = NSLocale.currentLocale().dateOrder()
        
        date = NSDate()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func datePickerAction(sender: UIDatePicker) {
        self.date = sender.date
    }

    @IBAction func shareAction(sender: AnyObject) {
        if  let text = self.dateLabel.text,
            let navigation = self.navigationController
        {
            let textActivityItem = text
            //let linkActivityItem = NSURL(string: "https://itunes.apple.com/us/app/id912520382?mt=8")!
            
            UIGraphicsBeginImageContextWithOptions(self.dateLabel.bounds.size, true, UIScreen.mainScreen().scale)
            
            //self.view!.drawViewHierarchyInRect(self.view!.bounds, afterScreenUpdates: true)
            self.dateLabel.layer.renderInContext(UIGraphicsGetCurrentContext()!)
            
            let screenshot = UIGraphicsGetImageFromCurrentImageContext()
            
            UIGraphicsEndImageContext()
            
            let pngActivityItem = UIImagePNGRepresentation(screenshot)!

            let activityViewController : UIActivityViewController = UIActivityViewController(activityItems: [textActivityItem, pngActivityItem], applicationActivities: nil)
            
            if self.respondsToSelector(Selector("popoverPresentationController")) {
                activityViewController.popoverPresentationController?.barButtonItem = sender as? UIBarButtonItem
            }
            
            navigation.presentViewController(activityViewController, animated: true, completion: nil)
        }

    }
}
