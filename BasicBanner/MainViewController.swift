//
//  MainViewController.swift
//  RomanDates
//
//  Created by Robert Clarke on 29/10/2015.
//
//

import UIKit
import Crashlytics

class MainViewController: UIViewController {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var dateOrder: DateOrder = .DayFirst

    private var date = NSDate() {
        didSet {
            let parts = date.dateInRoman()

            var text = ""
            let separatorSymbol = AppConfiguration.sharedConfiguration.separatorSymbol.character

            switch dateOrder {
            case .DayFirst:
                text = parts.day + "\u{200B}\(separatorSymbol)\u{200B}" + parts.month

                if AppConfiguration.sharedConfiguration.showYear {
                    text = text + "\u{200B}\(separatorSymbol)\u{200B}" + (AppConfiguration.sharedConfiguration.showFullYear ? parts.year : parts.shortYear)
                }
            case .MonthFirst:
                text = parts.month + "\u{200B}\(separatorSymbol)\u{200B}" + parts.day

                if AppConfiguration.sharedConfiguration.showYear {
                    text = text + "\u{200B}\(separatorSymbol)\u{200B}" + (AppConfiguration.sharedConfiguration.showFullYear ? parts.year : parts.shortYear)
                }
            case .YearFirst:
                text = parts.month + "\u{200B}\(separatorSymbol)\u{200B}" + parts.day

                if AppConfiguration.sharedConfiguration.showYear {
                    text = (AppConfiguration.sharedConfiguration.showFullYear ? parts.year : parts.shortYear) +  "\u{200B}\(separatorSymbol)\u{200B}" + text
                }
            }

            dateLabel.text = text
            
            if let accessibilityText = dateLabel.text?.stringByReplacingOccurrencesOfString("\u{200B}\(separatorSymbol)\u{200B}", withString: " - ") {
                dateLabel.accessibilityLabel = accessibilityText.characters.reduce("",
                    combine: {String($0) + String($1) + ". "})
                
                UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, dateLabel.accessibilityLabel)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(handleShortcutNotification(_:)),
                                                         name: "HandleShortcut",
                                                         object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewWillAppear(animated: Bool) {
        if AppConfiguration.sharedConfiguration.automaticDateFormat {
            dateOrder = NSLocale.currentLocale().dateOrder()
        } else {
            dateOrder = AppConfiguration.sharedConfiguration.dateFormat
        }
        
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
            
            activityViewController.completionWithItemsHandler = {(activityType, completed:Bool, returnedItems:[AnyObject]?, error: NSError?) in
                
                // Return if cancelled
                if (!completed) {
                    return
                }
                
                //activity complete
                //some code here
                //print("Activity: \(activityType) Success: \(completed) Items: \(returnedItems) Error: \(error)")
                
                var activityName = ""
                
                guard let activity = activityType else {
                    return
                }
                
                switch activity {
                case UIActivityTypePostToTwitter: activityName = "Twitter"
                case UIActivityTypePostToFacebook: activityName = "Facebook"
                case UIActivityTypeMail: activityName = "Email"
                case UIActivityTypeMessage: activityName = "Message"
                case UIActivityTypePrint: activityName = "Print"
                case UIActivityTypeSaveToCameraRoll: activityName = "CameraRoll"
                case UIActivityTypePostToFlickr: activityName = "Flickr"
                case UIActivityTypeAssignToContact: activityName = "Contact"
                case UIActivityTypePostToWeibo: activityName = "Weibo"
                case UIActivityTypePostToTencentWeibo: activityName = "TencentWeibo"
                case UIActivityTypeAirDrop: activityName = "AirDrop"
                case UIActivityTypeCopyToPasteboard: activityName = "Pasteboard"
                default: activityName = activity
                }
                
                Answers.logShareWithMethod(activityName, contentName: nil, contentType: nil, contentId: nil, customAttributes: ["dateOrder": self.dateOrder.rawValue])
            }
            
            if self.respondsToSelector(Selector("popoverPresentationController")) {
                activityViewController.popoverPresentationController?.barButtonItem = sender as? UIBarButtonItem
            }
            
            navigation.presentViewController(activityViewController, animated: true, completion: nil)
        }

    }
    
    func handleShortcutNotification(notification: NSNotification) {
        guard let info = notification.userInfo else {
            return
        }
        
        guard let shortcutType = info["shortcut"] as? String else {
            return
        }

        guard let shortcutItem = ShortcutItemType(fullIdentifier: shortcutType) else {
            return
        }

        switch shortcutItem {
        case .ConvertToday: date = NSDate()
        case .ConvertYesterday: date = NSDate().dayBefore
        case .ConvertTomorrow: date = NSDate().dayAfter
        default: date = NSDate()
        }
        
        datePicker.date = date
    }

    func convertDate(date: String) {

    }
}
