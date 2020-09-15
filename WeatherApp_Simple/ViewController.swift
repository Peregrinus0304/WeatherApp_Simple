//
//  ViewController.swift
//  WeatherApp_Simple
//
//  Created by Ozzy on 09.09.2020.
//  Copyright © 2020 Taras Motruk. All rights reserved.
//

import UIKit
import GooglePlaces

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    
    
    //MARK: - Outlets
    
    
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var weatherLabel: UILabel!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    
    @IBOutlet weak var searchButton: CustomButton!
    
    @IBOutlet weak var weatherImageView: UIImageView!
    
    
    var weather: WeatherGetter!
    let locationManager = CLLocationManager()
 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weather = WeatherGetter(delegate: self)
        getLocation()
        searchButton.animate()
        
        
        // Initialize UI
        cityLabel.text = "simple weather"
        weatherLabel.text = ""
        temperatureLabel.text = ""
        weatherImageView.loadGif(name: "clear sky")
        
    }
    
    
    
   
  
    
    
    //MARK: - Getting location logic
    
    func getLocation() {
        guard CLLocationManager.locationServicesEnabled() else {
            print("Location services are disabled on your device. In order to use this app, go to " +
                "Settings → Privacy → Location Services and turn location services on.")
            return
        }
        
        let authStatus = CLLocationManager.authorizationStatus()
        guard authStatus == .authorizedWhenInUse else {
            switch authStatus {
                case .denied, .restricted:
                    print("This app is not authorized to use your location. In order to use this app, " +
                        "go to Settings → GeoExample → Location and select the \"While Using " +
                        "the App\" setting.")
                
                case .notDetermined:
                    locationManager.requestWhenInUseAuthorization()
                
                default:
                    print("Oops! This case should never be reached.")
            }
            return
        }
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    // This is called if:
        // - the location manager is updating, and
        // - it was able to get the user's location.
        func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            let newLocation = locations.last!
   
        }
        
        // This is called if:
        // - the location manager is updating, and
        // - it WASN'T able to get the user's location.
        func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
            DispatchQueue.main.async {
                self.showSimpleAlert(title: "Can't determine your location",
                                          message: "The GPS and other location services aren't responding.")
            }
            print("Error: \(error)")
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

//MARK: - AutocompleteViewController Delegate

extension ViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    public func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        var selectedCity = place.name?.urlEncoded ?? "UncnownLocation"
        weather.getWeatherByCity(city: selectedCity)
        dismiss(animated: true, completion: nil)
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

//MARK: - WeatherGetter Delegate

extension ViewController: WeatherGetterDelegate {
    func didGetWeather(weather: Weather) {
        DispatchQueue.main.async {
            self.cityLabel.text = weather.city
            self.weatherLabel.text = weather.weatherDescription
            self.temperatureLabel.text = "\(Int(round(weather.tempCelsius)))°"
        }
    }
    
    func didNotGetWeather(error: NSError) {
        DispatchQueue.main.async {
            self.showSimpleAlert(title: "Can't get the weather",
                                 message: "The weather service isn't responding.")
            
            print("didNotGetWeather error: \(error)")
        }
    }
}


// MARK: - CLLocationManagerDelegate methods







//MARK: - String encoding

extension String {
    
    // A handy method for %-encoding strings containing spaces and other
    // characters that need to be converted for use in URLs.
    var urlEncoded: String {
        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
    }
    
}



