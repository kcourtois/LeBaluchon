//
//  ExchangeRateService.swift
//  LeBaluchon
//
//  Created by Kévin Courtois on 06/05/2019.
//  Copyright © 2019 Kévin Courtois. All rights reserved.
//

import Foundation
import UIKit

struct RateRequest: Decodable {
    let success: Bool?
    let error: ErrorDecodeFixer?
    //let timestamp: Int?
    //let base: String?
    //let date: String?
    let rates: UsdRate?
}

struct UsdRate: Decodable {
    let USD: Float
}

struct ErrorDecodeFixer: Decodable {
    let code: Int
    let type: String
}

class ExchangeRateService {
    static var shared = ExchangeRateService()
    private var exchangeRateSession = URLSession(configuration: .default)
    private let fixerUrl = URL(string: "http://data.fixer.io/api/latest?access_key=\(ApiKeys.fixerKey)&symbols=USD")!
    private var task: URLSessionDataTask?
    private init() {}

    init(exchangeRateSession: URLSession) {
        self.exchangeRateSession = exchangeRateSession
    }

    func getRate(callback: @escaping (Bool, UsdRate?) -> Void) {
        var request = URLRequest(url: fixerUrl)
        request.httpMethod = "POST"

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

                callback(true, responseJSON.rates)
            }
        }
        task?.resume()
    }
}
