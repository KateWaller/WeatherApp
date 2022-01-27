//
//  WeatherData.swift
//  DVTApplicationCW
//
//  Created by Kate Waller on 2022/01/18.
//

//This files reads the data from OpenWeatherMap from help of Codable 

import Foundation

//Create structs for weather data
struct WeatherData: Codable {
    let coord: CoOrd
    let name: String
    let weather: [Weather]
    let main: MainWeather
}

struct MainWeather: Codable {
    let temp: Double
    let temp_max: Double
    let temp_min: Double
}

struct CoOrd: Codable {
    let lat: Double
    let lon: Double
}

struct Weather: Codable {
    let description: String
    let icon: String
    let id: Int
    let main: String
}

