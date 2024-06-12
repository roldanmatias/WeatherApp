//
//  NetworkServiceProtocol.swift
//  WeatherApp
//
//  Created by Matias Roldan on 10/06/2024.
//

import Foundation
import Combine

protocol NetworkServiceProtocol: AnyObject {

    @discardableResult
    func load<T>(_ resource: Resource<T>) -> AnyPublisher<T, Error>
}
