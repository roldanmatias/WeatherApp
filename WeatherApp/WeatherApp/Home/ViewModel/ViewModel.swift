//
//  ViewModel.swift
//  WeatherApp
//
//  Created by Matias Roldan on 10/06/2024.
//

import Foundation
import Combine
import CoreLocation

final class ViewModel: NSObject, ViewModelProtocol {
    
    @Published var state: State
    
    weak var coordinator: HomeCoordinator?
    
    private var getWeatherUseCase: GetWeatherUseCaseProtocol
    private var tracking: TrackingProtocol
    private var cancellables: [AnyCancellable] = []
    private var locationManager = CLLocationManager()
    private let defaultLocation = Coord(lon: -118.4912273, lat: 34.0194704)
    
    init(
        state: State = .empty, 
        getWeatherUseCase: GetWeatherUseCaseProtocol,
        tracking: TrackingProtocol
    ) {
        self.state = state
        self.getWeatherUseCase = getWeatherUseCase
        self.tracking = tracking
    }

    public func send(_ event: Event) {
        state = .loading
        
        switch event {
        case .requestData(let coord):
            load(coord)
        case .viewDidLoad:
            locationManager.delegate = self
            locationManager.requestLocation()
        }
    }
}

private extension ViewModel  {
    func load(_ coord: Coord) {
        tracking.logEvent("ViewModel load")
        state = .loading
        getWeather(coord)
    }
    
    func getWeather(_ coord: Coord) {
        getWeatherUseCase.getWeather(coord: coord)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.tracking.logError(error)
                    self?.state = .error
                default:
                    break
                }
            }, receiveValue: { [weak self] result in
                do {
                    let weather = try result.get()
                    self?.state = .loaded(weather)
                    self?.tracking.logEvent("getWeather completed")
                } catch {
                    self?.tracking.logError(error)
                    self?.state = .error
                }
            })
            .store(in: &cancellables)
    }
}

extension ViewModel: CLLocationManagerDelegate {
    @objc func locationManager(
        _ manager: CLLocationManager, 
        didUpdateLocations locations: [CLLocation]
    ) {
        if let location = locations.first {
            load(Coord(lon: location.coordinate.longitude, lat: location.coordinate.latitude))
        } else {
            load(defaultLocation)
        }
    }

    @objc func locationManager(
        _ manager: CLLocationManager, 
        didFailWithError error: Error
    ) {
        print(error.localizedDescription)
        load(defaultLocation)
    }
}
