//
//  ConverterSettingsViewController.swift
//  RomanDates
//
//  Created by Robert Clarke on 21/09/2014.
//  Copyright (c) 2014 Robert Clarke. All rights reserved.
//

import UIKit

extension UITableViewCell {
    func appearEnabled(_ enabled: Bool) {
        self.isUserInteractionEnabled = enabled
        self.accessoryView?.isUserInteractionEnabled = enabled
        self.accessoryView?.alpha = (enabled ? 1.0 : 0.5)
        self.textLabel?.isEnabled = enabled

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
            let switchView = UISwitch(frame: CGRect.zero)
            switchView.setOn(AppConfiguration.sharedConfiguration.usePasteboard, animated: false)
            switchView.addTarget(self, action: #selector(automaticallyCopyFromPasteboardSwitchChanged), for: UIControlEvents.valueChanged)

            cell.accessoryView = switchView
        }

        if let cell = self.useCurrentLocaleForDateCell {
            let switchView = UISwitch(frame: CGRect.zero)
            switchView.setOn(AppConfiguration.sharedConfiguration.automaticDateFormat, animated: false)
            switchView.addTarget(self, action: #selector(useCurrentLocaleForDateSwitchChanged), for: UIControlEvents.valueChanged)

            cell.accessoryView = switchView
        }

        if let cell = self.dateOrderCell,
           let segment = self.dateOrderSegment {
            segment.addTarget(self, action: #selector(dateOrderSegmentChanged), for: UIControlEvents.valueChanged)


            if AppConfiguration.sharedConfiguration.automaticDateFormat {
                dateOrderSegment.selectedSegmentIndex = Locale.current.dateOrder().rawValue
            } else {
                dateOrderSegment.selectedSegmentIndex = AppConfiguration.sharedConfiguration.dateFormat.rawValue
            }

            cell.appearEnabled(!AppConfiguration.sharedConfiguration.automaticDateFormat)
        }

        if let cell = self.showYearCell {
            let switchView = UISwitch(frame: CGRect.zero)
            switchView.setOn(AppConfiguration.sharedConfiguration.showYear, animated: false)
            switchView.addTarget(self, action: #selector(showYearSwitchChanged), for: UIControlEvents.valueChanged)
            
            cell.accessoryView = switchView
        }

        if let cell = self.showYearInFullCell {
            let switchView = UISwitch(frame: CGRect.zero)
            switchView.setOn(AppConfiguration.sharedConfiguration.showFullYear, animated: false)
            switchView.addTarget(self, action: #selector(showYearInFullSwitchChanged), for: UIControlEvents.valueChanged)

            cell.accessoryView = switchView

            cell.appearEnabled(AppConfiguration.sharedConfiguration.showYear)
        }

        if let segment = self.symbolSegment {
            segment.addTarget(self, action: #selector(symbolSegmentChanged), for: UIControlEvents.valueChanged)

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

    func automaticallyCopyFromPasteboardSwitchChanged(_ sender: UISwitch!) {
        AppConfiguration.sharedConfiguration.usePasteboard = sender.isOn
    }

    func useCurrentLocaleForDateSwitchChanged(_ sender: UISwitch!) {
        AppConfiguration.sharedConfiguration.automaticDateFormat = sender.isOn

        self.dateOrderCell.appearEnabled(!sender.isOn)

        // show the current locale if it is automatic
        if sender.isOn {
            dateOrderSegment.selectedSegmentIndex = Locale.current.dateOrder().rawValue
        } else {
            dateOrderSegment.selectedSegmentIndex = AppConfiguration.sharedConfiguration.dateFormat.rawValue
        }
    }

    func showYearSwitchChanged(_ sender: UISwitch!) {
        AppConfiguration.sharedConfiguration.showYear = sender.isOn

        self.showYearInFullCell.appearEnabled(sender.isOn)
    }

    func showYearInFullSwitchChanged(_ sender: UISwitch!) {
        AppConfiguration.sharedConfiguration.showFullYear = sender.isOn
    }

}

// MARK: - Segment events
extension ConverterSettingsViewController {

    func dateOrderSegmentChanged(_ sender: UISegmentedControl!) {
        AppConfiguration.sharedConfiguration.dateFormat = DateOrder(rawValue: sender.selectedSegmentIndex)!
    }

    func symbolSegmentChanged(_ sender: UISegmentedControl!) {
        AppConfiguration.sharedConfiguration.separatorSymbol = SeparatorSymbol(rawValue: sender.selectedSegmentIndex)!
    }


}
