//
//  WeatherManager.swift
//  Clima
//
//  Created by Yash Murthy on 07/04/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
    func didNotFindCityName(_ errorCode: String)
}

class WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=b259adedf2c3dcdffcf52fc94196c45c&units=metric"
    let coordinateURL = "https://api.openweathermap.org/geo/1.0/direct?limit=1&appid=b259adedf2c3dcdffcf52fc94196c45c"
    
    var delegate: WeatherManagerDelegate?
    
    
    func fetchWeather(_ cityName: String){
        let coorString = "\(coordinateURL)&q=\(cityName)"
        performRequest(coorString)
//        let urlString = "\(weatherURL)&lat=\(coor[0])&lon=\(coor[1])"
//        performRequest(urlString)
        
    }
    
    func fetchWeatherByCoordinates(_ lat: CLLocationDegrees, _ lon: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(lat)&lon=\(lon)"
        performRequests(urlString)
    }
    
    
    func performRequest(_ urlString: String) {
        
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                else
                if String(data: data!, encoding: .utf8) == "[]" {
                    self.delegate?.didNotFindCityName("Are you from another planet?")
                    return
                }
                else
                if let safeData = data {
                    let dataString = String(data: safeData, encoding: .utf8)
                    print(dataString!)
                    self.parseJSON(weatherData: safeData)
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(weatherData: Data){
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode([CoordinateData].self, from: weatherData)
//            print(decodedData[0].lat)
//            print(decodedData[0].lon)
            let urlString = "\(weatherURL)&lat=\(decodedData[0].lat)&lon=\(decodedData[0].lon)"
            performRequests(urlString)

        } catch {
            self.delegate?.didFailWithError(error: error)
        }
    }
    
    func performRequests(_ urlString: String) {
        
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                else
                if let safeData = data {
                    let dataString = String(data: safeData, encoding: .utf8)
                    print(dataString!)
                    if let weather = self.parseJSONs(weatherData: safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSONs(weatherData: Data)-> WeatherModel? {
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            
            let temp = decodedData.main.temp
            let name = decodedData.name
            let id = decodedData.weather[0].id
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            return weather
        } catch {
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    
    
}
