//
//  SettingsViewController.swift
//  RomanDates
//
//  Created by Robert Clarke on 20/09/2014.
//  Copyright (c) 2014 Robert Clarke. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {

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

    // MARK: - Table view delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                if let url = URL(string: "http://cadigatt.com/romandates/support/") {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        } else if (indexPath.section == 2) {
            if (indexPath.row == 1) {
                self.tellAFriend()
            } else if (indexPath.row == 2) {
                self.openReview()
            }
        }
    }
    
    func tellAFriend() {
        if let navigation = self.navigationController {
            let firstActivityItem = "Roman Dates is a universal app that lets you easily convert dates into Roman Numerals"
            let secondActivityItem = URL(string: "https://itunes.apple.com/us/app/id912520382?mt=8")!
            
            let activityViewController : UIActivityViewController = UIActivityViewController(activityItems: [firstActivityItem, secondActivityItem], applicationActivities: nil)

            if self.responds(to: #selector(getter: UIViewController.popoverPresentationController)) {
                activityViewController.popoverPresentationController?.sourceView = self.tableView
                activityViewController.popoverPresentationController?.sourceRect = self.tableView.rectForRow(at: self.tableView.indexPathForSelectedRow!)
            }

            navigation.present(activityViewController, animated: true, completion: nil)
        }
    }

    func openReview() {
        if let reviewURL = URL(string: "itms-apps://itunes.apple.com/app/id912520382?action=write-review") {
            UIApplication.shared.open(reviewURL, options: [:], completionHandler: nil)
        }
    }

    @IBAction func done(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
}
