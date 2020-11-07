//
//  WeatherGetter.swift
//  WeatherApp_Simple
//
//  Created by Ozzy on 29.10.2020.
//  Copyright © 2020 Taras Motruk. All rights reserved.
//


import Foundation

class WeatherLocation: Codable {
    var name: String
    var latitude: Double
    var longitude: Double
 
    init(name: String, latitude: Double, longitude: Double) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }
}
