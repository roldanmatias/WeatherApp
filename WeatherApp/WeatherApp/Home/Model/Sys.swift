//
//  Sys.swift
//  WeatherApp
//
//  Created by Matias Roldan on 11/06/2024.
//

import Foundation

struct Sys: Codable {
    let type, id: Int
    let country: String
    let sunrise, sunset: Int
}
