//
//  WeatherDataViewModel.swift
//  DVTApplicationCW
//
//  Created by Kate Waller on 2022/01/18.
//

//This ViewModel is used to get the data for the middle section that refers to min temp, max temp and displays an icon.


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
            apiKey.getWeatherDataLatLon(lat: lat, lon: lon) { weatherData in
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
    
    var forecastDescription: String {
        return weatherData!.weather.first?.description.uppercased() ?? ""
    }

    public override var forecastType: IconType {
        return forecastType(forecast: forecastMain)
    }
    

    
}
