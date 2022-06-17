//
//  WeatherData.swift
//  Clima
//
//  Created by Yash Murthy on 09/04/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData: Decodable {
    let main: Main
    let weather: [Weather]
    let name: String
}

struct CoordinateData: Decodable {
    let lat: Double
    let lon: Double
}


struct Main: Decodable {
    let temp: Double
}


struct Weather: Decodable {
    let id: Int
}
