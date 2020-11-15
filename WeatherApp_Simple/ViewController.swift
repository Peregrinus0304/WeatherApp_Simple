//
//  ViewController.swift
//  WeatherApp_Simple
//
//  Created by Ozzy on 09.09.2020.
//  Copyright © 2020 Taras Motruk. All rights reserved.
//

import UIKit
import GooglePlaces
import CoreLocation


private let dateFormatter: DateFormatter = {
    let  dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE, MMM d, h:mm aaa"
    return dateFormatter
}()

class ViewController: UIViewController {
 
    
    
    
    //MARK: - Outlets
    

   
    @IBOutlet weak var blurredView: UIVisualEffectView!
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var searchButton: CustomButton!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var hourlyTableView: UITableView!
    @IBOutlet weak var dailyCollectionView: UICollectionView!
    
    
    var weatherDetail: WeatherDetail!
     var locationManager:CLLocationManager!
     var dataReceived = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       getLocation()
        hourlyTableView.delegate = self
        hourlyTableView.dataSource = self
        dailyCollectionView.delegate = self
         dailyCollectionView.dataSource = self
         searchButton.animate()
        blurredView.layer.cornerRadius = 15
        blurredView.layer.borderWidth = 3
         blurredView.layer.borderColor = CGColor(srgbRed: 153, green: 255, blue: 255, alpha: 1)
        
     
        // Initialize UI
        cityLabel.text = ""
        weatherLabel.text = ""
        temperatureLabel.text = ""
        weatherImageView.loadGif(name: "default weather")
        
       
    }
    
    
    //MARK: - AutocompleteVC logic
    
    // Present the Autocomplete view controller when the button is pressed.
    func autocompleteClicked(_ sender: UIButton) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        
        let filter = GMSAutocompleteFilter()
        filter.type = .city
         autocompleteController.autocompleteFilter = filter
        
        // Display the autocomplete view controller.
        present(autocompleteController, animated: true, completion: nil)
    }
    
   @IBAction func searchPressed(_ sender: CustomButton) {
          autocompleteClicked(sender)
   
      }
    
    func showSimpleAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(
            title: "OK",
            style:  .default,
            handler: nil
        )
        alert.addAction(okAction)
        present(
            alert,
            animated: true,
            completion: nil
        )
    }
}


// MARK: - CLLocationManagerDelegate
  
  
  extension ViewController: CLLocationManagerDelegate {
     
    func getLocation() {
    locationManager = CLLocationManager()
        locationManager.delegate = self
    }
     
      func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
           switch status {
                 
                 case .notDetermined:
                     locationManager.requestWhenInUseAuthorization()
                 case .restricted:
                     self.showSimpleAlert(title: "Location access is restricted", message: "This app is not authorized to use your location. In order to use this app, " +
                     "go to Settings → WeatherApp_Simple → Location and select the \"While Using " +
                     "the App\" setting.")
                 case .denied:
                   break
                 case .authorizedAlways:
                     locationManager.requestLocation()
                    
                 case .authorizedWhenInUse:
                     locationManager.requestLocation()
             
                 @unknown default:
                     print(status)
                 }
      }
      
      func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
            let currentLocation = locations.last ?? CLLocation()
         let geoCoder = CLGeocoder()
                geoCoder.reverseGeocodeLocation(currentLocation) { (placeMarks, error) in
                    var locationName = ""
                    if placeMarks != nil{
                        let placeMark = placeMarks?.last
                        locationName = placeMark?.name ?? ""
                    } else {
                        locationName = "Не можу знайти міцезнаходження"
                    }
                  print(currentLocation)
                    self.weatherDetail = WeatherDetail(name: locationName, latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
                    self.cityLabel.text = locationName
                    self.weatherDetail.getData {
                                       DispatchQueue.main.async {
                                           dateFormatter.timeZone = TimeZone(identifier: self.weatherDetail.timezone)
                                           let usableDate = Date(timeIntervalSince1970: self.weatherDetail.currentTime)
                                           //self.dataLabel.text = dateFormatter.string(from: usableDate)
                                          self.weatherLabel.text = self.weatherDetail.summary
                                           self.temperatureLabel.text = "\(self.weatherDetail.temperature)°"
                                          self.weatherImageView.loadGif(name: setUpBackground(IconID: self.weatherDetail.dayIcon))
                                          self.weatherIconImageView.image = UIImage(named: self.weatherDetail.dayIcon)
                                        self.dataReceived = true
                                        self.hourlyTableView.reloadData()
                                        self.dailyCollectionView.reloadData()
                                       }
                                   }
                    
                }
          
       
      }
      
      
      func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
          
          DispatchQueue.main.async {
              self.showSimpleAlert(title: "Can't determine your location",
                                        message: "The GPS and other location services aren't responding.")
          }
        print("LocationManager didFailWithError \(error.localizedDescription)")
        if let error = error as? CLError, error.code == .denied {
           // Location updates are not authorized.
          // To prevent forever looping of `didFailWithError` callback
           locationManager?.stopMonitoringSignificantLocationChanges()
           return
        }
      }
      
      
  } //end

