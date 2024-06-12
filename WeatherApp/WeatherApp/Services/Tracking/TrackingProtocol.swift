//
//  TrackingProtocol.swift
//  WeatherApp
//
//  Created by Matias Roldan on 10/06/2024.
//

import Foundation

protocol TrackingProtocol {
    func logEvent(_ name: String)
    func logEvent(_ name: String, parameters: [String: AnyObject])
    func logError(_ error: Error)
}
