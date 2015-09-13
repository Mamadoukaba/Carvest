//
//  EnergyUsageViewController.swift
//  Carvest
//
//  Created by Mamadou Kaba on 9/12/15.
//  Copyright (c) 2015 Mamadou Kaba. All rights reserved.
//

import UIKit

class EnergyUsageViewController: UIViewController {
    
    var brand: Brand?
    @IBOutlet weak var textLabel: UILabel!
    
    @IBOutlet weak var brandtextLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let brand = brand {
            brandtextLabel.text = "\(brand.name) uses an yearly estimated average of:"
        }
        
        if brand?.typeofEnergy == "TV" {
            textLabel.text = "\(brand!.energyUsage) Kwh"
        } else if brand?.typeofEnergy == "Light" {
           let lightEnergyFloat = (brand!.energyUsage as NSString).floatValue
            let totalLightEnergy = lightEnergyFloat * 8 * 365
           textLabel.text = "\(totalLightEnergy) Wh"
        } else {
            let computerEnergyFloat = (brand!.energyUsage as NSString).floatValue
            let totalComputerEnergy = computerEnergyFloat * 8 * 365
            textLabel.text = "\(totalComputerEnergy) Wh"
        }
    }
    
        

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
