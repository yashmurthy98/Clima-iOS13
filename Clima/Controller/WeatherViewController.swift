//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation
import SQLite

class WeatherViewController: UIViewController {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var cityList: UITableView!
    
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    

    var cities: [String] = Array()
    var originalCityList: [String] = Array()
    override func viewDidLoad() {
        super.viewDidLoad()
        cityList.isHidden = true
        cities.append("Indore")
        cities.append("Bhopal")
        cities.append("Bangalore")
        cities.append("Mangalore")
        cities.append("Delhi")
        cities.append("Noida")
        cities.append("Jaipur")
        cities.append("Pune")
        cities.append("Mysore")
        cities.append("Nagpur")
        cities.append("Chennai")
        cities.append("Kolkata")
        cities.append("Mumbai")
        
        
        
        for city in cities {
            originalCityList.append(city)
        }
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        weatherManager.delegate = self
        searchTextField.delegate = self
        cityList.delegate = self
        cityList.dataSource = self
        searchTextField.delegate = self

    }
        
}

//MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)

    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true) //dismisses keyboard
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            cityList.isHidden = true
            return true
        }
        else{
            textField.placeholder = "Type something"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //Use searchTextField.text to get weather for that city
        if let city = searchTextField.text {
            weatherManager.fetchWeather(city)
        }
        
        searchTextField.text = ""
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        cityList.isHidden = false
        searchTextField.addTarget(self, action: #selector(searchRecords(_ :)), for: .editingChanged)
    }
}

//MARK: - WeatherMangerDelegate

extension WeatherViewController: WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {

        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName

        }
    }
    
    func didFailWithError(error: Error) {
        DispatchQueue.main.async {
            self.cityLabel.text = "Are you from another planet?"
        }
    }
    func didNotFindCityName(_ errorCode: String) {
        DispatchQueue.main.async {
            self.cityLabel.text = errorCode
            self.temperatureLabel.text = "?!"
        }
    }
}

//MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Got location")
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            print(lat)
            print(lon)
           
            weatherManager.fetchWeatherByCoordinates(lat, lon)
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error")
    }
    
    @IBAction func currentLocationWeatherPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
}


//MARK: - AutoComplete UITableView

extension WeatherViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "city")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "city")
            
        }
        cell?.textLabel?.text = cities[indexPath.row]
        return cell!
    }
    
    
    
    @objc func searchRecords(_ textField: UITextField){
        self.cities.removeAll()
        if textField.text?.count != 0 {
            
            for city in originalCityList {
                
                if let countryToSearch = textField.text {
                    let range = city.lowercased().range(of: countryToSearch, options: .caseInsensitive, range: nil, locale: nil)
                    
                    if range != nil {
                        self.cities.append(city)
                    }
                }
            }
        }
        else {
            for city in originalCityList {
                cities.append(city)
            }

        }
        cityList.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        let detVC = self.storyboard?.instantiateViewController(withIdentifier: "Result_VC")as! ResultViewController
//        detVC.cityName = cities[indexPath.row]
//        self.navigationController?.pushViewController(detVC, animated: true)
        searchTextField.text = cities[indexPath.row]
        cityList.isHidden = true
    }

    

}
