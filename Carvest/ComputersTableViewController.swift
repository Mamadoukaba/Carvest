//
//  ACTableViewController.swift
//  Carvest
//
//  Created by Mamadou Kaba on 9/13/15.
//  Copyright (c) 2015 Mamadou Kaba. All rights reserved.
//

import UIKit

class ComputersTableViewController: UITableViewController {
    var computerBrand = [String]()
    var computerenergys = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getComputerBrandName()
        self.view.backgroundColor = UIColor(red: 20/255, green: 70/255, blue: 128/255, alpha: 1.00)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    let ComputerURL = "https://data.energystar.gov/api/views/ed9u-v8cw/rows.json?accessType=DOWNLOAD"
    
    func getComputerBrandName() {
        let url = NSURL(string: ComputerURL)
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            var serializationerror: NSError?
            var ComputerDataArray: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &serializationerror)
            let json = JSON(data: data)
            
            if let computerBrandNames = json["meta"]["view"]["columns"][10]["cachedContents"]["top"].array {
                for computerBrandz in computerBrandNames {
                    self.computerBrand.append(computerBrandz["item"].string!)
                }
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.tableView.reloadData()
                })
            }
            
            if let computerEnergyUsage = json["meta"]["view"]["columns"][47]["cachedContents"]["top"].array {
                for computerEnergy in computerEnergyUsage {
                    self.computerenergys.append(computerEnergy["item"].string!)
                }
            }
        }
        task.resume()
    }
    

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.computerBrand.count
        
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        
        cell.textLabel?.text = computerBrand[indexPath.row]
        cell.textLabel?.font = UIFont(name: "Arial-BoldMT", size: 16)
        cell.textLabel?.textColor = UIColor.whiteColor()
        cell.textLabel?.shadowColor = UIColor.blackColor()
        cell.textLabel?.shadowOffset = CGSizeMake(0,1)
        cell.backgroundColor = colors[indexPath.row]
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ComputerEnergyUsage" {
            if let vc = segue.destinationViewController as? EnergyUsageViewController {
                let path = self.tableView.indexPathForSelectedRow()!
                var brand = Brand()
                brand.typeofEnergy = "Computer"
                brand.energyUsage = self.computerenergys[path.row]
                brand.name = self.computerBrand[path.row]
                vc.brand = brand
                vc.view.backgroundColor = colors[path.row]
            }
        }
    }
}
