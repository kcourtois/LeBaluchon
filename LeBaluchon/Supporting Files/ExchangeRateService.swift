//
//  ExchangeRateService.swift
//  LeBaluchon
//
//  Created by Kévin Courtois on 06/05/2019.
//  Copyright © 2019 Kévin Courtois. All rights reserved.
//

import Foundation

struct RateRequest: Codable {
    let success: Bool?
    let error: ErrorDecodeFixer?
    let date: String?
    let rates: [String: Double]
}

struct ErrorDecodeFixer: Codable {
    let code: Int
    let type: String
}

class ExchangeRateService {
    static var shared = ExchangeRateService()
    static let userDefaultsRateKey = "RateRequest"
    private var exchangeRateSession = URLSession(configuration: .default)
    private let fixerUrl = URL(string: "http://data.fixer.io/api/latest?access_key=\(ApiKeys.fixerKey)")!
    private var task: URLSessionDataTask?
    private init() {}

    //Init used for tests
    init(exchangeRateSession: URLSession) {
        self.exchangeRateSession = exchangeRateSession
    }

    //Request to Fixer API, to retrieve exchange rates
    func getRate(callback: @escaping (Bool, RateRequest?) -> Void) {
        if needsNewRates() {
            var request = URLRequest(url: fixerUrl)
            request.httpMethod = "GET"

            task?.cancel()
            task = exchangeRateSession.dataTask(with: request) { (data, response, error) in
                DispatchQueue.main.async {
                    guard let data = data, error == nil else {
                        callback(false, nil)
                        return
                    }

                    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                        callback(false, nil)
                        return
                    }

                    guard let responseJSON = try? JSONDecoder().decode(RateRequest.self, from: data),
                        responseJSON.success == true, responseJSON.error == nil else {
                            callback(false, nil)
                            return
                    }
                    self.storeRateRequest(rateRequest: data)
                    callback(true, responseJSON)
                }
            }
            task?.resume()
        } else {
            callback(true, readRateRequest())
        }
    }

    private func needsNewRates() -> Bool {
        guard let rateRequest = readRateRequest(), let dateStored = rateRequest.date else {
            return true
        }
        if dateStored == getStringDate() {
            return false
        } else {
            return true
        }
    }

    private func getStringDate() -> String {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = Date()
        return dateFormatter.string(from: date)
    }

    private func storeRateRequest(rateRequest: Data) {
        UserDefaults.standard.set(rateRequest, forKey: ExchangeRateService.userDefaultsRateKey)
    }

    private func readRateRequest() -> RateRequest? {
        if let data = UserDefaults.standard.data(forKey: ExchangeRateService.userDefaultsRateKey) {
            guard let rateRequest = try? JSONDecoder().decode(RateRequest.self, from: data) else {
                return nil
            }
            return rateRequest
        } else {
            return nil
        }
    }
}
