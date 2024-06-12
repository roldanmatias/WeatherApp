//
//  NetworkError.swift
//  WeatherApp
//
//  Created by Matias Roldan on 11/06/2024.
//

import Foundation

enum NetworkError: Error {
    case invalidRequest
    case invalidResponse
    case dataLoadingError(statusCode: Int, data: Data)
    case jsonDecodingError(error: Error)
}
