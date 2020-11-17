//
//  HourlyTableViewCell.swift
//  WeatherApp_Simple
//
//  Created by Ozzy on 18.10.2020.
//  Copyright © 2020 Taras Motruk. All rights reserved.
//

import UIKit

class HourlyTableViewCell: UITableViewCell {

    @IBOutlet weak var hourlyImageView: UIImageView!
    @IBOutlet weak var hourlyDateAndTimeLabel: UILabel!
    @IBOutlet weak var hourlyWeatherDescriptionTextView: UITextView!
    @IBOutlet weak var hourlyTempLabel: UILabel!

    
        var hourlyWeather: HourlyWeather! {
            didSet{
                hourlyImageView.image = UIImage(named: hourlyWeather.hourlyIcon)
                hourlyDateAndTimeLabel.text = hourlyWeather.hour
                hourlyWeatherDescriptionTextView.text = hourlyWeather.hourlySummary
                hourlyTempLabel.text = "\(hourlyWeather.hourlyTemp)°"
              
                   }
            }
        
        override func awakeFromNib() {
            super.awakeFromNib()
            // Initialization code
        }

    }
