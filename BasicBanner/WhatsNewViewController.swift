//
//  WhatsNewViewController.swift
//  RomanDates
//
//  Created by Robert Clarke on 21/09/2014.
//  Copyright (c) 2014 Robert Clarke. All rights reserved.
//

import UIKit

class WhatsNewViewController: UIViewController {
    
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
    
    // Mark: - Review
    
    @IBAction func openReview(_ sender: AnyObject) {
        if let reviewURL = URL(string: "itms-apps://itunes.apple.com/app/id912520382?action=write-review") {
            UIApplication.shared.openURL(reviewURL)
        }
    }
    
}
