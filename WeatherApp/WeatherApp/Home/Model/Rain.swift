//
//  Rain.swift
//  WeatherApp
//
//  Created by Matias Roldan on 11/06/2024.
//

import Foundation

struct Rain: Codable {
    let the1H: Double?
    let the3H: Double?

    enum CodingKeys: String, CodingKey {
        case the1H = "1h"
        case the3H = "3h"
    }
}
