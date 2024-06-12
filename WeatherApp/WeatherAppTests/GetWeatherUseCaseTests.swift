//
//  GetWeatherUseCase.swift
//  WeatherAppTests
//
//  Created by Matias Roldan on 11/06/2024.
//

import XCTest
import Combine
@testable import WeatherApp

final class GetWeatherUseCaseTests: XCTestCase {

    private let networkService = NetworkServiceMock()
    private var cancellables: [AnyCancellable] = []
    private var error: NetworkError?
    
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
        networkService.reset()
        error = nil
    }
    
    func test_getWeatherSuccessfully() {
        // Given
        let expectation = self.expectation(description: "GetWeatherUseCaseExpectation")
        let getWeatherUseCase = GetWeatherUseCase(appId: "", networkService: networkService)
        var response: CurrentWeather?
        networkService.response = currentWeather as AnyObject

        // When
        getWeatherUseCase
            .getWeather(coord: Coord(lon: -118.4912273, lat: 34.0194704))
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(_):
                    XCTFail()
                default:
                    break
                }
            }, receiveValue: { result in
                do {
                    response = try result.get()
                    expectation.fulfill()
                } catch {
                    XCTFail()
                }
            })
            .store(in: &cancellables)

        // Then
        self.waitForExpectations(timeout: 1.0, handler: nil)
        
        guard let response = response else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(response, currentWeather)
    }
    
    func test_getWeatherError() {
        // Given
        var result: Result<CurrentWeather, Error>?
        let expectation = self.expectation(description: "GetWeatherUseCaseExpectation")
        let getWeatherUseCase = GetWeatherUseCase(appId: "", networkService: networkService)
        networkService.error = NetworkError.invalidResponse

        // When
        getWeatherUseCase
            .getWeather(coord: Coord(lon: -118.4912273, lat: 34.0194704))
            .sink { value in
                result = value
                expectation.fulfill()
            }
            .store(in: &cancellables)

        // Then
        self.waitForExpectations(timeout: 1.0, handler: nil)
        
        guard case .failure = result! else {
            XCTFail()
            return
        }
    }
}
