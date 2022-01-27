//
//  ViewController.swift
//  DVTApplicationCW
//
//  Created by Kate Waller on 2022/01/18.

//Application that uses CoreLocation to get user's current location and updates weather accordingly

import UIKit
import CoreLocation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    //Connect all IBOutlets
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
    
    var coordinates: CLLocation?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.weatherTable.delegate = self
        self.weatherTable.dataSource = self
        
        
        view.accessibilityIdentifier = "mainView"
        
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        self.clearWeatherLabels()
        
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.getWeather()
    }
    
    //MARK: Setting up the tableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.weeklyForecast.count - 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: WeatherTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! WeatherTableViewCell
        
        let index = indexPath.row + 1
        let forecast = self.weeklyForecast[index]
        
        let df = DateFormatter()
        df.dateFormat = "EEEE"
        
        cell.backgroundColor = self.weatherTable.backgroundColor
        
        //Set day of the week label
        cell.dayofWeek.text = df.string(from: Date(timeIntervalSince1970: Double(forecast.dt)))
        
        print("executed setting day of week")
        
        
        //Set temperature label
        cell.tempLabel.text = forecast.tempFormatted
        
        
        //Set conditions label
        let image = self.dailyWeatherDataViewModel.forecastImage[forecast.forecastType]
        cell.iconImage.image = image != nil ? UIImage(named: image!) : nil
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
        
    }
    
    //Create a function to get the weather using CLLocation
    func getWeather() {
        
        self.clearWeatherLabels()
        
        //Before setting user's location, need to trigger a persmission requesy
        locationManager.requestWhenInUseAuthorization()
        
        
        if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
           CLLocationManager.authorizationStatus() == .authorizedAlways) {
            
            var currentCoords: CLLocation!
            currentCoords = locationManager.location
            
            if currentCoords != nil {
                let lat = currentCoords.coordinate.latitude
                let lon = currentCoords.coordinate.longitude
                
                print("Latitude = \(lat) | Longitude = \(lon)")
                
                weatherDataViewModel.setLocation(lat: lat, lon: lon)
                weatherDataViewModel.getWeatherData() {
                    success in
                    DispatchQueue.main.async {
                        
                        if (success) {
                            self.setWeatherLabels()
                            
                        } else {
                            self.cityLable.text = "Unknown"
                            
                        }
                        
                    }
                }
                
                dailyWeatherDataViewModel.setLocation(lat: lat, lon: lon)
                
                dailyWeatherDataViewModel.getDailyWeatherData() {
                    success in DispatchQueue.main.async {
                        if (success) {
                            self.animateTable(tableView: self.weatherTable)
                        } else {
                            self.cityLable.text = "Failed"
                        }
                    }
                }
                
            } else {
                print("Unable to find location")
                self.cityLable.text = "Unkown"
            }
        } else {
            print("Unable to find location")
            self.cityLable.text = "Unknown"
        }
    }
    
    
    //Function that clears all weather labels
    func clearWeatherLabels() {
        
        cityLable.text = ""
        templabel.text = ""
        descriptionLabel.text = ""
        
        minTempLabel.text = ""
        currentTempLabel.text = ""
        maxTempLabel.text = ""
        
    }
    
    //Setting all the lables, colours and images. Additionally call the function that animates the labels and table.
    
    func setWeatherLabels() {
        self.backgroundImage.image = UIImage(named: self.weatherDataViewModel.backgroundImageName)
        
        self.templabel.text = self.weatherDataViewModel.tempLabelText
        self.cityLable.text = self.weatherDataViewModel.locationName
        self.descriptionLabel.text = self.weatherDataViewModel.forecastDescription
        
        self.minCurrentMaxBar.backgroundColor = UIColor.init(hex: self.weatherDataViewModel.backgroundHexColor)
        self.weatherTable.backgroundColor = self.minCurrentMaxBar.backgroundColor
        
        self.minTempLabel.text = self.weatherDataViewModel.tempMinLabelText
        self.currentTempLabel.text = self.weatherDataViewModel.tempLabelText
        self.maxTempLabel.text = self.weatherDataViewModel.tempMaxLabelText
        
        self.animateLabels()
        
    }
    
    
    //Function that stops updating the location when coordinates retrieved, the calls getWeather() function
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty, coordinates == nil {
            coordinates = locations.first
            locationManager.stopUpdatingLocation()
            getWeather()
            
        }
    }
    
    
    //MARK: Function that animates the labels
    
    private func animateLabels() {
        //Location name
        let offset = CGPoint(x: -self.view.frame.maxX, y: 0)
        let x: CGFloat = 0, y: CGFloat = 0
        self.cityLable.transform = CGAffineTransform(translationX: offset.x + x, y: offset.y + y)
        self.cityLable.isHidden = false
        
        UIView.animate(
            withDuration: 1, delay: 1, usingSpringWithDamping: 0.47, initialSpringVelocity: 3,
            options: .curveEaseOut, animations: {
                self.cityLable.transform = .identity
                self.cityLable.alpha = 1
            })
        
        self.templabel.alpha = 0
        self.templabel.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        
        UIView.animate(
            withDuration: 0.5, delay: 1, usingSpringWithDamping: 0.55, initialSpringVelocity: 3,
            options: .curveEaseOut, animations: {
                self.templabel.transform = .identity
                self.templabel.alpha = 1
            }, completion: nil)
        
        
        self.descriptionLabel.alpha = 0.0
        
        UIView.animate(withDuration: 0.5, delay: 1.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.descriptionLabel.alpha = 1
        }, completion: nil)
    }
    
    
    //MARK: Function to animate the tableView
    
    private func animateTable(tableView: UITableView) {
        
        tableView.reloadData()
        
        let cells = tableView.visibleCells
        let tableHeight: CGFloat = tableView.bounds.size.height
        
        for i in cells {
            let cell: UITableViewCell = i as UITableViewCell
            cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
        }
        
        var index = 0
        
        for a in cells {
            let cell: UITableViewCell = a as UITableViewCell
            UIView.animate(withDuration: 1.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0);
            }, completion: nil)
            
            index += 1
        }
    }
    
    
    //Need to add catch block function
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    
}

