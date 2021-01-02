//
//  DailyCollectionViewCell.swift
//  WeatherApp_Simple
//
//  Created by Ozzy on 09.11.2020.
//  Copyright © 2020 Taras Motruk. All rights reserved.
//

import UIKit

class DailyCollectionViewCell: UICollectionViewCell {
   
    //MARK: - IBOutlet
    
    @IBOutlet weak var weekdayNameLabel: UILabel!
    @IBOutlet weak var minDailyTempLabel: UILabel!
    @IBOutlet weak var maxDailyTempLabel: UILabel!
    
    var dailyWeather: DailyWeather! {
        didSet{
            weekdayNameLabel.text = dailyWeather.dailyDateAndTime
            minDailyTempLabel.text = "min:\(dailyWeather.dailyMinTemp)°"
            maxDailyTempLabel.text = "max:\(dailyWeather.dailyMaxTemp)°"
        }
    }
    
}
