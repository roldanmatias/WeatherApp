//
//  Weather.swift
//  WeatherApp
//
//  Created by Matias Roldan on 11/06/2024.
//

import Foundation

struct Weather: Codable {
    let id: Int
    let main, description, icon: String
}
