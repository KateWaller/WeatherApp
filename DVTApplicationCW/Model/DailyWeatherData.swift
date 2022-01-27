//
//  DailyWeatherData.swift
//  DVTApplicationCW
//
//  Created by Kate Waller on 2022/01/18.
//

//Reading Daily data from OpenWeatherMap to get forecast for next few days

import Foundation

struct DailyWeatherData: Codable {
    let lat: Double
    let lon: Double
    let timezone: String
    let current: Current
    let daily: [Daily]
}

struct Current: Codable {
    let dt: Int64
    let temp: Double
    let weather: [Weather]
}

struct Daily: Codable {
    let dt: Int64
    let temp: Temp
    let weather: [Weather]
}

struct Temp: Codable {
    let day: Double
    let min: Double
    let max: Double
}

struct DailyTemp {
    let dt: Int64
    let forecastType: WeatherDetailsViewModel.IconType
    let temp: Double
    let tempFormatted: String
}

