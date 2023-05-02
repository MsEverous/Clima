//
//  ViewController.swift
//  Clima_13
//
//  Created by Лариса Терегулова on 27.04.2023.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var currentLocation: UIButton!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager() //Объект, который используется для запуска и остановки доставки событий, связанных с местоположением.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization() //Чтобы спрашивал разрешение на определение геопозиции
        //Также в info.plist надо добавить KEY: Privacy - Location When In Use Usage Description
        locationManager.delegate = self
        locationManager.requestLocation() //Разовое определение геопозиции
        weatherManager.delegate = self
        searchTextField.delegate = self
    }


    @IBAction func currentLocationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
//        print(searchTextField.text!)
    }
}

extension WeatherViewController: UITextFieldDelegate, WeatherManagerDelegate {
    //MARK: -UITextFieldDelegate
    //Спрашивает делегата, следует ли обрабатывать нажатие кнопки «Возврат» на клавиатуре для текстового поля.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
//        print(searchTextField.text!)
        return true
    }
    
    //Сообщает делегату, что делать когда редактирование прекращается для указанного текстового поля.
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = textField.text {
            weatherManager.fetchWeather(cityName: city)
        }
        textField.text = ""
    }
    
    //Спрашивает делегата, следует ли прекратить редактирование в указанном текстовом поле в случае чего то.
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Введите город"
            return false
        }
    }
    
    //MARK: -WeatherManagerDelegate
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.cityLabel.text = weather.cityName
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }

}

//MARK: -CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation() //Останавливает определение локации чтобы при нажатии на кнопку определении геопозиции функция reqestLocation отрабатывала
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

