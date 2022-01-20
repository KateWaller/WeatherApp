//
//  ViewController.swift
//  DVTApplicationCW
//
//  Created by Kate Waller on 2022/01/18.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController{
    
    @IBOutlet weak var backgroundImage: UIImageView!
    
    @IBOutlet weak var cityLable: UILabel!
    @IBOutlet weak var templabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var minCurrentMaxBar: UIView!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var weatherTable: UITableView!
    
    var locationManager = CLLocationManager()
    let weatherDataViewModel = WeatherDataViewModel()
    let dailyWeatherDataViewModel = DailyWeatherDataViewModel()
    
    var weeklyForecast: [DailyTemp] {
        return self.dailyWeatherDataViewModel.weeklyForecast
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherTable.delegate = self
        weatherTable.dataSource = self
    }

}


extension WeatherViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.weeklyForecast.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MinCurrentMaxViewCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! MinCurrentMaxViewCell
        
        let index = indexPath.row
        let forecast = self.weeklyForecast[index]
        
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "EEEE"
        cell.dayofWeek.text = dateFormat.string(from: Date(timeIntervalSince1970: Double(forecast.dt)))
        
        let image = self.dailyWeatherDataViewModel.forecastImage[forecast.forecastType]
        cell.WeatherIcon.image = image != nil ? UIImage(named: image!) : nil
        return cell
    }
    
}

