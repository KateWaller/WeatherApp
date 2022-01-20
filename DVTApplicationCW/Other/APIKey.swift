//
//  APIKey.swift
//  DVTApplicationCW
//
//  Created by Kate Waller on 2022/01/18.
//

import Foundation

public class APIKey {
    
    let OpenWeatherMapAPI = "ea9065f6bc341a618870b57a7191a285"
    
    let OpenWeatherMapURL = "https://api.openweathermap.org/data/2.5/"
    

    func getWeatherDataLatLon(lat: Double, lon: Double, completion: @escaping (WeatherData?) -> Void = { weatherData in }) {
        
        let apiCall = "weather?lat=\(lat)&lon=\(lon)&units=metric&appid=\(self.OpenWeatherMapAPI)&lang=en"
        
        let apiURL = URL(string: OpenWeatherMapURL + apiCall)!
        
        let request = URLRequest(url: apiURL)
        //request.httpMethod = "GET"
        //request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        print(apiURL.absoluteString)
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            //assume an error if data == nil
            guard data != nil else {
                completion(nil)
                return
            }
            
            do {
                let weatherData = try JSONDecoder().decode(WeatherData.self, from: data!)
                
                completion(weatherData)
                
            } catch {
                print("error")
                completion(nil)
            }
        })
        
        task.resume()
    }
    
    func forecastDataLatLon(lat: Double, lon: Double, completion: @escaping(DailyWeatherData?) -> Void = {dailyWeatherData in}) {
        let apiCall = "onecall?lat=\(lat)&lon=\(lon)&units=metric&exclude=minutely,hourly&appid=\(self.OpenWeatherMapAPI)&lang=en"
        let apiURL = URL(string: OpenWeatherMapURL + apiCall)!
        
        var request = URLRequest(url: apiURL)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        print(apiURL.absoluteString)
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            //assume an error if data == nil
            guard data != nil else {
                completion(nil)
                return
            }
            
            do {
                let dailyWeatherData = try JSONDecoder().decode(DailyWeatherData.self, from: data!)
                
                completion(dailyWeatherData)
                
            } catch {
                print("error")
                completion(nil)
            }
        })
        
        task.resume()
    }
    
}

let apiKey = APIKey()
