//
//  WeatherGetterModel.swift
//  WeatherApp_Simple
//
//  Created by Ozzy on 10.09.2020.
//  Copyright © 2020 Taras Motruk. All rights reserved.
//

import Foundation
  
class WeatherGetter {
  
  private let openWeatherMapBaseURL = "http://api.openweathermap.org/data/2.5/weather"
  private let openWeatherMapAPIKey = "13ca86f4093bca85ed6083e5802a8414"
  
  func getWeather(city: String) {
    
    // This is a pretty simple networking task, so the shared session will do.
    let session = URLSession.shared
    
    let weatherRequestURL = NSURL(string: "\(openWeatherMapBaseURL)?APPID=\(openWeatherMapAPIKey)&q=\(city)")!
    
    // The data task retrieves the data.
    let dataTask = session.dataTask(with: weatherRequestURL as URL) {
    (data,response,error) -> Void in
    if let error = error {
        print("Error:\(error)")
    }
    else {
        print("Response:\(response)")    }
    }

    // The data task is set up…launch it!
    dataTask.resume()
    }
    }
