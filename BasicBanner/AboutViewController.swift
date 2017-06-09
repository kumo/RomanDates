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
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if (section == 2) {
            if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                return "Version: " + version
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if (indexPath.section == 0) {
            if (indexPath.row == 1) {
                self.openTwitter("kumo")
            }
        } else if (indexPath.section == 1) {
            if (indexPath.row == 0)  {
                if let url = URL(string: "http://cadigatt.com/romandates/support/") {
                    UIApplication.shared.openURL(url)
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
    
    func openTwitter(_ account: String) {
        if let twitterURL = URL(string: "twitter://user?screen_name=" + account) {
            if UIApplication.shared.canOpenURL(twitterURL) {
                UIApplication.shared.openURL(twitterURL)
            } else {
                if let url = URL(string: "http://twitter.com/" + account) {
                    UIApplication.shared.openURL(url)
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
            if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                let label = "Roman Dates, v" + version

                let mailer = MFMailComposeViewController()
                mailer.mailComposeDelegate = self

                mailer.setSubject("Roman Dates")
                mailer.setToRecipients(["support+romandates@cadigatt.com"])

                mailer.setMessageBody("\n\n" + label, isHTML: false)

                self.present(mailer, animated: true, completion: nil)
            }
        }
        else
        {
            if let url = URL(string: "mailto:support+romandates@cadigatt.com?subject=RomanDates") {
                UIApplication.shared.openURL(url)
            }
        }
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }

}
