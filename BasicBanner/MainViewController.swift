//
//  MainViewController.swift
//  RomanDates
//
//  Created by Robert Clarke on 29/10/2015.
//
//

import UIKit
import Crashlytics
import StoreKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var dateOrder: DateOrder = .dayFirst

    fileprivate var date = Date() {
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
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        date = Date()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        NotificationCenter.default.removeObserver(self)
    }

    override func viewWillAppear(_ animated: Bool) {
        if AppConfiguration.sharedConfiguration.automaticDateFormat {
            dateOrder = Locale.current.dateOrder()
        } else {
            dateOrder = AppConfiguration.sharedConfiguration.dateFormat
        }

        if AppConfiguration.sharedConfiguration.usePasteboard {
            showClipboardDateOrDate(date)
        } else {
            presentDate()
        }

        NotificationCenter.default
            .addObserver(
                self,
                selector: #selector(pasteboardChanged(_:)),
                name: NSNotification.Name(rawValue: "NewPasteboard"),
                object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func datePickerAction(_ sender: UIDatePicker) {
        self.date = sender.date
    }

    @IBAction func shareAction(_ sender: AnyObject) {
        if  let text = self.dateLabel.text,
            let navigation = self.navigationController
        {
            let textActivityItem = text
            //let linkActivityItem = NSURL(string: "https://itunes.apple.com/us/app/id912520382?mt=8")!
            
            UIGraphicsBeginImageContextWithOptions(self.dateLabel.bounds.size, true, UIScreen.main.scale)
            
            //self.view!.drawViewHierarchyInRect(self.view!.bounds, afterScreenUpdates: true)
            self.dateLabel.layer.render(in: UIGraphicsGetCurrentContext()!)
            
            let screenshot = UIGraphicsGetImageFromCurrentImageContext()
            
            UIGraphicsEndImageContext()
            
            let pngActivityItem = UIImagePNGRepresentation(screenshot!)!

            let activityViewController : UIActivityViewController = UIActivityViewController(activityItems: [textActivityItem, pngActivityItem], applicationActivities: nil)
            
            activityViewController.completionWithItemsHandler = {(activityType: UIActivityType?, completed: Bool, returnedItems:[Any]?, error: Error?) -> Void in

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
                case UIActivityType.postToTwitter: activityName = "Twitter"
                case UIActivityType.postToFacebook: activityName = "Facebook"
                case UIActivityType.mail: activityName = "Email"
                case UIActivityType.message: activityName = "Message"
                case UIActivityType.print: activityName = "Print"
                case UIActivityType.saveToCameraRoll: activityName = "CameraRoll"
                case UIActivityType.postToFlickr: activityName = "Flickr"
                case UIActivityType.assignToContact: activityName = "Contact"
                case UIActivityType.postToWeibo: activityName = "Weibo"
                case UIActivityType.postToTencentWeibo: activityName = "TencentWeibo"
                case UIActivityType.airDrop: activityName = "AirDrop"
                case UIActivityType.copyToPasteboard: activityName = "Pasteboard"
                default: activityName = activity.rawValue
                }
                
                Answers.logShare(withMethod: activityName, contentName: nil, contentType: nil, contentId: nil, customAttributes: ["dateOrder": self.dateOrder.rawValue])

                if #available(iOS 10.3, *) {
                    SKStoreReviewController.requestReview()
                } else {
                    // Fallback on earlier versions
                };
            }
            
            if self.responds(to: #selector(getter: UIViewController.popoverPresentationController)) {
                activityViewController.popoverPresentationController?.barButtonItem = sender as? UIBarButtonItem
            }
            
            navigation.present(activityViewController, animated: true, completion: nil)
        }

    }
    
    @available(iOS 9.0, *)
    func handleShortcut(_ shortcutItemType: ShortcutItemType) {
        switch shortcutItemType {
        case .ConvertToday: date = Date()
        case .ConvertYesterday: date = Date().dayBefore
        case .ConvertTomorrow: date = Date().dayAfter
        case .ConvertPasteboard:
            if let pasteboardDate = Date().pasteboardDate() {
                date = pasteboardDate
            } else {
                date = Date()
            }
        }
    }

    func presentDate() {
        let parts = date.dateInRoman()

        var dateComponents: [String] = []

        if dateOrder == .dayFirst {
            dateComponents = [parts.day, parts.month]
        } else {
            dateComponents = [parts.month, parts.day]
        }

        if AppConfiguration.sharedConfiguration.showYear {
            var year = ""

            // If we must show a short year, make sure that the short year exist (think 2000!)
            if let shortYear = parts.shortYear, AppConfiguration.sharedConfiguration.showFullYear == false {
                year = shortYear
            } else {
                year = parts.year
            }

            if dateOrder == .yearFirst {
                dateComponents.insert(year, at: 0)
            } else {
                dateComponents.append(year)
            }
        }

        let separatorSymbol =  "\u{200B}\(AppConfiguration.sharedConfiguration.separatorSymbol.character)\u{200B}"
        let text = dateComponents.joined(separator: separatorSymbol)

        dateLabel.text = text

        if let accessibilityText = dateLabel.text?.replacingOccurrences(of: "\u{200B}\(separatorSymbol)\u{200B}", with: " - ") {
            dateLabel.accessibilityLabel = accessibilityText.characters.reduce("",
                                                                               {String($0) + String($1) + ". "})

            UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, dateLabel.accessibilityLabel)
        }
    }
}

// MARK: - Pasteboard
extension MainViewController {

    func detectDate(_ string: String) -> Date? {
        let types: NSTextCheckingResult.CheckingType = [.date]
        let detector = try? NSDataDetector(types: types.rawValue)
        var dates: [Date] = []

        detector?.enumerateMatches(in: string, options: [], range: NSMakeRange(0, string.characters.count)) { (result, flags, _) in

            if let date = result?.date {
                dates.append(date)
            }
        }

        guard let firstDate = dates.first else {
            return nil
        }

        return firstDate
    }

    func showClipboardDateOrDate(_ date: Date) {

        let changeCount = UIPasteboard.general.changeCount;

        // Ensure that the pasteboard has changed
        guard changeCount != AppConfiguration.sharedConfiguration.pasteboardChangeCount else {
            self.date = date
            return
        }

        // Ensure that the pasteboard has a date
        guard let currentPasteboardContents = UIPasteboard.general.string,
              let pasteboardDate = detectDate(currentPasteboardContents) else {
            self.date = date
            return
        }

        self.date = pasteboardDate
        AppConfiguration.sharedConfiguration.pasteboardChangeCount = changeCount
    }

    @objc fileprivate func pasteboardChanged(_ notification: Notification) {

        guard let currentPasteboardContents = UIPasteboard.general.string,
            let pasteboardDate = detectDate(currentPasteboardContents) else {
                return
        }

        self.date = pasteboardDate
    }

}

extension MainViewController {


    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return ( action == #selector(copy(_:)) )
    }

    @IBAction func longPressDateLabel(_ sender: Any) {

        let menu = UIMenuController.shared
        if !menu.isMenuVisible {
            menu.setTargetRect(dateLabel.bounds, in: dateLabel)
            menu.setMenuVisible(true, animated: true)
        }

    }

    override var canBecomeFirstResponder : Bool {
        return true
    }

    // MARK: - UIResponderStandardEditActions

    override func copy(_ sender: Any?) {
        UIPasteboard.general.string = dateLabel.text
    }
}
