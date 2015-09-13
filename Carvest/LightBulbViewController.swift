//
//  SecondViewController.swift
//  Carvest
//
//  Created by Mamadou Kaba on 9/11/15.
//  Copyright (c) 2015 Mamadou Kaba. All rights reserved.
//

import UIKit

class LightBulbViewController: UITableViewController {
    var lightBulbBrand = [String]()
    var lightEnergyUsage = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        getLightBulbBrandName()
        self.view.backgroundColor = UIColor(red: 20/255, green: 70/255, blue: 128/255, alpha: 1.00)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    let lightBulbURL = "https://data.energystar.gov/api/views/v33x-ybr3/rows.json?accessType=DOWNLOAD"
    var lightEnergyUsedWatts: [JSON]?
    
    func getLightBulbBrandName() {
        let url = NSURL(string: lightBulbURL)
        
        let indicator = UIActivityIndicatorView(frame: self.view.bounds)
        self.view.addSubview(indicator)
        indicator.startAnimating()
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            var serializationerror: NSError?
            var lightBulbDataArray: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &serializationerror)
            let json = JSON(data: data)
            //print(json)
            
            if let lightBulbBrandNames = json["meta"]["view"]["columns"][10]["cachedContents"]["top"].array {
                for lightbulbDictionary in lightBulbBrandNames {
                    self.lightBulbBrand.append(lightbulbDictionary["item"].string!)
                }
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.tableView.reloadData()
                })
            }
            
            if let energyUsed = json["meta"]["view"]["columns"][27]["cachedContents"]["top"].array {
                for watts in energyUsed {
                    self.lightEnergyUsage.append(watts["item"].string!)
                    
                            
                            }
                        }
            indicator.removeFromSuperview()
        }
        task.resume()
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.lightBulbBrand.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        
        cell.textLabel?.text = lightBulbBrand[indexPath.row]
        cell.textLabel?.font = UIFont(name: "Arial-BoldMT", size: 16)
        cell.textLabel?.textColor = UIColor.whiteColor()
        cell.textLabel?.shadowColor = UIColor.blackColor()
        cell.textLabel?.shadowOffset = CGSizeMake(0,1)
        cell.backgroundColor = colors[indexPath.row]
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "LightEneryUsage" {
            if let vc = segue.destinationViewController as? EnergyUsageViewController {
                
                let path = self.tableView.indexPathForSelectedRow()!
                var brand = Brand()
                brand.typeofEnergy = "Light"
                brand.energyUsage = self.lightEnergyUsage[path.row]
                brand.name = self.lightBulbBrand[path.row]
                vc.brand = brand
                vc.view.backgroundColor = colors[path.row]
            }
        }
    }
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView.new()
    }
}

