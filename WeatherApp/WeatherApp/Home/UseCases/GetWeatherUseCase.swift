//
//  GetWeatherUseCase.swift
//  WeatherApp
//
//  Created by Matias Roldan on 10/06/2024.
//

import Foundation
import Combine

protocol GetWeatherUseCaseProtocol {
    func getWeather(coord: Coord) -> AnyPublisher<Result<CurrentWeather, Error>, Never>
}

class GetWeatherUseCase: GetWeatherUseCaseProtocol {
    private let appId: String
    private let networkService: NetworkServiceProtocol
    
    init(appId: String, networkService: NetworkServiceProtocol) {
        self.appId = appId
        self.networkService = networkService
    }
    
    func getWeather(coord: Coord) -> AnyPublisher<Result<CurrentWeather, Error>, Never> {
        let parameters = [
            "lat" : coord.lat, 
            "lon": coord.lon, 
            "appid": appId
        ] as [String : any CustomStringConvertible]
        let resource = Resource<CurrentWeather>(
            path: .weather, 
            parameters: parameters
        )
        return networkService
            .load(resource)
            .map { data in
                return .success(data)
            }
            .catch { error -> AnyPublisher<Result<CurrentWeather, Error>, Never> in .just(.failure(error))
            }
            .subscribe(on: Scheduler.backgroundWorkScheduler)
            .receive(on: Scheduler.mainScheduler)
            .eraseToAnyPublisher()
    }
}
