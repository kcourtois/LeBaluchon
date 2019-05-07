//
//  FakeResponseData.swift
//  LeBaluchonTests
//
//  Created by Kévin Courtois on 07/05/2019.
//  Copyright © 2019 Kévin Courtois. All rights reserved.
//

import Foundation

class FakeResponseData {
    // MARK: - Data
    static var exchangeRateCorrectData: Data? {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "TestExchangeRate", withExtension: "json")!
        // swiftlint:disable:next force_try
        return try! Data(contentsOf: url)
    }

    static let exchangeRateIncorrectData = "erreur".data(using: .utf8)!

    // MARK: - Response
    static let exchangeRateResponseOK = HTTPURLResponse(
        url: URL(string: "http://data.fixer.io/api/")!,
        statusCode: 200, httpVersion: nil, headerFields: [:])!

    static let exchangeRateResponseKO = HTTPURLResponse(
        url: URL(string: "http://data.fixer.io/api/")!,
        statusCode: 500, httpVersion: nil, headerFields: [:])!

    // MARK: - Error
    class ExchangeRateError: Error {}
    static let error = ExchangeRateError()
}
