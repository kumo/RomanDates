//
//  AboutViewController.swift
//  RomanDates
//
//  Created by Robert Clarke on 20/09/2014.
//  Copyright (c) 2014 Robert Clarke. All rights reserved.
//

import UIKit
import MessageUI

class AboutViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if (section == 2) {
            if let version = NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] as? String {
                return "Version: " + version
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    // MARK: - Table view delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if (indexPath.section == 0) {
            if (indexPath.row == 1) {
                self.openTwitter("kumo")
            }
        } else if (indexPath.section == 1) {
            if (indexPath.row == 0)  {
                if let url = NSURL(string: "http://cadigatt.com/romandates/support/") {
                    UIApplication.sharedApplication().openURL(url)
                }
            } else if (indexPath.row == 1) {
                self.openTwitter("cadigatt")
            } else if (indexPath.row == 2) {
                self.openTwitter("RomanNumsApp")
            } else if (indexPath.row == 3) {
                self.composeEmail()
            }
        }
    }



    // Mark: - Twitter
    
    func openTwitter(account: String) {
        if let twitterURL = NSURL(string: "twitter://user?screen_name=" + account) {
            if UIApplication.sharedApplication().canOpenURL(twitterURL) {
                UIApplication.sharedApplication().openURL(twitterURL)
            } else {
                if let url = NSURL(string: "http://twitter.com/" + account) {
                    UIApplication.sharedApplication().openURL(url)
                }
            }
        }
    }
    
}

// MARK: - Email

extension AboutViewController: MFMailComposeViewControllerDelegate {

    func composeEmail() {
        if MFMailComposeViewController.canSendMail()
        {
            if let version = NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] as? String {
                let label = "Roman Dates, v" + version

                let mailer = MFMailComposeViewController()
                mailer.mailComposeDelegate = self

                mailer.setSubject("Roman Dates")
                mailer.setToRecipients(["support+romandates@cadigatt.com"])

                mailer.setMessageBody("\n\n" + label, isHTML: false)

                self.presentViewController(mailer, animated: true, completion: nil)
            }
        }
        else
        {
            if let url = NSURL(string: "mailto:support+romandates@cadigatt.com?subject=RomanDates") {
                UIApplication.sharedApplication().openURL(url)
            }
        }
    }

    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }

}