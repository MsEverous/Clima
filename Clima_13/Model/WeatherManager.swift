//
//  WeatherManager.swift
//  Clima_13
//
//  Created by Лариса Терегулова on 27.04.2023.
//

import Foundation

struct WeatherManager {
    //Example https://api.openweathermap.org/data/2.5/weather?q={city name}&appid={API key}
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?&appid=2814e050ead766897f7dc3295c0a0bba&units=metric"
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        print(urlString)
        performRequest(urlString: urlString)
    }
    
    func performRequest(urlString: String) {
        //1. Create a URL
        
        if let url = URL(string: urlString) {
            
            //2. Create a URL Session
            let session = URLSession(configuration: .default)
            
            //3. Give a session a task
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    print(error!)
                    return
                }
                if let safeData = data {
//                  let dataString = String(data: safeData, encoding: .utf8)
                    parseJSON(weatherData: safeData)
                }
            }
            //4. Start the task
            task.resume()
        }
    }
    
    func parseJSON(weatherData: Data) {
        let decoder = JSONDecoder()
        do {
            let decoderData = try decoder.decode(WeatherData.self, from: weatherData)
            print(decoderData.name)
            print(decoderData.main.temp)
            print(decoderData.weather[0].description)
            
        } catch {
            print(error)
        }
        
    }
}
