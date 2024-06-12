//
//  ViewModelProtocol.swift
//  WeatherApp
//
//  Created by Matias Roldan on 10/06/2024.
//

import Foundation

protocol ViewModelProtocol {
    var state: State { get }
    func send(_ event: Event)
}
