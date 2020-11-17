//
//  WeatherGetter.swift
//  WeatherApp_Simple
//
//  Created by Ozzy on 29.10.2020.
//  Copyright © 2020 Taras Motruk. All rights reserved.
//


import Foundation

private let dateFormatter: DateFormatter = {
    let  dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE"
    return dateFormatter
}()

private let hourlyFormatter: DateFormatter = {
    let  hourlyFormatter = DateFormatter()
    hourlyFormatter.dateFormat = "ha"
    return hourlyFormatter
}()

class WeatherDetail: WeatherLocation{
    
    //MARK: - Struct
    private struct Result: Codable{
        var timezone: String
        var current: Current
        var daily: [Daily]
        var hourly: [Hourly]
    }
    
   private struct Current: Codable {
        var dt: TimeInterval
        var temp: Double
        var weather: [Weather]
    }
    
   private struct Weather:Codable {
        var description: String
        var icon: String
        var id: Int
    }
    
   private struct Daily: Codable {
        var dt: TimeInterval
        var temp: Temp
        var weather: [Weather]
    }
    
    private struct Hourly: Codable {
        var dt: TimeInterval
        var temp: Double
        var weather: [Weather]
    }
    
   private struct Temp: Codable {
        var max: Double
        var min: Double
    }
    
//MARK: - Reference
    
    var currentTime = ""
    var temperature = 0
    var summary = ""
    var dayIcon = ""
    var timezone = ""
    var dailyWeatherData: [DailyWeather] = []
    var hourlyWeatherData: [HourlyWeather?] = []
        
//MARK: - Parsing
    
    func getData(completed: @escaping () -> ()){
       let openWeatherMapAPIKey = "13ca86f4093bca85ed6083e5802a8414"
        let urlString =
        "https://api.openweathermap.org/data/2.5/onecall?lat=\(latitude)&lon=\(longitude)&exclude=minutely&units=imperial&lang=ua&appid=\(openWeatherMapAPIKey)"
        print(urlString)
    
    // create a URL
        guard let url = URL(string: urlString) else {
            print("No data")
        return
        }
    
    // Create session
        let session = URLSession.shared
    
    // Get data with .dataTask method
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error{
            print("ERROR!\(error.localizedDescription)")
            }
            do {
                let result = try JSONDecoder().decode(Result.self, from: data!)
                self.timezone = result.timezone
                let unformattedDateAndTime = Date(timeIntervalSince1970: result.current.dt)
                self.currentTime = hourlyFormatter.string(from: unformattedDateAndTime)
                self.temperature = self.calculateCelsius(fahrenheit: result.current.temp.rounded())
                self.summary = result.current.weather[0].description
                self.dayIcon = result.current.weather[0].icon
                for index in 0..<result.daily.count {
                    let weekdayDate = Date(timeIntervalSince1970: result.daily[index].dt)
                    dateFormatter.timeZone = TimeZone(identifier: result.timezone)
                    let dailyDateAndTime = dateFormatter.string(from: weekdayDate)
                    
                    //let dailySummary = result.daily[index].weather[0].description
                    let dailyMaxTemp = self.calculateCelsius(fahrenheit: result.daily[index].temp.max.rounded())
                    let dailyMinTemp = self.calculateCelsius(fahrenheit: result.daily[index].temp.min.rounded())
                    
                    let dailyWeather = DailyWeather(dailyDateAndTime: dailyDateAndTime, dailyMinTemp: dailyMinTemp, dailyMaxTemp: dailyMaxTemp)
                    self.dailyWeatherData.append(dailyWeather)
                }
                let lastHour = min(24, result.hourly.count)
               if lastHour > 0 {
                    for index in 0..<result.hourly.count {
                        let hourlyDay = Date(timeIntervalSince1970: result.hourly[index].dt)
                        hourlyFormatter.timeZone = TimeZone(identifier: result.timezone)
                        let hour = hourlyFormatter.string(from: hourlyDay)
                        let hourlySummary = result.hourly[index].weather[0].description
                        let hourlyIcon =  result.hourly[index].weather[0].icon
                        let hourlyTemp = self.calculateCelsius(fahrenheit: result.hourly[index].temp.rounded())
                        let hourlyWeather = HourlyWeather(hour: hour, hourlySummary: hourlySummary, hourlyIcon: hourlyIcon, hourlyTemp: hourlyTemp)
                        self.hourlyWeatherData.append(hourlyWeather)
                    }
                }
                print(result)
            } catch {
            print("ERROR: \(error.localizedDescription)")
            }
            completed()
        }
        
        task.resume()
    }
    
    func calculateCelsius(fahrenheit: Double) -> Int {
        var celsius: Int
        
        celsius = Int((fahrenheit - 32) * 5 / 9)
        
        return celsius
    }
}
