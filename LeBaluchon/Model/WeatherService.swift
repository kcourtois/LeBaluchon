//
//  WeatherService.swift
//  LeBaluchon
//
//  Created by Kévin Courtois on 09/05/2019.
//  Copyright © 2019 Kévin Courtois. All rights reserved.
//

import Foundation

struct WeatherResult {
    let city: String
    let weather: String
    let image: Data
}

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
    private var imageSession = URLSession(configuration: .default)
    private var task: URLSessionDataTask?
    private init() {}

    //Init used for tests
    init(weatherSession: URLSession, imageSession: URLSession) {
        self.weatherSession = weatherSession
        self.imageSession = imageSession
    }

    //Request to OpenWeather API, to retrieve weather at given coordinates
    func getWeather(coord: Coordinates, callback: @escaping (Bool, WeatherResult?) -> Void) {

        let components = URLComponents(string: "http://api.openweathermap.org/data/2.5/weather")

        guard var comp = components else {
            callback(false, nil)
            return
        }

        comp.queryItems = [URLQueryItem(name: "APPID", value: ApiKeys.openWeatherKey),
                           URLQueryItem(name: "lat", value: "\(coord.latitude)"),
                           URLQueryItem(name: "lon", value: "\(coord.longitude)"),
                           URLQueryItem(name: "lang", value: "fr"),
                           URLQueryItem(name: "units", value: "metric")]

        guard let url = comp.url else {
            callback(false, nil)
            return
        }

        var request = URLRequest(url: url)
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

                guard responseJSON.weather.indices.contains(0) else {
                    callback(false, nil)
                    return
                }

                self.getImage(weather: responseJSON.weather[0].main, completionHandler: { (data) in
                    guard let data = data else {
                        callback(false, nil)
                        return
                    }

                    let weatherResult = WeatherResult(city: responseJSON.name,
                                                      weather: "\(responseJSON.main.temp)°C, " +
                                                      "\(responseJSON.weather[0].description)",
                                                      image: data)

                    callback(true, weatherResult)
                })
            }
        }
        task?.resume()
    }

    //Request to Unsplash API, to get a random image for a weather keyword
    private func getImage(weather: String, completionHandler: @escaping ((Data?) -> Void)) {
        let pictureUrl = URL(string: "https://source.unsplash.com/500x400?\(weather)")!

        task?.cancel()
        task = imageSession.dataTask(with: pictureUrl) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    completionHandler(nil)
                    return
                }

                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    completionHandler(nil)
                    return
                }

                completionHandler(data)
            }
        }
        task?.resume()
    }
}
