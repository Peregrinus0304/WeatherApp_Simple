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

}
