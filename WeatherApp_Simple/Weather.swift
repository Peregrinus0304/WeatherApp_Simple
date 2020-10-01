import Foundation
 
struct Weather {
  
 // Location properties
  let longitude: Double
  let latitude: Double

 // Current weather properties
  let currentDateAndTime: NSDate
  let currentTemp: Double
    var tempCelsius: Double {
    get {
      return currentTemp - 273.15
    }
    }
  let currentWeatherID: Int
  let currentMainWeather: String
  let currentWeatherDescription: String
  let currentWeatherIconID: String
  
 // Daily weather properties
    let dailyDateAndTime: NSDate
    let dailyMinTemp: Double
    let dailyMaxTemp: Double
    
 // Hourly weather properties
    let hourlyTime: NSDate
    let hourlyTemp: Double
    let hourlyWeatherID: Int
    let hourlyMainWeather: String
    let hourlyWeatherDescription: String
    let hourlyWeatherIconID: String
    
    
  init(weatherData: [String: AnyObject]) {
    
   
    longitude = weatherData["lon"] as! Double
    latitude = weatherData["lat"] as! Double

    // Current weather data parsing
    let currentDict = weatherData["current"] as! [String: AnyObject]
    currentDateAndTime = NSDate(timeIntervalSince1970: currentDict["dt"] as! TimeInterval)
    currentTemp = currentDict["temp"] as! Double
    
    let currentWeatherDict = currentDict["weather"]![0] as! [String: AnyObject]
    currentWeatherID = currentWeatherDict["id"] as! Int
    currentMainWeather = currentWeatherDict["main"] as! String
    currentWeatherDescription = currentWeatherDict["description"] as! String
    currentWeatherIconID = currentWeatherDict["icon"] as! String
    
    // Daily weather data parsing
    let dailyDict = weatherData["daily"]![0] as! [String: AnyObject]
    dailyDateAndTime = NSDate(timeIntervalSince1970: dailyDict["dt"] as! TimeInterval)
    
    let dailyTempDict = dailyDict["temp"] as! [String: AnyObject]
    dailyMinTemp = dailyTempDict["min"] as! Double
    dailyMaxTemp = dailyTempDict["max"] as! Double
    
    // Hourly weather data parsing
     let hourlyDict = weatherData["hourly"]![0] as! [String: AnyObject]
    hourlyTime = NSDate(timeIntervalSince1970: hourlyDict["dt"] as! TimeInterval)
    hourlyTemp = hourlyDict["temp"] as! Double
    
    let hourlyWeatherDict = hourlyDict["weather"]![0] as! [String: AnyObject]
    hourlyWeatherID = currentWeatherDict["id"] as! Int
       hourlyMainWeather = currentWeatherDict["main"] as! String
       hourlyWeatherDescription = currentWeatherDict["description"] as! String
       hourlyWeatherIconID = currentWeatherDict["icon"] as! String
    }
  
}

 
