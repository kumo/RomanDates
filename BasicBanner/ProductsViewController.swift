//
//  ProductsViewController.swift
//  RomanDates
//
//  Created by Robert Clarke on 20/05/2016.
//  Copyright © 2016 Robert Clarke. All rights reserved.
//

import UIKit
import StoreKit

class ProductsViewController: UITableViewController {
    
    let showDetailSegueIdentifier = "showDetail"
    
    var products = [SKProduct]()
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == showDetailSegueIdentifier {
            guard let indexPath = tableView.indexPathForSelectedRow else {
                return false
            }
            
            let product = products[indexPath.row]
            
            return RomanDatesProducts.store.isProductPurchased(product.productIdentifier)
        }
        
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        /*if segue.identifier == showDetailSegueIdentifier {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            
            let product = products[indexPath.row]
            
            if let name = resourceNameForProductIdentifier(product.productIdentifier),
                detailViewController = segue.destinationViewController as? DetailViewController {
                let image = UIImage(named: name)
                detailViewController.image = image
            }
        }*/
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Roman Dates"
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(ProductsViewController.reload), for: .valueChanged)
        
        /*let restoreButton = UIBarButtonItem(title: "Restore", style: .Plain, target: self, action: #selector(ProductsViewController.restoreTapped(_:)))
        navigationItem.rightBarButtonItem = restoreButton*/
        
        NotificationCenter.default.addObserver(self, selector: #selector(ProductsViewController.handlePurchaseNotification(_:)),
                                                         name: NSNotification.Name(rawValue: IAPHelper.IAPHelperPurchaseNotification),
                                                         object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        reload()
    }
    
    func reload() {
        products = []
        
        tableView.reloadData()
        
        RomanDatesProducts.store.requestProducts{success, products in
            if success {
                self.products = products!
                
                self.tableView.reloadData()
            }
            
            self.refreshControl?.endRefreshing()
        }
    }
    
    func restoreTapped(_ sender: AnyObject) {
        RomanDatesProducts.store.restorePurchases()
    }
    
    func handlePurchaseNotification(_ notification: Notification) {
        guard let productID = notification.object as? String else { return }
        
        for (index, product) in products.enumerated() {
            guard product.productIdentifier == productID else { continue }
            
            tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .fade)
        }
    }
}

// MARK: - UITableViewDataSource

extension ProductsViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ProductCell
        
        let product = products[indexPath.row]
        
        cell.product = product
        cell.buyButtonHandler = { product in
            RomanDatesProducts.store.buyProduct(product)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "Thanks for the tip and for any suggestions or requests that you send!"
    }
}
