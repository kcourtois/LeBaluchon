//
//  WeatherService.swift
//  LeBaluchon
//
//  Created by Kévin Courtois on 09/05/2019.
//  Copyright © 2019 Kévin Courtois. All rights reserved.
//

import Foundation

struct WeatherRequest: Codable {
    let weather: [Weather]
    let main: Temperature
    let name: String
}

struct Weather: Codable {
    // swiftlint:disable:next identifier_name
    let id: Int
    let main: String
    let description: String
    let icon: String
    //TODO: icon image download https://openweathermap.org/weather-conditions
}

struct Temperature: Codable {
    let temp: Float
    let pressure: Float
    let humidity: Float
    // swiftlint:disable:next identifier_name
    let temp_min: Float
    // swiftlint:disable:next identifier_name
    let temp_max: Float
}

class WeatherService {
    static var shared = WeatherService()
    private var weatherSession = URLSession(configuration: .default)
    private var task: URLSessionDataTask?
    private init() {}

    init(weatherSession: URLSession) {
        self.weatherSession = weatherSession
    }

    func getWeather(coord: Coordinates, callback: @escaping (Bool, WeatherRequest?) -> Void) {
        // swiftlint:disable:next line_length
        let weatherUrl = URL(string: "http://api.openweathermap.org/data/2.5/weather?APPID=\(ApiKeys.openWeatherKey)&lat=\(coord.latitude)&lon=\(coord.longitude)&lang=fr&units=metric")!

        var request = URLRequest(url: weatherUrl)
        request.httpMethod = "GET"

        task?.cancel()
        task = weatherSession.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    callback(false, nil)
                    return
                }

                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(false, nil)
                    return
                }

                guard let responseJSON = try? JSONDecoder().decode(WeatherRequest.self, from: data) else {
                    callback(false, nil)
                    return
                }

                print(responseJSON)
                callback(true, responseJSON)
            }
        }
        task?.resume()
    }
}
