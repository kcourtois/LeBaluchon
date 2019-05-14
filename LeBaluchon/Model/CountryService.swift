//
//  CountriesService.swift
//  LeBaluchon
//
//  Created by Kévin Courtois on 14/05/2019.
//  Copyright © 2019 Kévin Courtois. All rights reserved.
//

import Foundation

struct CountryRequest: Decodable {
    let currencies: [Currency]
    let languages: [Language]
}

struct Currency: Decodable {
    let code: String
    let name: String
    let symbol: String
}

struct Language: Decodable {
    // swiftlint:disable:next identifier_name
    let iso639_1: String
    // swiftlint:disable:next identifier_name
    let iso639_2: String
    let name: String
    let nativeName: String
}

class CountryService {
    static var shared = CountryService()
    private var countrySession = URLSession(configuration: .default)
    private var task: URLSessionDataTask?
    private init() {}

    init(countrySession: URLSession) {
        self.countrySession = countrySession
    }

    func getCountryInfo(country: String, callback: @escaping (Bool, CountryRequest?) -> Void) {
        let countryUrl = URL(string: "https://restcountries.eu/rest/v2/name/\(country)")!
        var request = URLRequest(url: countryUrl)
        request.httpMethod = "GET"

        task?.cancel()
        task = countrySession.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    callback(false, nil)
                    return
                }

                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(false, nil)
                    return
                }

                guard let responseJSON = try? JSONDecoder().decode([CountryRequest].self, from: data) else {
                    callback(false, nil)
                    return
                }

                guard responseJSON.indices.contains(0) else {
                    callback(false, nil)
                    return
                }

                callback(true, responseJSON[0])
            }
        }
        task?.resume()
    }
}
