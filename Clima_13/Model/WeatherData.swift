//
//  WeatherData.swift
//  Clima_13
//
//  Created by Лариса Терегулова on 28.04.2023.
//

import Foundation

struct WeatherData: Decodable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Decodable {
    let temp: Double
}

struct Weather: Decodable {
    let description: String
    let id: Int
}
