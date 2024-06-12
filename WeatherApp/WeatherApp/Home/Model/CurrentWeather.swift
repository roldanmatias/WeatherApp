//
//  CurrentWeather.swift
//  WeatherApp
//
//  Created by Matias Roldan on 11/06/2024.
//

import Foundation

struct CurrentWeather: Codable, Equatable {
    static func == (lhs: CurrentWeather, rhs: CurrentWeather) -> Bool {
        lhs.id == rhs.id
    }
    
    let coord: Coord
    let weather: [Weather]
    let base: String
    let main: Main
    let visibility: Int
    let wind: Wind
    let clouds: Clouds
    let rain: Rain?
    let snow: Snow?
    let dt: Int
    let sys: Sys
    let timezone: Int 
    let id: Int
    let name: String
    let cod: Int
}
