//
//  GetLocationUseCase.swift
//  WeatherApp
//
//  Created by Matias Roldan on 11/06/2024.
//

import Foundation
import Combine
import CoreLocation

protocol GetLocationUseCaseProtocol {
    func requestLocation()
}

class GetLocationUseCase: GetLocationUseCaseProtocol, CLLocationManagerDelegate {
    
    
}
