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
        let url = bundle.url(forResource: "JSON/New_ExchangeRate", withExtension: "json")!
        // swiftlint:disable:next force_try
        return try! Data(contentsOf: url)
    }

    static var exchangeRateOldData: Data? {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "JSON/Old_ExchangeRate", withExtension: "json")!
        // swiftlint:disable:next force_try
        return try! Data(contentsOf: url)
    }

    static var translateCorrectData: Data? {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "JSON/Translate", withExtension: "json")!
        // swiftlint:disable:next force_try
        return try! Data(contentsOf: url)
    }

    static var weatherCorrectData: Data? {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "JSON/Weather", withExtension: "json")!
        // swiftlint:disable:next force_try
        return try! Data(contentsOf: url)
    }

    static var countryCorrectData: Data? {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "JSON/Country", withExtension: "json")!
        // swiftlint:disable:next force_try
        return try! Data(contentsOf: url)
    }

    static var geocodeCorrectData: Data? {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "JSON/Geocode", withExtension: "json")!
        // swiftlint:disable:next force_try
        return try! Data(contentsOf: url)
    }

    static let incorrectData = "erreur".data(using: .utf8)!
    static let imageData = "image".data(using: .utf8)!

    // MARK: - Response
    static let responseOK = HTTPURLResponse(
        url: URL(string: "http://www.test.com/api/")!,
        statusCode: 200, httpVersion: nil, headerFields: [:])!

    static let responseKO = HTTPURLResponse(
        url: URL(string: "http://www.test.com/api/")!,
        statusCode: 500, httpVersion: nil, headerFields: [:])!

    // MARK: - Error
    class ExchangeRateError: Error {}
    static let error = ExchangeRateError()
}
