//
//  WeatherLocation.swift
//  WeatherGift
//
//  Created by oliver naser on 11/7/17.
//  Copyright © 2017 oliver naser. All rights reserved.
//

import Foundation

class WeatherLocaiton: Codable {
    var name: String
    var coordinates: String
    
    init(name: String, coordinates: String) {
        self.name = name
        self.coordinates = coordinates
    }
}
