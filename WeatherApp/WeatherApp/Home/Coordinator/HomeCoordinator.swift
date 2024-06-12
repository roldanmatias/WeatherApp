//
//  HomeCoordinator.swift
//  WeatherApp
//
//  Created by Matias Roldan on 10/06/2024.
//

import Foundation
import UIKit

class HomeCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    
    private let storyboard = UIStoryboard.init(name: "Main", bundle: .main)
    
    init(navigationController : UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        guard let viewController = storyboard.instantiateViewController(
            withIdentifier: "ViewController"
        ) as? ViewController,
              let appId = Bundle.main.object(forInfoDictionaryKey: "appid") as? String
        else { 
            fatalError("Failed to initialize ViewController.")
        }
        
        let tracking = Tracking()
        let networkService = ServicesProvider.defaultProvider().network
        let getWeatherUseCase = GetWeatherUseCase(
            appId: appId, 
            networkService: networkService
        )
        let viewModel = ViewModel(
            getWeatherUseCase: getWeatherUseCase,
            tracking: tracking
        )
        viewModel.coordinator = self    
        viewController.viewModel = viewModel

        navigationController.pushViewController(viewController, animated: true)
    }
}
