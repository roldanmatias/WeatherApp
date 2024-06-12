//
//  Tracking.swift
//  WeatherApp
//
//  Created by Matias Roldan on 10/06/2024.
//

import Foundation

final class Tracking: TrackingProtocol {
    func logEvent(_ name: String) {
        logEvent(name, parameters: [:])
    }
    
    func logEvent(_ name: String, parameters: [String: AnyObject]) {
        print("logEvent: \(name) parameters: \(parameters.debugDescription)")
    }
    
    func logError(_ error: Error) {
        print("logError: \(error.localizedDescription)")
    }
}
