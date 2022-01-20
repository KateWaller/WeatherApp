//
//  WeatherDataViewModel.swift
//  DVTApplicationCW
//
//  Created by Kate Waller on 2022/01/18.
//

import Foundation

class WeatherDataViewModel: WeatherDetailsViewModel {
    
    var weatherData: WeatherData?
    
    public override init() {
        self.weatherData = nil
    }
    
    public init(weatherData: WeatherData?) {
        self.weatherData = weatherData
    }
    
    func getWeatherData(completion: @escaping (_ success: Bool) -> Void = { success in }) {
        if let lat = self.lat, let lon = self.lon {
            APIKEy.getWeatherDataLatLon(lat: lat, lon: lon) { weatherData in
                self.weatherData = weatherData
                
                let success = (weatherData != nil)
                completion(success)
            }
        } else {
            print("Error")
        }
    }
    
    func hasData() -> Bool {
        return weatherData != nil
    }

    //Return a default value if weatherData not set, alternatively we could use "weatherData!." and rather cause a runtime error when called!
    var temp: Double {
        return weatherData?.main.temp ?? 0
    }

    var tempMin: Double {
        return weatherData?.main.temp_min ?? 0
    }
    
    var tempMax: Double {
        return weatherData?.main.temp_max ?? 0
    }
    
    var tempLabelText: String {
        return formatTemperature(temp: temp)
    }
    
    var tempMinLabelText: String {
        return formatTemperature(temp: tempMin)
    }
    
    var tempMaxLabelText: String {
        return formatTemperature(temp: tempMax)
    }

    var locationName: String {
        return weatherData?.name ?? ""
    }
    
    var forecastMain: String {
        return weatherData!.weather.first?.main.uppercased() ?? ""
    }
    
    public var forecastDescription: String {
        //return weatherData!.weather.first(where: { ($0.id == 500) || ($0.id == 501) })?.description.uppercased() ?? ""
        return weatherData!.weather.first?.description.uppercased() ?? ""
    }

    public override var forecastType: IconType {
        return forecastType(forecast: forecastMain)
    }

//    public var _weatherData: WeatherData? { //Useful to have access to this data during Unit Tests, etc.
//        return self.weatherData
//    }
    
}
