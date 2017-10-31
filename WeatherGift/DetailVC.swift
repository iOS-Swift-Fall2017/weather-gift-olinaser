//
//  DetailVC.swift
//  WeatherGift
//
//  Created by oliver naser on 10/16/17.
//  Copyright © 2017 oliver naser. All rights reserved.
//

import UIKit
import CoreLocation

class DetailVC: UIViewController {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var currentImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var currentPage = 0
    var locationsArray = [WeatherLocation]()
    var locationsManager: CLLocationManager!
    var currentLocation: CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        if currentPage != 0 {
            self.locationsArray[currentPage].getWeather {
                self.updateUserInterface()
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if currentPage == 0 {
            getLocation()
        }
    }
    
    func updateUserInterface() {
        let location = locationsArray[currentPage]
        locationLabel.text = location.name
        let dateString = formatTimeForTimeZone(unixDate: location.currentTime, timeZone: location.timeZone)
        dateLabel.text = dateString
        temperatureLabel.text = location.currentTemp
        summaryLabel.text = location.currentSummary
        currentImage.image = UIImage(named:location.currentIcon)
        tableView.reloadData()
    }
    
    func formatTimeForTimeZone(unixDate: TimeInterval, timeZone: String) -> String {
        let usableDate = Date(timeIntervalSince1970: unixDate)
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MM dd, y"
        dateFormatter.timeZone = TimeZone(identifier: timeZone)
        let dateString = dateFormatter.string(from: usableDate)
        return dateString
    }
    
}

extension DetailVC: CLLocationManagerDelegate {
    
    func getLocation() {
        locationsManager = CLLocationManager()
        locationsManager.delegate = self
        let status = CLLocationManager.authorizationStatus()
        handleLocationAuthorization(status: status)
    }
    
    func handleLocationAuthorization(status:CLAuthorizationStatus) {
        switch status {
        case .notDetermined :
            locationsManager.requestWhenInUseAuthorization()
        case .authorizedAlways,.authorizedWhenInUse:
            locationsManager.requestLocation()
        case .denied :
            print("im sorry cant show locaiton user has not authorized")
        case .restricted :
            print("access denied")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        handleLocationAuthorization(status: status)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let geoCoder = CLGeocoder()
        var place = ""
        currentLocation = locations.last
        let currentLatitude = currentLocation.coordinate.latitude
        let currentLongitde = currentLocation.coordinate.longitude
        let currentCoordinates = "\(currentLatitude),\(currentLongitde)"
        print(currentCoordinates)
        geoCoder.reverseGeocodeLocation(currentLocation, completionHandler: {placemarks,error in
            if placemarks != nil {
                let placemark = placemarks?.last
                place = (placemark?.name)!
            } else {
                print("error")
                place = "unknown weather location"
            }
            self.locationsArray[0].name = place
            self.locationsArray[0].coordinates = currentCoordinates
            self.locationsArray[0].getWeather {
                self.updateUserInterface()
            }
            
        })
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("failed to get user location")
    }
    
}

extension DetailVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationsArray[currentPage].dailyForecastArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DayWeatherCell", for: indexPath) as! DayWeatherCell
        let dailyForecast = locationsArray[currentPage].dailyForecastArray[indexPath.row]
        let timeZone = locationsArray[currentPage].timeZone
        cell.update(with: dailyForecast, timeZone: timeZone)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}






