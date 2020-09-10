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
        do {
          // Try to convert that data into a Swift dictionary
            let weather = try JSONSerialization.jsonObject(
                with: data!,
                options: .mutableContainers) as! [String: AnyObject]
         
          // If we made it to this point, we've successfully converted the
          // JSON-formatted weather data into a Swift dictionary.
          // Let's print its contents to the debug console.
          print("Date and time: \(weather["dt"]!)")
          print("City: \(weather["name"]!)")

          print("Longitude: \(weather["coord"]!["lon"]!!)")
          print("Latitude: \(weather["coord"]!["lat"]!!)")

          print("Weather ID: \((weather["weather"]![0]! as! [String:AnyObject])["id"]!)")
          print("Weather main: \((weather["weather"]![0]! as! [String:AnyObject])["main"]!)")
          print("Weather description: \((weather["weather"]![0]! as! [String:AnyObject])["description"]!)")
          print("Weather icon ID: \((weather["weather"]![0]! as! [String:AnyObject])["icon"]!)")

          print("Temperature: \(weather["main"]!["temp"]!!)")
          print("Humidity: \(weather["main"]!["humidity"]!!)")
          print("Pressure: \(weather["main"]!["pressure"]!!)")

          print("Cloud cover: \(weather["clouds"]!["all"]!!)")

          print("Wind direction: \(weather["wind"]!["deg"]!!) degrees")
          print("Wind speed: \(weather["wind"]!["speed"]!!)")

          print("Country: \(weather["sys"]!["country"]!!)")
          print("Sunrise: \(weather["sys"]!["sunrise"]!!)")
          print("Sunset: \(weather["sys"]!["sunset"]!!)")
        }
        catch let jsonError as NSError {
          // An error occurred while trying to convert the data into a Swift dictionary.
          print("JSON error description: \(jsonError.description)")
        }
        
        }
    }

    // The data task is set up…launch it!
    dataTask.resume()
    }
    }
