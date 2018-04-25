//
//  RatesTVController.swift
//  Eurates
//
//  Created by Daniel Frost on 22/04/2018.
//  Copyright © 2018 Daniel Frost. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Firebase

class RatesTVController: UITableViewController {
    let FOREX_URL = "http://data.fixer.io/api/latest"
    let ACCESS_KEY = "8447a785aa1248807fcfc7a2c338d998"
    let SYMBOLS = "USD,AUD,CAD,PLN,MXN,ILS"
    let CURRENCIES = ["USD": ["🇺🇸", "$"],
                      "AUD": ["🇦🇺", "$"],
                      "CAD": ["🇨🇦", "$"],
                      "PLN": ["🇵🇱", "zł"],
                      "MXN": ["🇲🇽", "$"],
                      "ILS": ["🇮🇱", "₪"]]
    
    var currencyArray: [Currency] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isToolbarHidden = false;
        self.title = "€ Rates"
        
        let PARAMETERS: [String: String] = ["access_key": ACCESS_KEY, "symbols": SYMBOLS]
        getForexData(params: PARAMETERS)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencyArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "currencyTableCell", for: indexPath)
        let string1 = currencyArray[indexPath.row].flag + " " + currencyArray[indexPath.row].abbreviation + " "
        let string2 = currencyArray[indexPath.row].symbol + "\(currencyArray[indexPath.row].rate)"
        cell.textLabel?.text = string1 + string2
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let title = "Save current " + currencyArray[indexPath.row].abbreviation + " rate?"
        let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default) { (action) in
            self.saveData(tableView, indexPath)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action) in
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    func saveData(_ tableView: UITableView, _ indexPath: IndexPath) {
        ProgressHUD.show()
        
        let currentCell = tableView.cellForRow(at: indexPath)
        let user = (Auth.auth().currentUser?.email)!
        let ratesDB = Database.database().reference().child("rates").child((String(user.prefix(upTo: user.index(of: ".")!))))
        let ratesDictionary = ["time": String(Date().description(with: .current)), "rate": currentCell?.textLabel?.text]
        
        ratesDB.childByAutoId().setValue(ratesDictionary) { (error, reference) in
            if error != nil {
                print("❌ \(error!)")
                ProgressHUD.showError("Error during saving")
                return
            } else {
                print("✅ Successful rate save")
                ProgressHUD.showSuccess("Saved successfuly")
            }
        }
    }
    
    func getForexData(params: [String: String]) {
        Alamofire.request(FOREX_URL, method: .get, parameters: params).responseJSON { response in
            if response.result.isFailure {
                print("❌ Error in get request")
            } else {
                print("✅ Successful get request")
                
                let forexJSON: JSON = JSON(response.result.value!)
                
                if forexJSON["success"] == false {
                    print("❌ Error in forexJSON")
                } else {
                    self.updateForexData(json: forexJSON)
                }
            }
        }
    }
    
    func updateForexData(json: JSON) {
        for i in json["rates"] {
            let currency = Currency(flag: CURRENCIES[i.0]![0], abbreviation: i.0, symbol: CURRENCIES[i.0]![1], rate: i.1.floatValue)
            currencyArray.append(currency)
            
            self.tableView.reloadData()
        }
    }
    
    
    @IBAction func logOutPressed(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            navigationController?.isToolbarHidden = true;
            navigationController?.popToRootViewController(animated: true)
        } catch {
            print("❌ Error while logging out")
        }
    }
}
