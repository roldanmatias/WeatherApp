//
//  State.swift
//  WeatherApp
//
//  Created by Matias Roldan on 11/06/2024.
//

import Foundation

enum State {
    case empty
    case error
    case loaded(CurrentWeather)
    case loading
}
