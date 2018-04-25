//
//  SavedControllerTableViewController.swift
//  Eurates
//
//  Created by Daniel Frost on 23/04/2018.
//  Copyright © 2018 Daniel Frost. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Firebase

class SavedController: UITableViewController {
    let FOREX_URL = "http://data.fixer.io/api/latest"
    let ACCESS_KEY = "8447a785aa1248807fcfc7a2c338d998"
    let USER = (Auth.auth().currentUser?.email)!
    
    var ratesArray: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isToolbarHidden = false;
        self.title = "Saved for " + USER
        
        getDataFromDB(params: ACCESS_KEY)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
  
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ratesArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "savedTableCell", for: indexPath)
        cell.textLabel?.text = ratesArray[indexPath.row]
        
        return cell
    }
    
    func getDataFromDB(params: String) {
        let ratesDB = Database.database().reference().child("rates").child((String(USER.prefix(upTo: USER.index(of: ".")!))))
        ratesDB.observe(.childAdded) { (snapshot) in
            let snapshotValue = snapshot.value as! Dictionary<String, String>
            
            let rate = snapshotValue["rate"]!
            let time = snapshotValue["time"]!
            let savedRate = rate + " " + time
            self.ratesArray.append(savedRate)

            self.tableView.reloadData()
        }
    }
}
