//
//  ViewController.swift
//  Clima_13
//
//  Created by Лариса Терегулова on 27.04.2023.
//

import UIKit

class WeatherViewController: UIViewController {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    let weatherManager = WeatherManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.delegate = self
    }


    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
        print(searchTextField.text!)
    }
}

extension WeatherViewController: UITextFieldDelegate {
    //Спрашивает делегата, следует ли обрабатывать нажатие кнопки «Возврат» на клавиатуре для текстового поля.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        print(searchTextField.text!)
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
}

