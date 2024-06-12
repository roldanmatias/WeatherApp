//
//  Resource.swift
//  WeatherApp
//
//  Created by Matias Roldan on 10/06/2024.
//

import Foundation

struct Resource<T: Decodable> {
    let path: ResourcePath
    let parameters: [String: CustomStringConvertible]
    
    var request: URLRequest? {
        guard let apiUrl = Bundle.main.object(forInfoDictionaryKey: "apiUrl") as? String
        else { 
            fatalError("Failed to load apiUrl from Info.plist")
        }
        
        guard let url = URL(string: "\(apiUrl)\(path.rawValue)"), 
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return nil
        }
        components.queryItems = parameters.keys.map { key in
            URLQueryItem(name: key, value: parameters[key]?.description)
        }
        guard let url = components.url else {
            return nil
        }
        return URLRequest(url: url)
    }

    init(path: ResourcePath, parameters: [String: CustomStringConvertible] = [:]) {
        self.path = path
        self.parameters = parameters
    }
}
