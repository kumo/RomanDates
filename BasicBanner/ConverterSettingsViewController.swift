//
//  ConverterSettingsViewController.swift
//  RomanDates
//
//  Created by Robert Clarke on 21/09/2014.
//  Copyright (c) 2014 Robert Clarke. All rights reserved.
//

import UIKit

extension UITableViewCell {
    func appearEnabled(enabled: Bool) {
        self.userInteractionEnabled = enabled
        self.accessoryView?.userInteractionEnabled = enabled
        self.accessoryView?.alpha = (enabled ? 1.0 : 0.5)
        self.textLabel?.enabled = enabled

        for view in self.contentView.subviews {
            view.alpha = (enabled ? 1.0 : 0.5)
        }
    }
}

class ConverterSettingsViewController: UITableViewController {

    @IBOutlet weak var automaticallyCopyFromPasteboardCell: UITableViewCell!
    @IBOutlet weak var useCurrentLocaleForDateCell: UITableViewCell!
    @IBOutlet weak var dateOrderCell: UITableViewCell!
    @IBOutlet weak var showYearCell: UITableViewCell!
    @IBOutlet weak var showYearInFullCell: UITableViewCell!

    @IBOutlet weak var dateOrderSegment: UISegmentedControl!

    @IBOutlet weak var symbolCell: UITableViewCell!
    @IBOutlet weak var symbolSegment: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.configureView()
    }

    
    func configureView() {
        if let cell = self.automaticallyCopyFromPasteboardCell {
            let switchView = UISwitch(frame: CGRectZero)
            switchView.setOn(AppConfiguration.sharedConfiguration.usePasteboard, animated: false)
            switchView.addTarget(self, action: #selector(automaticallyCopyFromPasteboardSwitchChanged), forControlEvents: UIControlEvents.ValueChanged)

            cell.accessoryView = switchView
        }

        if let cell = self.useCurrentLocaleForDateCell {
            let switchView = UISwitch(frame: CGRectZero)
            switchView.setOn(AppConfiguration.sharedConfiguration.automaticDateFormat, animated: false)
            switchView.addTarget(self, action: #selector(useCurrentLocaleForDateSwitchChanged), forControlEvents: UIControlEvents.ValueChanged)

            cell.accessoryView = switchView
        }

        if let cell = self.dateOrderCell,
           let segment = self.dateOrderSegment {
            segment.addTarget(self, action: #selector(dateOrderSegmentChanged), forControlEvents: UIControlEvents.ValueChanged)


            if AppConfiguration.sharedConfiguration.automaticDateFormat {
                dateOrderSegment.selectedSegmentIndex = NSLocale.currentLocale().dateOrder().rawValue
            } else {
                dateOrderSegment.selectedSegmentIndex = AppConfiguration.sharedConfiguration.dateFormat.rawValue
            }

            cell.appearEnabled(!AppConfiguration.sharedConfiguration.automaticDateFormat)
        }

        if let cell = self.showYearCell {
            let switchView = UISwitch(frame: CGRectZero)
            switchView.setOn(AppConfiguration.sharedConfiguration.showYear, animated: false)
            switchView.addTarget(self, action: #selector(showYearSwitchChanged), forControlEvents: UIControlEvents.ValueChanged)
            
            cell.accessoryView = switchView
        }

        if let cell = self.showYearInFullCell {
            let switchView = UISwitch(frame: CGRectZero)
            switchView.setOn(AppConfiguration.sharedConfiguration.showFullYear, animated: false)
            switchView.addTarget(self, action: #selector(showYearInFullSwitchChanged), forControlEvents: UIControlEvents.ValueChanged)

            cell.accessoryView = switchView

            cell.appearEnabled(AppConfiguration.sharedConfiguration.showYear)
        }

        if let segment = self.symbolSegment {
            segment.addTarget(self, action: #selector(symbolSegmentChanged), forControlEvents: UIControlEvents.ValueChanged)

            symbolSegment.selectedSegmentIndex = AppConfiguration.sharedConfiguration.separatorSymbol.rawValue
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


// MARK: - Switch events
extension ConverterSettingsViewController {

    func automaticallyCopyFromPasteboardSwitchChanged(sender: UISwitch!) {
        AppConfiguration.sharedConfiguration.usePasteboard = sender.on
    }

    func useCurrentLocaleForDateSwitchChanged(sender: UISwitch!) {
        AppConfiguration.sharedConfiguration.automaticDateFormat = sender.on

        self.dateOrderCell.appearEnabled(!sender.on)

        if sender.on {
            dateOrderSegment.selectedSegmentIndex = NSLocale.currentLocale().dateOrder().rawValue
        } else {
            dateOrderSegment.selectedSegmentIndex = AppConfiguration.sharedConfiguration.dateFormat.rawValue
        }
    }

    func showYearSwitchChanged(sender: UISwitch!) {
        AppConfiguration.sharedConfiguration.showYear = sender.on

        self.showYearInFullCell.appearEnabled(sender.on)
    }

    func showYearInFullSwitchChanged(sender: UISwitch!) {
        AppConfiguration.sharedConfiguration.showFullYear = sender.on
    }

}

extension ConverterSettingsViewController {

    func dateOrderSegmentChanged(sender: UISegmentedControl!) {
        AppConfiguration.sharedConfiguration.dateFormat = DateOrder(rawValue: sender.selectedSegmentIndex)!
    }

    func symbolSegmentChanged(sender: UISegmentedControl!) {
        AppConfiguration.sharedConfiguration.separatorSymbol = SeparatorSymbol(rawValue: sender.selectedSegmentIndex)!
    }


}