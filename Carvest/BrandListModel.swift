//
//  BrandListModel.swift
//  Carvest
//
//  Created by Mamadou Kaba on 9/12/15.
//  Copyright (c) 2015 Mamadou Kaba. All rights reserved.
//

import Foundation

class BrandList {
    var brandname: String?
    
    init(json: NSDictionary) {
        self.brandname = json["Brand Name"]?.string
    }
}
