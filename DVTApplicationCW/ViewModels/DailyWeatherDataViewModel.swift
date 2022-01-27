//
//  DailyWeatherDataViewModel.swift
//  DVTApplicationCW
//
//  Created by Kate Waller on 2022/01/18.
//

//Create a daily weather data view model to get weather for table view. This ViewModel will populate the table for the forecast for the next few days.

import Foundation

class DailyWeatherDataViewModel: WeatherDetailsViewModel {

    var dailyWeatherData: DailyWeatherData?
    var weeklyForecast: [DailyTemp] = []
    
    public override init() {
        self.dailyWeatherData = nil
    }
    
    public init(dailyWeatherData: DailyWeatherData) {
        self.dailyWeatherData = dailyWeatherData
    }
    
    func getDailyWeatherData(completion: @escaping (_ success: Bool) -> Void = { success in }) {
        if let lat = self.lat, let lon = self.lon {
            apiKey.forecastDataLatLon(lat: lat, lon: lon) { dailyWeatherData in
                self.dailyWeatherData = dailyWeatherData
                self.weeklyForecast = self.getWeeklyForecast()

                let success = (dailyWeatherData != nil)
                completion(success)
            }
            
        }else {
            print("Error")
        }
    }
        
        func getWeeklyForecast() -> [DailyTemp] {
            return dailyWeatherData?.daily.map {
                let forecastType = self.forecastType(forecast: $0.weather.first?.main.uppercased() ?? "")
                let tempFormatted = self.formatTemperature(temp: $0.temp.day)
                
                return DailyTemp(dt: $0.dt, forecastType: forecastType, temp: $0.temp.day, tempFormatted: tempFormatted)
            } ?? []
        }
    
    func hasData() -> Bool {
        return dailyWeatherData != nil
    }
    

    var temp: Double {
        return dailyWeatherData?.current.temp ?? 0
    }
    
}


