//
//  FirstViewController.swift
//  Carvest
//
//  Created by Mamadou Kaba on 9/11/15.
//  Copyright (c) 2015 Mamadou Kaba. All rights reserved.
//

import UIKit

class TelevisionViewController: UITableViewController {
    var brandName = [String]()
    var estimatedEnergyUsage = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        getTVBrandname()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    let TVURL = "https://data.energystar.gov/api/views/n6gj-5es2/rows.json?accessType=DOWNLOAD"
    var tvEstimateEnergyUsage: [JSON]?
    
    func getTVBrandname() {
        let url = NSURL(string: TVURL)!
        
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) {(data, response, error) in
        
            var serializationerror: NSError?
            var tvDataArray: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &serializationerror)
            let json = JSON(data: data)
            //println(json["meta"]["view"]["columns"][10]["cachedContents"]["top"])
            
            if let tvbrandname = json["meta"]["view"]["columns"][10]["cachedContents"]["top"].array {
                for MyDictionary in tvbrandname {
                    //println(MyDictionary["item"])
                    
                    self.brandName.append(MyDictionary["item"].string!)
                }
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.tableView.reloadData()
                })
            }
        
            self.tvEstimateEnergyUsage = json["meta"]["view"]["columns"][44]["cachedContents"]["top"].array
            if let tvEstimateEnergyUsage = self.tvEstimateEnergyUsage {
                for item in tvEstimateEnergyUsage {
                    if let itemDictionary = item.dictionary {
                        let item = itemDictionary["item"]!.string!
                        self.estimatedEnergyUsage.append(item)
                    }
                }
            }

          }
        task.resume()
            
        
        
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.brandName.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell

        cell.textLabel?.text = brandName[indexPath.row]
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "EnergyUsage" {
            if let vc = segue.destinationViewController as? EnergyUsageViewController {
                
                let path = self.tableView.indexPathForSelectedRow()!
                var brand = Brand()
                brand.typeofEnergy = "TV"
                brand.energyUsage = self.estimatedEnergyUsage[path.row]
                brand.name = self.brandName[path.row]
                vc.brand = brand
            }
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("EnergyUsage", sender: nil)
        
    }

    


}