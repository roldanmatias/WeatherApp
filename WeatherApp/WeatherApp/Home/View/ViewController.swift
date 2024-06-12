//
//  ViewController.swift
//  WeatherApp
//
//  Created by Matias Roldan on 10/06/2024.
//

import UIKit
import Combine

class ViewController: UIViewController {

    var viewModel: ViewModel?
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var lowHighLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    
    private var cancellables: Set<AnyCancellable> = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subscribeToViewModel()
        viewModel?.send(.viewDidLoad)
    }
}

private extension ViewController {
    func subscribeToViewModel() {
        viewModel?.$state.sink { [weak self] state in
            guard let self = self else { return }
            
            switch state {
            case .empty:
                break
            case .loading:
                self.showLoadingStates()
            case .loaded(let currentWeather):
                self.load(currentWeather)
            case .error:
                self.showErrorMessage()
            }
        }
        .store(in: &cancellables)
    }
    
    func showLoadingStates() {
        activityIndicator.startAnimating()
    }
    
    func load(_ currentWeather: CurrentWeather) {
        activityIndicator.stopAnimating()
        
        cityLabel.text = currentWeather.name
        temperatureLabel.text = "\(currentWeather.main.temp)º"
        descriptionLabel.text = "\(currentWeather.weather.first?.description ?? "")"
        lowHighLabel.text = "\(String(localized: "low")): \(currentWeather.main.tempMin)º \(String(localized: "high")): \(currentWeather.main.tempMax)º" 
        windLabel.text = "\(String(localized: "wind")): \(currentWeather.wind.speed) (\(currentWeather.wind.deg))"
        
        guard 
            let icon = currentWeather.weather.first?.icon,
            let iconUrl = Bundle.main.object(forInfoDictionaryKey: "iconUrl") as? String,
            let url = URL(string: "\(iconUrl)\(icon)@2x.png")
        else { return }
        
        iconImageView.imageFrom(url: url)
    }
    
    func showErrorMessage() {
        let alert = UIAlertController(
            title: nil, 
            message: String(localized: "error_message"), 
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(
            title: String(localized: "close"), 
            style: .default, 
            handler: nil
        ))
        self.present(alert, animated: true, completion: nil)
    }
}
