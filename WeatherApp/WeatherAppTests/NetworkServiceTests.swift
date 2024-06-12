//
//  NetworkServiceTests.swift
//  WeatherAppTests
//
//  Created by Matias Roldan on 11/06/2024.
//

import XCTest
import Combine
@testable import WeatherApp

final class NetworkServiceTests: XCTestCase {

    private lazy var session: URLSession = {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolMock.self]
        return URLSession(configuration: config)
    }()
    private lazy var networkService = NetworkService(
        session: session
    )
    private var cancellables: [AnyCancellable] = []
    private var result: Result<CurrentWeather, Error>?
    private var resource = Resource<CurrentWeather>(
        path: ResourcePath.weather, 
        parameters: [
            "lat" : 34.0194704, 
            "lon": -118.4912273, 
            "appid": "d4277b87ee5c71a468ec0c3dc311a724"
        ]
    )
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
        URLProtocol.registerClass(URLProtocolMock.self)
        result = nil
    }

    func test_loadFinishedSuccessfully() {
        // Given
        let expectation = self.expectation(description: "networkServiceExpectation")
        setRequestHandler()

        // When
        networkServiceLoad(expectation)

        // Then
        self.waitForExpectations(timeout: 1.0, handler: nil)
        guard case .success(let content) = result else {
            XCTFail()
            return
        }
        XCTAssertEqual(content, currentWeather)
    }
    
    func test_loadFinishedWithError() {
        // Given
        let expectation = self.expectation(description: "networkServiceExpectation")
        setRequestHandlerError()

        // When
        networkServiceLoad(expectation)

        // Then
        self.waitForExpectations(timeout: 1.0, handler: nil)
        
        guard case .failure(let error) = result,
            let networkError = error as? NetworkError,
            case NetworkError.dataLoadingError(500, _) = networkError else {
            XCTFail()
            return
        }
    }
    
    private func setRequestHandler() {
        URLProtocolMock.requestHandler = { [weak self] request in
            guard let self = self else {
                return (HTTPURLResponse(), Data())    
            }
            
            let response = HTTPURLResponse(
                url: self.resource.request!.url!, 
                statusCode: 200,
                httpVersion: nil, 
                headerFields: nil
            )!
            let data = try! JSONEncoder().encode(self.currentWeather)
            return (response, data)
        }
    }
    
    private func setRequestHandlerError() {
        URLProtocolMock.requestHandler = { [weak self] request in
            guard let self = self else {
                return (HTTPURLResponse(), Data())    
            }
            
            let response = HTTPURLResponse(
                url: self.resource.request!.url!, 
                statusCode: 500,
                httpVersion: nil, 
                headerFields: nil
            )!
            return (response, Data())
        }
    }
    
    private func networkServiceLoad(_ expectation: XCTestExpectation) {
        networkService
            .load(resource)
            .map { data in
                return .success(data) 
            }
            .catch { 
                error -> AnyPublisher<Result<CurrentWeather, Error>, Never> in 
                    .just(.failure(error))
            }
            .sink(receiveValue: { [weak self] value in
                self?.result = value
                expectation.fulfill()
            })
            .store(in: &cancellables)
    }
}
