//
//  StoreVC.swift
//  EyeFighter
//
//  Created by Connor yass on 2/20/19.
//  Copyright © 2019 HSY Technologies. All rights reserved.
//

import UIKit
import StoreKit

/* ----------------------------------------------------------------------------------------- */

class StoreVC: UITableViewController, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    var productIDs: Set = ["com.EyeFighter.removeAds"]
    var productsArray: Array<SKProduct?> = []
    var selectedProductIndex: Int!
    var transactionInProgress = false
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    //MARK: - Initialization + setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SKPaymentQueue.default().add(self)
        self.setupInterface()
        requestProductInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func setupInterface() {
        tableView.reloadData()
    }
    
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    // MARK: - SKProductsRequestDelegate
    
    func requestProductInfo() {
        if SKPaymentQueue.canMakePayments() {
            let productRequest = SKProductsRequest(productIdentifiers: productIDs)
            productRequest.delegate = self
            productRequest.start()
        } else {
            Log.error("Cannot perform In App Purchases.")
        }
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if response.products.count != 0 {
            Log.info("\(response.products.count) products recieved")
            for product in response.products {
                productsArray.append(product)
            }
            self.tableView.reloadData()
        } else {
            Log.info("There are no products.")
        }
        if response.invalidProductIdentifiers.count != 0 {
            Log.info(response.invalidProductIdentifiers.description)
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case SKPaymentTransactionState.purchased:
                Log.info("Transaction completed successfully.")
                SKPaymentQueue.default().finishTransaction(transaction)
                transactionInProgress = false
                
                switch(transaction.payment.productIdentifier){
                case "com.ChalkTalk.removeAds":
                    UserDefaults.standard.set(true, forKey: "com.ChalkTalk.removeAds")
                    break
                default:
                    break
                }
                
//                let ac = AppUtility.alert(title: "Purchase Succesful!", message: "")
//                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel) { (action) -> Void in
//                    ac.dismiss(animated: true, completion: nil)
//                }
//
//                ac.addAction(okAction)
//                present(ac, animated: true, completion: nil)
                
            case SKPaymentTransactionState.failed:
                Log.info("Transaction Failed");
                SKPaymentQueue.default().finishTransaction(transaction)
                transactionInProgress = false
                
//                let ac = AppUtility.alert(title: "Purchase failed...", message: "\(transaction.transactionIdentifier!)")
//                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel) { (action) -> Void in
//                    ac.dismiss(animated: true, completion: nil)
//                }
                
//                ac.addAction(okAction)
//                present(ac, animated: true, completion: nil)
                
            case SKPaymentTransactionState.restored:
                Log.info("Transaction Restored");
                SKPaymentQueue.default().finishTransaction(transaction)
                transactionInProgress = false
                
                switch(transaction.payment.productIdentifier){
                case "com.ChalkTalk.removeAds":
                    UserDefaults.standard.set(true, forKey: "com.ChalkTalk.removeAds")
                    break
                default:
                    break
                }
                
//                let ac = AppUtility.alert(title: "Purchase Restored!", message: "")
//                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel) { (action) -> Void in
//                    ac.dismiss(animated: true, completion: nil)
//                }
//                ac.addAction(okAction)
//                present(ac, animated: true, completion: nil)
                
            default:
                Log.info(transaction.transactionState.rawValue)
            }
            
            OperationQueue.main.addOperation {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
    }
    
    @IBAction func restorePurchases(){
        if (SKPaymentQueue.canMakePayments()) {
//            let ac = AppUtility.alert(title: "Restore Purchases?", message: "")
//
//            let yesAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default) { (action) -> Void in
//                SKPaymentQueue.default().restoreCompletedTransactions()
//                ac.dismiss(animated: true, completion: nil)
//            }
//            let noAction = UIAlertAction(title: "No", style: UIAlertActionStyle.cancel) { (action) -> Void in
//                ac.dismiss(animated: true, completion: nil)
//            }
//            ac.addAction(noAction)
//            ac.addAction(yesAction)
//            present(ac, animated: true, completion: nil)
        }
    }
    
    public func buyProduct(_ product: SKProduct) {
        Log.info("Purchasing \(product.productIdentifier)...")
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
        OperationQueue.main.addOperation {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int { return 1 }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if productsArray.count > 0 {
            self.tableView.backgroundView = nil
            self.tableView.separatorStyle = .singleLine
            return productsArray.count
        } else {
            let lbl_waiting = UILabel(frame: tableView.frame)
            lbl_waiting.textAlignment = .center
            lbl_waiting.font = UIFont(name: "Nintendo DS", size: 23.0)
            lbl_waiting.tintColor = UIColor.darkGray
            lbl_waiting.text = "Loading ..."
            self.tableView.backgroundView = lbl_waiting
            self.tableView.separatorStyle = .none
            return 0
        }
        
    }
    
    internal override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductTableCell", for: indexPath)
//        let product = productsArray[indexPath.row]
//        cell.label_ProductName.text = product?.localizedTitle
//        cell.label_productDescription.text = product?.localizedDescription
//        cell.label_Price.text = "$" + (product?.price.stringValue)!
//        cell.label_Price.textColor = color
       return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedProduct = productsArray[indexPath.row] {
            
//            let ac = AppUtility.alert(title: selectedProduct.localizedTitle, message: selectedProduct.localizedDescription)
//            let buyAction: UIAlertAction = UIAlertAction(title: "Purchase", style: UIAlertActionStyle.default) { (alertAction) -> Void in
//                self.buyProduct(selectedProduct)
//                self.tableView.deselectRow(at: indexPath, animated: true)
//            }
//
//            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (alertAction) -> Void in
//                self.tableView.deselectRow(at: indexPath, animated: true)
//            }
//            ac.addAction(buyAction)
//            ac.addAction(cancelAction)
//            self.present(ac, animated: true, completion: nil)
        }
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .default }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    
}

/* ----------------------------------------------------------------------------------------- */


