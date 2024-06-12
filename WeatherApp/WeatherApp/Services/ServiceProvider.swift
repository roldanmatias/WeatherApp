//
//  ServiceProvider.swift
//  WeatherApp
//
//  Created by Matias Roldan on 10/06/2024.
//

import Foundation

class ServicesProvider {
    let network: NetworkServiceProtocol

    static func defaultProvider() -> ServicesProvider {
        let session = URLSession(configuration: URLSessionConfiguration.ephemeral)
        let tracking = Tracking()
        let network = NetworkService(session: session)
        return ServicesProvider(network: network)
    }

    init(network: NetworkServiceProtocol) {
        self.network = network
    }
}
