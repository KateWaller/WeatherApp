//
//  APIKey.swift
//  DVTApplicationCW
//
//  Created by Kate Waller on 2022/01/18.
//

//File that stores API key. When running this on another device, a personal apikey will need to be created for OpenWeatherMapAPI

import Foundation

public class APIKey {
    
    //When running on own device - add your own API Key
    let OpenWeatherMapAPI = "INSERT YOUR OWN API KEY HERE"
    
    let OpenWeatherMapURL = "https://api.openweathermap.org/data/2.5/"
    

    //Get user's location based on latittude and longitude
    func getWeatherDataLatLon(lat: Double, lon: Double, completion: @escaping (WeatherData?) -> Void = { weatherData in }) {
        
        let apiCall = "weather?lat=\(lat)&lon=\(lon)&units=metric&appid=\(self.OpenWeatherMapAPI)&lang=en"
        
        let apiURL = URL(string: OpenWeatherMapURL + apiCall)!
        let request = URLRequest(url: apiURL)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
           
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
