//
//  ExtensionString.swift
//  WeatherApp_Simple
//
//  Created by Ozzy on 06.01.2021.
//  Copyright © 2021 Taras Motruk. All rights reserved.
//

import Foundation

//String encoding

extension String {
    
    // A handy method for %-encoding strings containing spaces and other
    // characters that need to be converted for use in URLs.
    var urlEncoded: String {
        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
    }
    
}
