//
//  NetworkServiceMock.swift
//  WeatherAppTests
//
//  Created by Matias Roldan on 11/06/2024.
//

import Foundation
import Combine
@testable import WeatherApp

final class NetworkServiceMock: NetworkServiceProtocol {
    var error: NetworkError?
    var response: AnyObject?
    
    func load<T>(_ resource: Resource<T>) -> AnyPublisher<T, Error> {
        if let response = response as? T {
            return .just(response)
        } else if let error = error {
            return .fail(error)
        } else {
            return .fail(NetworkError.invalidRequest)
        }
    }
    
    func reset() {
        error = nil
        response = nil
    }
}