//MARK: - AutocompleteViewController Delegate

extension ViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    public func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        var selectedCity = place.name?.urlEncoded ?? "UncnownLocation"
        weatherDetail = WeatherDetail(name: selectedCity, latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        dismiss(animated: true, completion: nil)
                         self.cityLabel.text = place.name
        weatherDetail.getData {
                     DispatchQueue.main.async {
                         dateFormatter.timeZone = TimeZone(identifier: self.weatherDetail.timezone)
                         let usableDate = Date(timeIntervalSince1970: self.weatherDetail.currentTime)
                         //self.dataLabel.text = dateFormatter.string(from: usableDate)
                        self.weatherLabel.text = self.weatherDetail.summary
                         self.temperatureLabel.text = "\(self.weatherDetail.temperature)°"
                        self.weatherImageView.loadGif(name: setUpBackground(IconID: self.weatherDetail.dayIcon))
                        self.weatherIconImageView.image = UIImage(named: self.weatherDetail.dayIcon)
                        self.dataReceived = true
                         self.hourlyTableView.reloadData()
                        self.dailyCollectionView.reloadData()
                     }
                 }
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}


// MARK: - HourlyTableView protocols
extension ViewController: UITableViewDelegate, UITableViewDataSource {
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if dataReceived == true {
            return weatherDetail.hourlyWeatherData.count
        } else {
            return 1
        }
        
        
        }
     
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
               let cell = hourlyTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! HourlyTableViewCell
               
            if dataReceived == true {
                cell.hourlyWeather = weatherDetail.hourlyWeatherData[indexPath.row] } else {
                return cell
            }
                return cell
           }
     
     

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
    
// MARK: - DailyCollectionView protocols
extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       if dataReceived == true {
        return weatherDetail.dailyWeatherData.count
       } else {
           return 1
       }

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DailyCell", for: indexPath) as! DailyCollectionViewCell
        cell.layer.cornerRadius = 15
        cell.layer.borderColor = CGColor(srgbRed: 153, green: 255, blue: 255, alpha: 1)
    
        cell.layer.borderWidth = 3
        
        if dataReceived == true {
                       cell.dailyWeather = weatherDetail.dailyWeatherData[indexPath.row] } else{
                       return cell
                   }
        
        return cell
    }
}




// MARK: - Managing background animation

func setUpBackground(IconID: String) -> String {
    var  gifTitle = ""
    
    switch IconID {
        case "01d":
        gifTitle = "clear sky"
        case "01n":
        gifTitle = "clear sky night"
        case "02d", "03d", "04d":
        gifTitle = "clouds"
        case "02n", "03n", "04n":
        gifTitle = "clouds night"
        case "09d", "10d":
        gifTitle = "rain day"
        case "09n", "10n":
        gifTitle = "rain night"
        case "11d", "11n":
        gifTitle = "thunderstorm"
        case "13d":
        gifTitle = "snow"
        case "13n":
        gifTitle = "snow night"
        case "50d":
        gifTitle = "mist"
        case "50d":
        gifTitle = "mist night"
        default:
        gifTitle = "default weather"
    }
    
   
    return gifTitle
}




//MARK: - String encoding

extension String {
    
    // A handy method for %-encoding strings containing spaces and other
    // characters that need to be converted for use in URLs.
    var urlEncoded: String {
        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
    }
    
}




