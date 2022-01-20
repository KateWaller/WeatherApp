//
//  WeatherDetailsViewModel.swift
//  DVTApplicationCW
//
//  Created by Kate Waller on 2022/01/18.
//

import Foundation

class WeatherDetailsViewModel {
    
    enum IconType: String {
        case cloudy = "CLOUDY"
        case rainy = "RAINY"
        case sunny = "SUNNY"
    }
    
    
    let forecastIconImage: Dictionary< IconType, String> =
        [.cloudy: "partlysunny",
          .rainy: "rain",
          .sunny: "clear"]
    
    var lat: Double? = nil
    var lon: Double? = nil

   func setLocation(lat: Double, lon: Double) {
        self.lat = lat
        self.lon = lon
    }
    
    func forecastType(forecast: String) -> IconType {
        switch (forecast) {
        case "CLOUDS": return .cloudy
        case "RAIN": return .rainy
        default: return .sunny
        }
}
    
    var forecastType: IconType {
        return forecastType(forecast: "")
    }

    func formatTemperature(temp: Double) -> String {
        return "\(Int(round(temp)))\u{00B0}"    //rounded temperature + degree symbol
    }
}
