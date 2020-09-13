//
//  ViewController.swift
//  WeatherApp_Simple
//
//  Created by Ozzy on 09.09.2020.
//  Copyright © 2020 Taras Motruk. All rights reserved.
//

import UIKit
import GooglePlaces

class ViewController: UIViewController {
   
    

    //MARK: - Outlets
    
    @IBOutlet weak var searchButton: CustomButton!
    
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var weatherLabel: UILabel!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    
    
    
    var weather: WeatherGetter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    weather = WeatherGetter(delegate: self)
        
        
    // Initialize UI
         cityLabel.text = "simple weather"
         weatherLabel.text = ""
         temperatureLabel.text = ""
        
    }

 
    
    
    //MARK: - AutocompleteVC logic
    
    // Present the Autocomplete view controller when the button is pressed.
    func autocompleteClicked(_ sender: UIButton) {
      let autocompleteController = GMSAutocompleteViewController()
      autocompleteController.delegate = self

      // Specify the place data types to return.
      let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
        UInt(GMSPlaceField.placeID.rawValue))!
      autocompleteController.placeFields = fields

      // Specify a filter.
      let filter = GMSAutocompleteFilter()
      filter.type = .address
      autocompleteController.autocompleteFilter = filter

      // Display the autocomplete view controller.
      present(autocompleteController, animated: true, completion: nil)
    }
    
    @IBAction func searchPressed(_ sender: CustomButton) {
        sender.animate()
        autocompleteClicked(sender)
        weather.getWeatherByCity(city: "Warsaw".urlEncoded)
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
  func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
    print("Place name: \(place.name)")
    print("Place ID: \(place.placeID)")
    print("Place attributions: \(place.attributions)")
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

  extension String {
    
    // A handy method for %-encoding strings containing spaces and other
    // characters that need to be converted for use in URLs.
    var urlEncoded: String {
        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
    }
    
  }

 
 
