//
//  ViewModelTests.swift
//  WeatherAppTests
//
//  Created by Matias Roldan on 11/06/2024.
//

import XCTest
import Combine
@testable import WeatherApp

final class ViewModelTests: XCTestCase {

    private var cancellables: [AnyCancellable] = []

    private var currentWeather: CurrentWeather {
        guard let pathString = Bundle(for: type(of: self)).path(forResource: "weather", ofType: "json") else {
            fatalError("weather.json not found")
        }

        let url = URL(fileURLWithPath: pathString)
        
        guard let jsonData = try? Data(contentsOf: url),
              let weather = try? JSONDecoder().decode(CurrentWeather.self, from: jsonData) else {
            fatalError("Unable to convert weather.json to JSON object")
        }
        
        return weather
    }
    
    override func setUpWithError() throws {
        
    }

    func test_requestDataSuccessfully() {
        // Given
        let expectation = self.expectation(description: "viewDidLoadExpectation")
        var loadingWasCalling = false
        var loadedWasCalling = false
        var errorWasCalling = false
        var weather: CurrentWeather?
        
        let tracking = TrackingMock()
        let getWeatherUseCase = GetWeatherUseCaseMock()
        getWeatherUseCase.currentWeather = currentWeather
        let viewModel = ViewModel(
            getWeatherUseCase: getWeatherUseCase,
            tracking: tracking
        )
        
        viewModel.$state.sink { state in            
            switch state {
            case .empty:
                break
            case .loading:
                loadingWasCalling = true
            case .loaded(let currentWeather):
                loadedWasCalling = true
                weather = currentWeather
                expectation.fulfill()
            case .error:
                errorWasCalling = true
            }
        }
        .store(in: &cancellables)
        
        // When
        viewModel.send(.viewDidLoad)
        
        // Then
        self.waitForExpectations(timeout: 3.0, handler: nil)
        
        XCTAssert(loadingWasCalling)
        XCTAssert(loadedWasCalling)
        XCTAssertFalse(errorWasCalling)
        XCTAssertEqual(weather, currentWeather)
        XCTAssertEqual(tracking.logEventWasCalled, 2)
    }

    func test_requestDataError() {
        // Given
        let expectation = self.expectation(description: "viewDidLoadExpectation")
        var loadingWasCalling = false
        var loadedWasCalling = false
        var errorWasCalling = false
        var weather: CurrentWeather?
        
        let tracking = TrackingMock()
        let getWeatherUseCase = GetWeatherUseCaseMock()
        let viewModel = ViewModel(
            getWeatherUseCase: getWeatherUseCase,
            tracking: tracking
        )
        
        viewModel.$state.sink { state in            
            switch state {
            case .empty:
                break
            case .loading:
                loadingWasCalling = true
            case .loaded(let currentWeather):
                loadedWasCalling = true
                weather = currentWeather
            case .error:
                errorWasCalling = true
                expectation.fulfill()
            }
        }
        .store(in: &cancellables)
        
        // When
        viewModel.send(.viewDidLoad)
        
        // Then
        self.waitForExpectations(timeout: 3.0, handler: nil)
        
        XCTAssert(loadingWasCalling)
        XCTAssertFalse(loadedWasCalling)
        XCTAssert(errorWasCalling)
        XCTAssertNotEqual(weather, currentWeather)
        XCTAssertEqual(tracking.logEventWasCalled, 1)
        XCTAssertEqual(tracking.logErrorWasCalled, 1)
    }
}
