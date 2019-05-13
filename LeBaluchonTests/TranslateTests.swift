//
//  TranslateTests.swift
//  LeBaluchonTests
//
//  Created by Kévin Courtois on 10/05/2019.
//  Copyright © 2019 Kévin Courtois. All rights reserved.
//

import Foundation
@testable import LeBaluchon
import XCTest

class TranslateTests: XCTestCase {

    func testGetTranslateShouldPostFailedCallback() {
        // Given
        let translateService = TranslateService(
            translateSession: URLSessionFake(data: nil, response: nil, error: FakeResponseData.error))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translateService.getTranslation(text: "Bonjour, ceci est un test", callback: { (success, translate) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(translate)
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 0.01)
    }

    func testGetTranslateShouldPostFailedCallbackIfNoData() {
        // Given
        let translateService = TranslateService(
            translateSession: URLSessionFake(data: nil, response: nil, error: nil))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translateService.getTranslation(text: "Bonjour, ceci est un test", callback:  { (success, translate) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(translate)
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 0.01)
    }

    func testGetTranslateShouldPostFailedCallbackIfIncorrectResponse() {
        // Given
        let translateService = TranslateService(
            translateSession: URLSessionFake(
                data: FakeResponseData.translateCorrectData,
                response: FakeResponseData.responseKO,
                error: nil))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translateService.getTranslation(text: "Bonjour, ceci est un test", callback:  { (success, translate) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(translate)
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 0.01)
    }

    func testGetTranslateShouldPostFailedCallbackIfIncorrectData() {
        // Given
        let translateService = TranslateService(
            translateSession: URLSessionFake(
                data: FakeResponseData.incorrectData,
                response: FakeResponseData.responseOK,
                error: nil))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translateService.getTranslation(text: "Bonjour, ceci est un test", callback:  { (success, translate) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(translate)
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 0.01)
    }

    func testGetTranslateShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
        // Given
        let translateService = TranslateService(
            translateSession: URLSessionFake(
                data: FakeResponseData.translateCorrectData,
                response: FakeResponseData.responseOK,
                error: nil))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translateService.getTranslation(text: "Bonjour, ceci est un test", callback:  { (success, response) in
            // Then
            XCTAssertTrue(success)
            XCTAssertNotNil(response)

            let translatedText = "Hello, this is a test"

            XCTAssertEqual(translatedText, response?.data.translations[0].translatedText)

            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 0.01)
    }
}
