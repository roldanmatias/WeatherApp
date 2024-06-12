//
//  GetWeatherUseCaseMock.swift
//  WeatherAppTests
//
//  Created by Matias Roldan on 11/06/2024.
//

import Foundation
import Combine
@testable import WeatherApp

class GetWeatherUseCaseMock: GetWeatherUseCaseProtocol {
    var currentWeather: CurrentWeather?
    
    func getWeather(coord: WeatherApp.Coord) -> AnyPublisher<Result<WeatherApp.CurrentWeather, Error>, Never> {
        guard let currentWeather = currentWeather else {
            return .just(.failure(NetworkError.invalidResponse))
        }
        
        return .just(.success(currentWeather))
    }
}
