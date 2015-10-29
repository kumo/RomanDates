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
    
    private var date = NSDate() {
        didSet {
            dateLabel.text = "hello"
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
            let firstActivityItem = text
            
            let activityViewController : UIActivityViewController = UIActivityViewController(activityItems: [firstActivityItem], applicationActivities: nil)
            
            if self.respondsToSelector("popoverPresentationController") {
                // iOS 8+
                if #available(iOS 8.0, *) {
                    activityViewController.popoverPresentationController?.barButtonItem = sender as? UIBarButtonItem
                } else {
                    // Fallback on earlier versions
                }
            }
            
            navigation.presentViewController(activityViewController, animated: true, completion: nil)
        }

    }
}
