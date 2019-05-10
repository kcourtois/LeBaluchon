//
//  WeatherService.swift
//  LeBaluchon
//
//  Created by Kévin Courtois on 09/05/2019.
//  Copyright © 2019 Kévin Courtois. All rights reserved.
//

import Foundation

struct WeatherRequest: Decodable {
    let weather: [Weather]
    let name: String
}

struct Weather: Decodable {
    // swiftlint:disable:next identifier_name
    let id: Int
    let main: String
    let description: String
    let icon: String
    //TODO: icon String to Enum
}

class WeatherService {
    static var shared = WeatherService()
    private var weatherSession = URLSession(configuration: .default)
    private let weatherUrlNemours =
        URL(string: "http://api.openweathermap.org/data/2.5/weather?APPID=\(ApiKeys.openWeatherKey)&q=Nemours,fr")!
    private var task: URLSessionDataTask?
    private init() {}

    init(weatherSession: URLSession) {
        self.weatherSession = weatherSession
    }

    func getWeather(callback: @escaping (Bool, WeatherRequest?) -> Void) {
        var request = URLRequest(url: weatherUrlNemours)
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
