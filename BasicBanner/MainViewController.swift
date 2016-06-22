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
            datePicker.date = date
            presentDate()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        /*NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(handleShortcutNotification(_:)),
                                                         name: "HandleShortcut",
                                                         object: nil)*/
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        date = NSDate()
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    override func viewWillAppear(animated: Bool) {
        if AppConfiguration.sharedConfiguration.automaticDateFormat {
            dateOrder = NSLocale.currentLocale().dateOrder()
        } else {
            dateOrder = AppConfiguration.sharedConfiguration.dateFormat
        }

        if AppConfiguration.sharedConfiguration.usePasteboard {
            showClipboardDateOrDate(date)
        } else {
            presentDate()
        }

        NSNotificationCenter
            .defaultCenter()
            .addObserver(
                self,
                selector: #selector(pasteboardChanged(_:)),
                name: "NewPasteboard",
                object: nil)
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
    
    @available(iOS 9.0, *)
    func handleShortcut(shortcutItemType: ShortcutItemType) {
        switch shortcutItemType {
        case .ConvertToday: date = NSDate()
        case .ConvertYesterday: date = NSDate().dayBefore
        case .ConvertTomorrow: date = NSDate().dayAfter
        case .ConvertPasteboard:
            if let pasteboardDate = NSDate().pasteboardDate() {
                date = pasteboardDate
            } else {
                date = NSDate()
            }
        }
    }

    func presentDate() {
        let parts = date.dateInRoman()

        var dateComponents: [String] = []

        if dateOrder == .DayFirst {
            dateComponents = [parts.day, parts.month]
        } else {
            dateComponents = [parts.month, parts.day]
        }

        if AppConfiguration.sharedConfiguration.showYear {
            var year = ""

            // If we must show a short year, make sure that the short year exist (think 2000!)
            if let shortYear = parts.shortYear where AppConfiguration.sharedConfiguration.showFullYear == false {
                year = shortYear
            } else {
                year = parts.year
            }

            if dateOrder == .YearFirst {
                dateComponents.insert(year, atIndex: 0)
            } else {
                dateComponents.append(year)
            }
        }

        let separatorSymbol =  "\u{200B}\(AppConfiguration.sharedConfiguration.separatorSymbol.character)\u{200B}"
        let text = dateComponents.joinWithSeparator(separatorSymbol)

        dateLabel.text = text

        if let accessibilityText = dateLabel.text?.stringByReplacingOccurrencesOfString("\u{200B}\(separatorSymbol)\u{200B}", withString: " - ") {
            dateLabel.accessibilityLabel = accessibilityText.characters.reduce("",
                                                                               combine: {String($0) + String($1) + ". "})

            UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, dateLabel.accessibilityLabel)
        }
    }
}

// MARK: - Pasteboard
extension MainViewController {

    func detectDate(string: String) -> NSDate? {
        let types: NSTextCheckingType = [.Date]
        let detector = try? NSDataDetector(types: types.rawValue)
        var dates: [NSDate] = []

        detector?.enumerateMatchesInString(string, options: [], range: NSMakeRange(0, string.characters.count)) { (result, flags, _) in

            if let date = result?.date {
                dates.append(date)
            }
        }

        guard let firstDate = dates.first else {
            return nil
        }

        return firstDate
    }

    func showClipboardDateOrDate(date: NSDate) {

        let changeCount = UIPasteboard.generalPasteboard().changeCount;

        // Ensure that the pasteboard has changed
        guard changeCount != AppConfiguration.sharedConfiguration.pasteboardChangeCount else {
            self.date = date
            return
        }

        // Ensure that the pasteboard has a date
        guard let currentPasteboardContents = UIPasteboard.generalPasteboard().string,
              let pasteboardDate = detectDate(currentPasteboardContents) else {
            self.date = date
            return
        }

        self.date = pasteboardDate
        AppConfiguration.sharedConfiguration.pasteboardChangeCount = changeCount
    }

    @objc private func pasteboardChanged(notification: NSNotification) {

        guard let currentPasteboardContents = UIPasteboard.generalPasteboard().string,
            let pasteboardDate = detectDate(currentPasteboardContents) else {
                return
        }

        self.date = pasteboardDate
    }

}