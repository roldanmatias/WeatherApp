//
//  Wind.swift
//  WeatherApp
//
//  Created by Matias Roldan on 11/06/2024.
//

import Foundation

struct Wind: Codable {
    let speed: Double
    let deg: Int
    let gust: Double?
}
