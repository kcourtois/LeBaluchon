//
//  CountryTests.swift
//  LeBaluchonTests
//
//  Created by Kévin Courtois on 14/05/2019.
//  Copyright © 2019 Kévin Courtois. All rights reserved.
//

import Foundation
@testable import LeBaluchon
import XCTest

class CountryTests: XCTestCase {

    func testgetCountryInfoShouldPostFailedCallback() {
        // Given
        let countryService = CountryService(
            countrySession: URLSessionFake(data: nil, response: nil, error: FakeResponseData.error))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        countryService.getCountryInfo(country: "usa", callback: { (success, country) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(country)
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 0.01)
    }

    func testgetCountryInfoShouldPostFailedCallbackIfNoData() {
        // Given
        let countryService = CountryService(
            countrySession: URLSessionFake(data: nil, response: nil, error: nil))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        countryService.getCountryInfo(country: "usa", callback: { (success, country) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(country)
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 0.01)
    }

    func testgetCountryInfoShouldPostFailedCallbackIfIncorrectResponse() {
        // Given
        let countryService = CountryService(
            countrySession: URLSessionFake(
                data: FakeResponseData.countryCorrectData,
                response: FakeResponseData.responseKO,
                error: nil))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        countryService.getCountryInfo(country: "usa", callback: { (success, country) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(country)
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 0.01)
    }

    func testgetCountryInfoShouldPostFailedCallbackIfIncorrectData() {
        // Given
        let countryService = CountryService(
            countrySession: URLSessionFake(
                data: FakeResponseData.incorrectData,
                response: FakeResponseData.responseOK,
                error: nil))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        countryService.getCountryInfo(country: "usa", callback: { (success, country) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(country)
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 0.01)
    }

    func testgetCountryInfoShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
        // Given
        let countryService = CountryService(
            countrySession: URLSessionFake(
                data: FakeResponseData.countryCorrectData,
                response: FakeResponseData.responseOK,
                error: nil))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        countryService.getCountryInfo(country: "usa", callback: { (success, response) in
            // Then
            XCTAssertTrue(success)
            XCTAssertNotNil(response)

            let code = "USD"
            let nameCur = "United States dollar"
            let symbol = "$"

            let isoFirst = "en"
            let isoSec = "eng"
            let nameLang = "English"
            let natName = "English"

            XCTAssertEqual(code, response?.currencies[0].code)
            XCTAssertEqual(nameCur, response?.currencies[0].name)
            XCTAssertEqual(symbol, response?.currencies[0].symbol)

            XCTAssertEqual(isoFirst, response?.languages[0].iso639_1)
            XCTAssertEqual(isoSec, response?.languages[0].iso639_2)
            XCTAssertEqual(nameLang, response?.languages[0].name)
            XCTAssertEqual(natName, response?.languages[0].nativeName)

            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 0.01)
    }
}
