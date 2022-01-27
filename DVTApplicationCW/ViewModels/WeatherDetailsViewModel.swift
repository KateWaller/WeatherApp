//
//  WeatherDetailsViewModel.swift
//  DVTApplicationCW
//
//  Created by Kate Waller on 2022/01/18.
//

//This ViewModel populates the top weather view and is also used to change the background image depending on the current weather. There are many different variables in OpenWeatherMap on which you could base the background image on.

//The background colour of the table is also based on the weather forecast. 

import Foundation

class WeatherDetailsViewModel {
    
    enum IconType: String {
        case cloudy = "CLOUDY"
        case rainy = "RAINY"
        case sunny = "SUNNY"
    }
    
    typealias BackImageInfo = (imageName: String, backHexColor: String)
    
    let Display: Dictionary <IconType, BackImageInfo> =
        [.cloudy: (imageName: "forest_cloudy", backHexColor: "#54717A"),
        .rainy: (imageName: "forest_rainy", backHexColor: "#57575D"),
        .sunny: (imageName: "forest_sunny", backHexColor: "#47AB2F")]
    
    
    let forecastImage: Dictionary< IconType, String> =
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
    
    var backgroundImageName: String {
        return Display[forecastType]!.imageName
    }
    
    public var backgroundHexColor: String {
        return Display[forecastType]!.backHexColor
    }

    func formatTemperature(temp: Double) -> String {
        return "\(Int(round(temp)))\u{00B0}"    //rounded temperature + degree symbol
    }
}
