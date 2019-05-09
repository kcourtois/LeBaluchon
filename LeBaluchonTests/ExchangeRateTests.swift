//
//  ExchangeRateTests.swift
//  LeBaluchonTests
//
//  Created by Kévin Courtois on 06/05/2019.
//  Copyright © 2019 Kévin Courtois. All rights reserved.
//

import Foundation
@testable import LeBaluchon
import XCTest

class ExchangeRateTests: XCTestCase {

    override func setUp() {
        UserDefaults.standard.removeObject(forKey: ExchangeRateService.userDefaultsRateKey)
    }

    func testGetExchangeRateShouldPostFailedCallback() {
        // Given
        let exchangeRateService = ExchangeRateService(
            exchangeRateSession: URLSessionFake(data: nil, response: nil, error: FakeResponseData.error))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        exchangeRateService.getRate { (success, exchangeRate) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(exchangeRate)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }

    func testGetExchangeRateShouldPostFailedCallbackIfNoData() {
        // Given
        let exchangeRateService = ExchangeRateService(
            exchangeRateSession: URLSessionFake(data: nil, response: nil, error: nil))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        exchangeRateService.getRate { (success, exchangeRate) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(exchangeRate)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }

    func testGetExchangeRateShouldPostFailedCallbackIfIncorrectResponse() {
        // Given
        let exchangeRateService = ExchangeRateService(
            exchangeRateSession: URLSessionFake(
                data: FakeResponseData.exchangeRateCorrectData,
                response: FakeResponseData.exchangeRateResponseKO,
                error: nil))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        exchangeRateService.getRate { (success, exchangeRate) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(exchangeRate)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }

    func testGetExchangeRateShouldPostFailedCallbackIfIncorrectData() {
        // Given
        let exchangeRateService = ExchangeRateService(
            exchangeRateSession: URLSessionFake(
                data: FakeResponseData.exchangeRateIncorrectData,
                response: FakeResponseData.exchangeRateResponseOK,
                error: nil))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        exchangeRateService.getRate { (success, exchangeRate) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(exchangeRate)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }

    func testGetExchangeRateShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
        // Given
        let exchangeRateService = ExchangeRateService(
            exchangeRateSession: URLSessionFake(
                data: FakeResponseData.exchangeRateCorrectData,
                response: FakeResponseData.exchangeRateResponseOK,
                error: nil))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        exchangeRateService.getRate { (success, exchangeRate) in
            // Then
            XCTAssertTrue(success)
            XCTAssertNotNil(exchangeRate)

            let USD: Float = 1.118468

            XCTAssertEqual(USD, exchangeRate!.rates!.USD)

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }

    func testGetExchangeRateShouldPostSuccessCallbackIfUserdefaultsSet() {
        // Given
        UserDefaults.standard.set(FakeResponseData.exchangeRateCorrectData,
                                  forKey: ExchangeRateService.userDefaultsRateKey)
        let exchangeRateService = ExchangeRateService(
            exchangeRateSession: URLSessionFake(
                data: FakeResponseData.exchangeRateCorrectData,
                response: FakeResponseData.exchangeRateResponseOK,
                error: nil))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        exchangeRateService.getRate { (success, exchangeRate) in
            // Then
            XCTAssertTrue(success)
            XCTAssertNotNil(exchangeRate)

            let USD: Float = 1.118468

            XCTAssertEqual(USD, exchangeRate!.rates!.USD)

            expectation.fulfill()
        }
    }
}
